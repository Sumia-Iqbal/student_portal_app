import 'dart:developer';
import 'package:al_ummah_institute/controllers/result_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/students_controller.dart';
import '../helpers/colors.dart';

class ShowResultScreen extends StatelessWidget {
  final supabase = Supabase.instance.client;
  final ResultController resultController = Get.put(ResultController());
  final studentController = Get.find<StudentsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final student = studentController.loggedInStudent.value;

      if (student == null) {
        return const Scaffold(
          body: Center(child: Text("No student is logged in.")),
        );
      }

      final studentId = student['id'];

      return Scaffold(
        appBar: AppBar(title: const Text("My Results")),
        body: FutureBuilder<Map<String, dynamic>?>(
          future: resultController.fetchStudentWithResults(studentId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("No results found or student not registered."));
            }

            final studentData = snapshot.data!['student'];
            final results = snapshot.data!['results'] as List<Map<String, dynamic>>;

            if (results.isEmpty) {
              return const Center(child: Text("No results added yet."));
            }

            // Group results by semester
            final groupedBySemester = <String, List<Map<String, dynamic>>>{};
            for (var result in results) {
              final semester = result['semester'] ?? 'Unknown';
              groupedBySemester.putIfAbsent(semester, () => []).add(result);
            }

            final totalObtained = results.fold<int>(
              0,
                  (sum, res) {
                final obtained = res['obtained_marks'];
                final obtainedInt = (obtained is num)
                    ? obtained.toInt()
                    : int.tryParse(obtained.toString()) ?? 0;
                return sum + obtainedInt;
              },
            );

            final totalMarks = results.fold<int>(
              0,
                  (sum, res) {
                final total = res['total_marks'];
                final totalInt = (total is num)
                    ? total.toInt()
                    : int.tryParse(total.toString()) ?? 0;
                return sum + totalInt;
              },
            );


            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Student Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Color(0x29000000), blurRadius: 12, offset: Offset(4, 4)),
                      BoxShadow(color: Colors.white, blurRadius: 6, offset: Offset(-4, -4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: studentData['picture_url'] != null &&
                            studentData['picture_url'].toString().isNotEmpty
                            ? NetworkImage(studentData['picture_url'])
                            : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(studentData['name'] ?? '',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: drawerContainer)),
                            const SizedBox(height: 4),
                            Text("${studentData['father_name'] ?? ''}",
                                style: const TextStyle(fontSize: 16, color: Colors.black)),
                            const SizedBox(height: 4),
                            Text("Reg No: ${studentData['reg_no'] ?? ''}",
                                style: const TextStyle(fontSize: 16, color: Colors.black54)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Semester-wise Results
                ...groupedBySemester.entries.map((entry) {
                  final semester = entry.key;
                  final subjectResults = entry.value;

                  // Calculate per-semester total
                  final semesterObtained = subjectResults.fold<int>(
                    0,
                        (sum, res) {
                      final obtained = res['obtained_marks'];
                      final obtainedInt = (obtained is num)
                          ? obtained.toInt()
                          : int.tryParse(obtained.toString()) ?? 0;
                      return sum + obtainedInt;
                    },
                  );

                  final semesterTotal = subjectResults.fold<int>(
                    0,
                        (sum, res) {
                      final total = res['total_marks'];
                      final totalInt = (total is num)
                          ? total.toInt()
                          : int.tryParse(total.toString()) ?? 0;
                      return sum + totalInt;
                    },
                  );

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Color(0x29000000), blurRadius: 12, offset: Offset(4, 4)),
                        BoxShadow(color: Colors.white, blurRadius: 6, offset: Offset(-4, -4)),
                      ],
                    ),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Semester: $semester",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: drawerContainer),
                        ),
                        const SizedBox(height: 10),

                        ...subjectResults.map((res) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(color: Color(0x15000000), blurRadius: 6, offset: Offset(2, 2)),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(res['subject'] ?? '',
                                      style: const TextStyle(fontWeight: FontWeight.w600)),
                                ),
                                Expanded(
                                  child: Text("Obt: ${res['obtained_marks']}",
                                      style: const TextStyle(fontWeight: FontWeight.w600)),
                                ),
                                Expanded(
                                  child: Text("Total: ${res['total_marks']}",
                                      style: const TextStyle(fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        const SizedBox(height: 15),

                        // ✅ Show correct semester total and obtained marks here
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Icon(Icons.assignment_ind, color: drawerContainer.withOpacity(0.5)),
                              const SizedBox(width: 10),
                              Text("Total Marks",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: drawerContainer)),
                              const SizedBox(width: 10),
                              Text("$semesterTotal",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: drawerContainer,
                                      decoration: TextDecoration.underline)),
                            ]),
                            Row(children: [
                              Text("Obtained Marks",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: drawerContainer)),
                              const SizedBox(width: 10),
                              Text("$semesterObtained",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: drawerContainer,
                                      decoration: TextDecoration.underline)),
                            ]),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),

                // Final Total Section
              ],
            );
          },
        ),
      );
    });
  }
}
