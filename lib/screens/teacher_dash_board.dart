import 'package:al_ummah_institute/controllers/leave_controller.dart';
import 'package:al_ummah_institute/helpers/colors.dart';
import 'package:al_ummah_institute/helpers/extensions.dart';
import 'package:al_ummah_institute/screens/add_info_screen.dart';
import 'package:al_ummah_institute/screens/fee_management_screen.dart';
import 'package:al_ummah_institute/screens/requests.dart';
import 'package:al_ummah_institute/screens/select_class.dart';
import 'package:al_ummah_institute/screens/show_request.dart';
import 'package:al_ummah_institute/screens/student_detail_screen.dart';
import 'package:al_ummah_institute/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/students_controller.dart';
import 'add_notification_screen.dart';
import 'add_time.dart';

class TeacherDashBoard extends StatelessWidget {
  final StudentsController studentsController = Get.put(StudentsController());
  final TextEditingController searchController = TextEditingController();

  final LeaveController leaveController = Get.put(LeaveController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.openScreen(SignUpScreen());
        },
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Doctor's Junior School"),
              accountEmail: Text('Rawalpindi Campus', style: TextStyle(fontSize: 14)),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/WhatsApp Image 2025-06-22 at 11.46.14_8a6cdfc1.jpg'),
              ),
              decoration: BoxDecoration(color: drawerContainer),
            ),
            buildDrawerTile(Icons.dashboard, 'Dashboard',  () {}),
            buildDrawerTile(Icons.chat, "Add students' result",  () {
              context.openScreen(SelectClass());
            }),
            buildDrawerTile(Icons.timer_outlined, 'Update College Schedule',  () {
              context.openScreen(AddTime());
            }),
            buildDrawerTile(Icons.notification_add, 'Add Update',() {
              context.openScreen(AddNotificationScreen());
            }),
            buildDrawerTile(Icons.payment, 'Fee Management', () {
              context.openScreen(FeeManagementScreen());
            }),
            buildDrawerTile(Icons.receipt, "Student's requests", ()async {
              await leaveController.fetchAllLeaveRequests();  // 👈 fetch data first
              context.openScreen(Requests(leaveData: leaveController.leaveRequests.toList()));
            }),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: RefreshIndicator(
            onRefresh: () => studentsController.fetchAllStudents(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                border: Border.all(color: drawerContainer.withOpacity(0.5), width: 2),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextFormField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.search),
                                  hintText: "Search for students",
                                  hintStyle: TextStyle(color: Colors.black26),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      searchController.clear();
                                      studentsController.fetchAllStudents();
                                    },
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    studentsController.fetchAllStudents();
                                  } else {
                                    studentsController.searchStudents(value);
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              border: Border.all(color: drawerContainer.withOpacity(0.5), width: 2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.tune, color: Colors.black),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
                Obx(() {
                  if (studentsController.students.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Text("No students found."),
                        ),
                      ),
                    );
                  }

                  return SliverToBoxAdapter(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 3; // Default for mobile/tablet
                        if (constraints.maxWidth > 700) {
                          crossAxisCount =6; // Web/Desktop
                        }

                        return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 20,
                            mainAxisExtent: 300,
                          ),
                          itemCount: studentsController.students.length,
                          itemBuilder: (context, index) {
                            var student = studentsController.students[index];
                            return GestureDetector(
                              onTap: () {
                                context.openScreen(StudentDetailScreen(
                                  student: student,
                                  heroTag: student['id'].toString(),
                                ));
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 140,
                                          width: double.infinity,
                                          child: Hero(
                                            tag: student['id'].toString(),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: Image.network(
                                                student['picture_url'] ?? '',
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Text(student['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                    Text(student['father_name'] ?? "", style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(student['reg_no'].toString(), style: TextStyle(fontSize: 19)),
                                      ],
                                    ),
                                    Spacer(),
                                    Center(
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: drawerContainer,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(Icons.add, color: Colors.white),
                                      ),
                                    ),
                                    Spacer()
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                })
              ],
            ),

        ),
      ),
    );
  }

  Widget buildDrawerTile(
      IconData icon,
      String title,

      VoidCallback onPress,
      ) {
    return ListTile(
      leading: Icon(icon, color: drawerContainer),
      title: Text(
        title,
        style: TextStyle(
          color: drawerContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onPress,
    );
  }
}
