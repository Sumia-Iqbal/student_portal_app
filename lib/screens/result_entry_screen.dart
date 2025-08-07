import 'dart:developer';
import 'package:al_ummah_institute/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/result_controller.dart';
import '../controllers/students_controller.dart';

class ResultEntryScreen extends StatelessWidget {
  final String selectedClass;
  final String selectedSemester;

  ResultEntryScreen({
    required this.selectedClass,
    required this.selectedSemester,
  });

  final StudentsController studentsController = Get.put(StudentsController());
  final ResultController resultController = Get.put(ResultController());

  final Map<String, List<String>> classSubjects = {
    '9th': ['Urdu', 'Math', 'English', 'Physics', 'Biology'],
    '10th': ['Urdu', 'Math', 'English', 'Chemistry', 'Biology'],
    '1st': ['Urdu', 'Math', 'Islamiat'],
    '2nd': ['Urdu', 'Math', 'Islamiat'],
    '3rd': ['Urdu', 'Math', 'English'],
    '4th': ['Urdu', 'Math', 'Science'],
    '5th': ['Urdu', 'Math', 'Science', 'English'],
    '6th': ['English', 'Math', 'Science', 'History'],
    '7th': ['English', 'Math', 'Science', 'Computer'],
    '8th': ['English', 'Math', 'Islamiat', 'Geography'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Class $selectedClass')),
      body: Container(
          decoration: const BoxDecoration(
            // gradient: LinearGradient(
            //   colors: [Color(0xFFE0F7FA), Color(0xFFFFFFFF)],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
          ),
          padding: const EdgeInsets.all(12),
          child: Obx(() {
            final allStudents = studentsController.students;

            final filteredStudents = allStudents.where((student) {
              final studentClass = (student['class'] ?? '').toString().trim().toLowerCase();
              final selected = selectedClass.trim().toLowerCase();
              return studentClass == selected;
            }).toList();

            if (allStudents.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (filteredStudents.isEmpty) {
              return Center(child: Text('No students found for "$selectedClass"'));
            }

            final studentSubjectControllers = <String, Map<String, Map<String, TextEditingController>>>{};

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = filteredStudents[index];
                      final subjects = classSubjects[selectedClass.toLowerCase()] ?? ['Urdu', 'Math'];

                      final subjectControllers = <String, Map<String, TextEditingController>>{};
                      for (var subject in subjects) {
                        subjectControllers[subject] = {
                          'obtained': TextEditingController(),
                          'total': TextEditingController(),
                        };
                      }
                      studentSubjectControllers[student['id']] = subjectControllers;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(color: Color(0x29000000), blurRadius: 12, offset: Offset(4, 4)),
                            BoxShadow(color: Colors.white, blurRadius: 6, offset: Offset(-4, -4)),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: student['picture_url'] != null &&
                                        student['picture_url'].toString().isNotEmpty
                                        ? NetworkImage(student['picture_url'])
                                        : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(student['name'] ?? 'Unnamed',
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 2),
                                        Text(student['father_name'] ?? '',
                                            style: const TextStyle(fontSize: 16, color: Colors.black54)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Icon(Icons.how_to_reg, color: drawerContainer.withOpacity(0.7)),
                                  const SizedBox(width: 10),
                                  const Text("Reg no: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text("${student['reg_no']}", style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ...subjects.map((subject) => SubjectInputRow(
                                subject: subject,
                                obtainedController: subjectControllers[subject]!['obtained']!,
                                totalController: subjectControllers[subject]!['total']!,
                              )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                GestureDetector(onTap: () async {
                  final resultData = <Map<String, dynamic>>[];

                  for (final student in filteredStudents) {
                    final subjectControllers = studentSubjectControllers[student['id']];
                    if (subjectControllers == null) continue;

                    final subjectData = <Map<String, dynamic>>[];
                    subjectControllers.forEach((subject, controllers) {
                      final obtained = int.tryParse(controllers['obtained']!.text.trim()) ?? 0;
                      final total = int.tryParse(controllers['total']!.text.trim()) ?? 0;

                      if (obtained > 0 || total > 0) {
                        subjectData.add({
                          'name': subject,
                          'obtained_marks': obtained,
                          'total_marks': total,
                        });
                      }
                    });

                    if (subjectData.isNotEmpty) {
                      resultData.add({
                        'student_id': student['id'],
                        'student_name': student['name'],
                        'subjects': subjectData,
                      });
                    }
                  }

                  if (resultData.isEmpty) {
                    Get.snackbar("Empty", "Please enter at least one mark.");
                  } else {
                    log("🚀 Sending resultData:");
                    log(resultData.toString());
                    await resultController.addResults(resultData, selectedSemester, selectedClass);
                  }
                },
                  child: Container(
                    width:MediaQuery.of(context).size.width*0.6,
                    padding:EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:drawerContainer,
                      borderRadius: BorderRadius.circular(16),

                    ),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                      Icon(Icons.save,color:Colors.white),
                      Text("Save All Results",
                      style: TextStyle(
                        color:Colors.white
                      ),
                      )
                    ])
                  ),
                ),
                // ElevatedButton.icon(
                //
                //   icon: const Icon(Icons.save),
                //   label: const Text("Save All Results"),
                //   onPressed:
                //       () async {
                //     final resultData = <Map<String, dynamic>>[];
                //
                //     for (final student in filteredStudents) {
                //       final subjectControllers = studentSubjectControllers[student['id']];
                //       if (subjectControllers == null) continue;
                //
                //       final subjectData = <Map<String, dynamic>>[];
                //       subjectControllers.forEach((subject, controllers) {
                //         final obtained = int.tryParse(controllers['obtained']!.text.trim()) ?? 0;
                //         final total = int.tryParse(controllers['total']!.text.trim()) ?? 0;
                //
                //         if (obtained > 0 || total > 0) {
                //           subjectData.add({
                //             'name': subject,
                //             'obtained_marks': obtained,
                //             'total_marks': total,
                //           });
                //         }
                //       });
                //
                //       if (subjectData.isNotEmpty) {
                //         resultData.add({
                //           'student_id': student['id'],
                //           'student_name': student['name'],
                //           'subjects': subjectData,
                //         });
                //       }
                //     }
                //
                //     if (resultData.isEmpty) {
                //       Get.snackbar("Empty", "Please enter at least one mark.");
                //     } else {
                //       log("🚀 Sending resultData:");
                //       log(resultData.toString());
                //       await resultController.addResults(resultData, selectedSemester, selectedClass);
                //     }
                //   },
                // ),
                // const SizedBox(height: 20),
              ],
            );
          }),
        ),

    );
  }
}

class SubjectInputRow extends StatelessWidget {
  final String subject;
  final TextEditingController obtainedController;
  final TextEditingController totalController;

  SubjectInputRow({
    required this.subject,
    required this.obtainedController,
    required this.totalController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x15000000),
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(subject,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: drawerContainer)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              child: TextField(
                controller: obtainedController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Obt.",
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  filled: true,
                  fillColor: Colors.white,
                  border:InputBorder.none
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              child: TextField(
                controller: totalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Total",
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
