// ✅ Updated AddTime with dynamic classes from students table
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/time_table_controller.dart';
import '../../helpers/colors.dart';
import '../../helpers/extensions.dart';

class AddTime extends StatelessWidget {
  AddTime({super.key});

  final RxList<String> classNames = <String>[].obs;
  final TextEditingController assemblyTimeController = TextEditingController();
  final List<TextEditingController> periodTimeControllers =
  List.generate(7, (_) => TextEditingController());
  final RxList<List<Map<String, TextEditingController>>> timetableControllers =
      <List<Map<String, TextEditingController>>>[].obs;

  final timeTableController = Get.put(TimeTableController());

  void initializeControllers() async {
    final list = await timeTableController.fetchUniqueClassNames();
    classNames.clear(); // ✅ Pehle reactive list clear karo
    classNames.addAll(list); // ✅ Phir usme values add karo

    timetableControllers.assignAll(
      List.generate(
        list.length,
            (_) => List.generate(
          7,
              (_) => {
            'teacher': TextEditingController(),
            'subject': TextEditingController(),
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeControllers();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        title: const Text("Editable Time Table"),

        elevation: 0,
      ),
      body: Obx(
            () => classNames.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _headerSection(),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: const Offset(4, 4),
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      blurRadius: 10,
                      offset: Offset(-4, -4),
                    ),
                  ],
                ),
                child: Table(
                  border: TableBorder.all(color: Colors.transparent),
                  defaultColumnWidth: const FixedColumnWidth(150),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: Colors.teal.shade100.withOpacity(0.5),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                      ),
                      children: [
                        _buildHeaderCell("Timings"),
                        for (int i = 0; i < 7; i++)
                          _buildPeriodTimeField(i, "Period \${i + 1}"),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildHeaderCell("Lectures"),
                        ...List.generate(7, (index) => _buildHeaderCell("")),
                      ],
                    ),
                    for (int rowIndex = 0;
                    rowIndex < classNames.length;
                    rowIndex++)
                      TableRow(
                        children: [
                          _buildHeaderCell(classNames[rowIndex]),
                          ...List.generate(
                            7,
                                (periodIndex) => _buildTeacherSubjectCell(
                                timetableControllers[rowIndex][periodIndex]),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: drawerContainer,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                ),
                onPressed: () async {
                  final assemblyText = assemblyTimeController.text.trim();
                  if (!assemblyText.contains("-")) {
                    context.showSnackBar(
                        "Please use format like: 8:00 - 8:30 for Assembly");
                    return;
                  }

                  final parts = assemblyText.split("-");
                  final startTime = parts[0].trim();
                  final endTime = parts[1].trim();

                  for (final className in classNames) {
                    await timeTableController.addTimeTable(
                      startTime: startTime,
                      endTime: endTime,
                      className: className,
                      periodNumber: 0,
                      teacherName: '',
                      subjectName: 'Assembly',
                    );
                  }

                  for (int i = 0; i < classNames.length; i++) {
                    for (int j = 0; j < 7; j++) {
                      final teacher = timetableControllers[i][j]['teacher']!.text.trim();
                      final subject = timetableControllers[i][j]['subject']!.text.trim();
                      final periodTime = periodTimeControllers[j].text.trim();

                      if (teacher.isNotEmpty || subject.isNotEmpty) {
                        if (!periodTime.contains("-")) {
                          context.showSnackBar(
                              "Use format like: 8:00 - 8:45 for periods");
                          return;
                        }

                        final parts = periodTime.split("-");
                        final start = parts[0].trim();
                        final end = parts[1].trim();

                        await timeTableController.addTimeTable(
                          startTime: start,
                          endTime: end,
                          className: classNames[i],
                          periodNumber: j + 1,
                          teacherName: teacher,
                          subjectName: subject,
                        );
                      }
                    }
                  }

                  assemblyTimeController.clear();
                  for (var controller in periodTimeControllers) controller.clear();
                  for (var row in timetableControllers) {
                    for (var cell in row) {
                      cell['teacher']?.clear();
                      cell['subject']?.clear();
                    }
                  }

                  context.showSnackBar("Time Table saved and fields cleared.");
                },
                child: const Text("💾 Save Time Table"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 10,
            offset: Offset(-4, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(
                    'assets/images/WhatsApp Image 2025-06-22 at 11.46.14_8a6cdfc1.jpg'),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Doctor's Junior School",
                      style: TextStyle(
                          color: myGreyColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("Rawalpindi Campus",
                      style: TextStyle(color: myGreyColor, fontSize: 18)),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "Assembly Time:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: assemblyTimeController,
                  decoration: InputDecoration(
                    hintText: "e.g. 8:00 - 8:30",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPeriodTimeField(int index, String labelText) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: periodTimeControllers[index],
        decoration: InputDecoration(
          labelText: labelText,
          hintText: "e.g. 9:00 - 9:45",
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherSubjectCell(Map<String, TextEditingController> cell) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            TextFormField(
              controller: cell['teacher'],
              decoration: const InputDecoration(
                labelText: "Teacher",
                filled: true,
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: cell['subject'],
              decoration: const InputDecoration(
                labelText: "Subject",
                filled: true,
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
