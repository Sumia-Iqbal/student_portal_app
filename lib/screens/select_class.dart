import 'package:al_ummah_institute/screens/result_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/colors.dart';

class SelectClass extends StatelessWidget {
  final RxString selectedClass = ''.obs;
  final RxString selectedSemester = ''.obs;

  final List<String> classes = [
    'Class PG/Nur',

    'Class one',
    'Class two',
    'Class Three',
    'Class 4th',
    'Class 5th',
    'Class 6th',
    'Class 7th',
    'Class 8th',
    'Class 9th',
    'Class 10th',
  ];

  final List<String> semesters = ['1st', '2nd', '3rd', '4th'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Students Result")),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Text(
                "Select student's Class",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: drawerContainer,
                ),
              ),
              const SizedBox(height: 15),

              // Class Selector
              Obx(() => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: classes.map((cls) {
                  final isSelected = selectedClass.value == cls;

                  return GestureDetector(
                    onTap: () => selectedClass.value = cls,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? drawerContainer
                            : drawerContainer.withOpacity(0.5),
                        border: Border.all(
                          color: isSelected
                              ? drawerContainer.withOpacity(0.5)
                              : Colors.grey,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.3),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Text(
                        cls,
                        style: TextStyle(
                          color:
                          isSelected ? Colors.white : drawerContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),

              const SizedBox(height: 25),
              const Divider(thickness: 3),
              const SizedBox(height: 15),

              Text(
                "Select semester",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: drawerContainer,
                ),
              ),
              const SizedBox(height: 20),

              // Semester Selector
              Obx(() => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: semesters.map((semester) {
                  final isSelected = selectedSemester.value == semester;

                  return GestureDetector(
                    onTap: () => selectedSemester.value = semester,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? drawerContainer
                            : drawerContainer.withOpacity(0.5),
                        border: Border.all(
                          color: isSelected
                              ? drawerContainer.withOpacity(0.5)
                              : Colors.grey,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.3),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Text(
                        semester,
                        style: TextStyle(
                          color:
                          isSelected ? Colors.white : drawerContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),

              const SizedBox(height: 20),

              // Add Results Button (Reactive)
              Obx(() {
                return selectedClass.value.isNotEmpty &&
                    selectedSemester.value.isNotEmpty
                    ? ElevatedButton(
                  onPressed: () {
                    Get.to(() => ResultEntryScreen(
                      selectedClass: selectedClass.value
                          .replaceAll('Class ', '')
                          .trim(),
                      selectedSemester: selectedSemester.value,
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: drawerContainer,
                  ),
                  child: const Text(
                    "Add Results",
                    style:
                    TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )
                    : const SizedBox.shrink(); // empty placeholder
              }),
            ],
          ),
        ),
      ),
    );
  }
}
