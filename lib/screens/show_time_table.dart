import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/time_table_controller.dart';
import '../../helpers/colors.dart';

class ShowTimeTable extends StatelessWidget {
  final String className;

  ShowTimeTable({super.key, required this.className}) {
    final controller = Get.put(TimeTableController());
    controller.fetchTimeTableForClass(className.trim());  }

  final TimeTableController timeTableController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Disable text scaling globally for this screen
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: drawerContainer,
          title: Text(
            "Time Table - $className",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18, // Fixed font size
            ),
          ),
        ),
        body: Obx(() {
          if (timeTableController.classTimeTable.isEmpty) {
            return const Center(
              child: Text(
                "No Time Table Found.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final assembly = timeTableController.classTimeTable
              .firstWhereOrNull((row) => row['period_number'] == 0);

          final periods = timeTableController.classTimeTable
              .where((row) => row['period_number'] != 0)
              .toList();

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(
                          'assets/images/WhatsApp Image 2025-06-22 at 11.46.14_8a6cdfc1.jpg'),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Doctor's Junior School",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Rawalpindi Campus",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (assembly != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text(
                      "Assembly Time: ${assembly['start_time']} - ${assembly['end_time']}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      border: TableBorder.all(),
                      defaultColumnWidth: const FixedColumnWidth(140),
                      children: [
                        TableRow(
                          decoration:
                          BoxDecoration(color: Colors.grey.shade300),
                          children: [
                            _headerCell("Period"),
                            _headerCell("Timing"),
                            _headerCell("Teacher"),
                            _headerCell("Subject"),
                          ],
                        ),
                        for (var row in periods)
                          TableRow(
                            children: [
                              _cellText("Period ${row['period_number']}"),
                              _cellText(
                                  "${row['start_time']} - ${row['end_time']}"),
                              _cellText(
                                row['teacher_name'].toString().isEmpty
                                    ? "-"
                                    : row['teacher_name'],
                              ),
                              _cellText(row['subject_name']),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _cellText(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
