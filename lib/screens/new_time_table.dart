import 'package:al_ummah_institute/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/time_table_controller.dart';

class NewTimeTable extends StatelessWidget {
  final String className;

  NewTimeTable({Key? key, required this.className}) : super(key: key) {
    controller.fetchTimeTableForClass(className.trim());
  }

  final TimeTableController controller = Get.put(TimeTableController());

  final List<Color> boxColors = [
    Colors.green.withOpacity(0.7),
    Colors.orange.shade300,
    Colors.blue.shade300,
    Colors.pink.shade300,
    Colors.green.shade400,
    Colors.teal.shade200,
    Colors.yellow.shade300,
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Table"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey.withOpacity(0.8)),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Time",
                    style: TextStyle(
                      color: Colors.grey.withOpacity(0.9),
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(width: 50),
                  Text(
                    "Subject",
                    style: TextStyle(
                      color: Colors.grey.withOpacity(0.9),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(() {
                  final data = controller.classTimeTable
                      .where((e) => e['period_number'] != 0)
                      .toList();

                  if (data.isEmpty) {
                    return const Center(child: Text("No Time Table Found"));
                  }

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final period = data[index];
                      final Color boxColor = boxColors[index % boxColors.length];

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(
                                period['start_time'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                period['end_time'],
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(16),
                            width: width * 0.68,
                            decoration: BoxDecoration(
                              color: boxColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  period['subject_name'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.person, color: Colors.black),
                                    const SizedBox(width: 30),
                                    Text(
                                      period['teacher_name'].toString().isEmpty
                                          ? "-"
                                          : period['teacher_name'],
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
