import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fee_controller.dart';
import '../helpers/colors.dart';
import 'student_fees_screen.dart';

class FeeManagementScreen extends StatelessWidget {
  final FeeController ctrl = Get.put(FeeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🎓 Fee Management"),
        backgroundColor: drawerContainer,
        elevation: 4,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (ctrl.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Class",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              // Dropdown
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(12),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  value: ctrl.selectedClass.isEmpty ? null : ctrl.selectedClass,
                  items: ctrl.classes.map<DropdownMenuItem<String>>((c) {
                    return DropdownMenuItem<String>(
                      value: c['class'].toString(),
                      child: Text(c['class'].toString()),
                    );
                  }).toList(),
                  onChanged: (val) {
                    ctrl.selectedClass = val!;
                    ctrl.fetchStudentsByClass(val);
                  },
                  hint: const Text("Choose a class"),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                "Students",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              // Students List
              Expanded(
                child: ctrl.students.isEmpty
                    ? const Center(
                  child: Text("🙁 No students found.",
                      style: TextStyle(fontSize: 16)),
                )
                    : ListView.builder(
                  itemCount: ctrl.students.length,
                  itemBuilder: (_, i) {
                    final s = ctrl.students[i];
                    return GestureDetector(
                      onTap: () {
                        ctrl.selectedStudent = s;
                        Get.to(() => StudentFeesScreen());
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage:
                              NetworkImage(s['picture_url']),
                              backgroundColor: Colors.grey[200],
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Reg #: ${s['reg_no']}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 18),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
