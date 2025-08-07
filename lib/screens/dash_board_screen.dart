import 'package:al_ummah_institute/controllers/fee_controller.dart';
import 'package:al_ummah_institute/controllers/students_controller.dart';
import 'package:al_ummah_institute/controllers/time_table_controller.dart';
import 'package:al_ummah_institute/helpers/colors.dart';
import 'package:al_ummah_institute/helpers/extensions.dart';
import 'package:al_ummah_institute/screens/invoices.dart';
import 'package:al_ummah_institute/screens/leave_request_screen.dart';
import 'package:al_ummah_institute/screens/personal_information_screen.dart';
import 'package:al_ummah_institute/screens/show_result_screen.dart';
import 'package:al_ummah_institute/screens/show_time_table.dart';
import 'package:al_ummah_institute/screens/student_detail_screen2.dart';
import 'package:al_ummah_institute/screens/student_fee_screen_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'notifications.dart';

class DashBoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StudentsController studentsController = Get.find<StudentsController>();
    TimeTableController timeTableController = Get.put(TimeTableController());

    final student = studentsController.studentData.isNotEmpty
        ? studentsController.studentData.first
        : {};


    return Scaffold(
      backgroundColor: Colors.white, // screen white
      drawer: Drawer(
        child: ListView(
          children: [

            UserAccountsDrawerHeader(
              accountName: Text(student['name'] ?? 'No name'),
              accountEmail: Text(student['reg_no'].toString()),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(student['picture_url'] ??
                    'https://defaultimage.com/avatar.png'),
              ),
              decoration: BoxDecoration(color: drawerContainer),
            ),
            buildDrawerTile(Icons.dashboard, "Dashboard", darkRed, darkRed, () {}),
            Divider(height: 40),
            buildDrawerTile(Icons.face, "Personal Information", drawerContainer,
                drawerContainer, () {
                  context.openScreen(StudentDetailScreen2(student: student.cast<String, dynamic>()));
                }),
            buildDrawerTile(Icons.menu_book, "Results and Exams", drawerContainer,
                drawerContainer, () {context.openScreen(ShowResultScreen());}),
            buildDrawerTile(Icons.notifications, "Notifications", drawerContainer,
                drawerContainer, () {
                  context.openScreen(Notifications());
                }),
            buildDrawerTile(Icons.how_to_reg, "Enrollments", drawerContainer,
                drawerContainer, () {}),
            buildDrawerTile(Icons.schedule, "Time Table", drawerContainer,
                drawerContainer, () {
                  context.openScreen(ShowTimeTable(className: student['class']));
                }),

            buildDrawerTile(Icons.receipt_long, "Invoices", drawerContainer,
                drawerContainer, () {
                  FeeController ctrl = Get.find<FeeController>();
                  ctrl.selectedStudent = student.cast<String, dynamic>();  // Ensure correct type
                  ctrl.fetchFees(); // You can optionally call this early if needed
                  context.openScreen(StudentFeesScreen2());
                }),
            buildDrawerTile(Icons.schedule, "Requests", drawerContainer,
                drawerContainer, () {
                  context.openScreen(LeaveRequestScreen());
                }),

          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: appBarBlue,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                  'assets/images/WhatsApp Image 2025-06-22 at 11.46.14_8a6cdfc1.jpg'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Doctor's College Junior School",
                style: GoogleFonts.lato(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Section
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(student['picture_url'] ??
                  'https://defaultimage.com/avatar.png'),
            ),
            const SizedBox(height: 10),
            Text(
              student['name'] ?? '',
              style: GoogleFonts.lato(
                color:drawerContainer,
                  fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              student['father_name']?.toString() ?? '',
              style:
              GoogleFonts.lato(fontSize: 14, color: Colors.grey[700]),
            ),
            Text(
              student['reg_no'] .toString()?? '',
              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              alignment: WrapAlignment.center,
              children: [
                _buildTag("Promoted"),
                _buildTag(student['class'] ?? 'Class'),
              ],
            ),
            const SizedBox(height: 20),
            Divider(thickness: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school),
                SizedBox(width:5),
                Text("Academic Standings",
                    style: GoogleFonts.lato(
                        fontSize: 18,
                        color:drawerContainer,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            Text("Percentage",
                style:
                GoogleFonts.lato(fontSize: 14, color: Colors.black)),
            const SizedBox(height: 6),
            Text(student['percentage'], style: GoogleFonts.lato(fontSize: 16,fontWeight:FontWeight.bold)),


            const SizedBox(height: 30),

            // Today's Classes
            const Divider(thickness: 1, height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Icon(Icons.class_,
                  color:drawerContainer,

                ),
                 SizedBox(width:5),
                Text("Today’s Classes",
                    style: GoogleFonts.lato(
                        fontSize: 18,
                        color:drawerContainer,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height:30),
            Text(
              "No class is scheduled",
              style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 30),

            // News & Announcements
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications,
                  color:drawerContainer,
                ),
                SizedBox(width:5),
                Text("News & Announcements",
                    style: GoogleFonts.lato(
                        fontSize: 18,
                        color:drawerContainer,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(thickness: 1, height: 20),
            Text(
              "No announcements yet.",
              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: drawerContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget buildDrawerTile(
      IconData icon,
      String title,
      Color color,
      Color fontColor,
      VoidCallback onPress,
      ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title,
          style: TextStyle(color: fontColor, )),
      onTap: onPress,
    );
  }
}
