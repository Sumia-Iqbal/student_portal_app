import 'package:al_ummah_institute/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/students_controller.dart';
import '../controllers/time_table_controller.dart';

class StudentDashBoard extends StatelessWidget {
  const StudentDashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RxInt selectedIndex = 0.obs;
    StudentsController studentsController = Get.put(StudentsController());
    TimeTableController timeTableController = Get.put(TimeTableController());

    final student = studentsController.studentData.isNotEmpty
        ? studentsController.studentData.first
        : {};
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (student['class'] != null && student['class']
          .toString()
          .isNotEmpty) {
        timeTableController.fetchTimeTableForClass(student['class']);
      }
    });
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    List categories = [
      ['Academic\nstatus', Icons.rocket_launch, boxBlueColor],
      ['home work', Icons.sticky_note_2, boxColor2],
      [
        'home work', Icons.person, Colors.amberAccent
      ]
    ];

    final periods = timeTableController.classTimeTable
        .where((row) => row['period_number'] != 0)
        .toList();

    return Scaffold(


        backgroundColor: bgColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.055),
                  Stack(clipBehavior: Clip.none, children: [
                    Container(
                        width: width,
                        height: height * 0.4,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20))),
                    Positioned(
                        top: -40,
                        left: width / 2 - 60,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kPrimaryColor.withOpacity(0.4),
                            border: Border.all(color: Colors.white, width: 2),
                            image: DecorationImage(
                                fit: BoxFit.cover, image: NetworkImage(
                              student['picture_url'],)

                            ),
                          ),
                        )),
                    Positioned(
                      top: 70,
                      left: 100,
                      child:
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          student['name'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 120,
                      left: width / 2 - 50,
                      child: Text("${student['class']} Grade",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 15,
                          )),
                    ),
                    Positioned(
                      top: 200,
                      left: 10,
                      child: SizedBox(
                        width: width * 0.89, // 👈 constrain width here
                        height: 60,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 10),
                                        blurRadius: 10,
                                        spreadRadius: 10,
                                        color: kPrimaryColor.withOpacity(0.4)

                                    )
                                  ]
                              ),
                              child: Row(
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: categories[index][2],
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Icon(
                                          categories[index][1], size: 20,
                                          color: Colors.white)),
                                  SizedBox(width: 10),
                                  Text(
                                    categories[index][0],
                                    style: GoogleFonts.inter(fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                      ),
                    ),
                    Positioned(
                        bottom: -15,
                        left: 0,
                        right: 0,

                        child: Container(
                            width: width,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(color: kSecondaryColor,
                                borderRadius: BorderRadius.circular(16)
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(children: [
                                Container(
                                    margin: EdgeInsets.only(right: 24),
                                    padding: EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                        color: kSecondaryColor2,
                                        borderRadius: BorderRadius.circular(16)
                                    ),
                                    child: Column(
                                        children: [
                                          Text("B+",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              )
                                          ),
                                          Text("Letter grade",
                                              style: TextStyle(
                                                color: Colors.white70,

                                              )
                                          )

                                        ]
                                    )
                                ),

                                Container(
                                    margin: EdgeInsets.only(right: 24),

                                    padding: EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                        color: kSecondaryColor2,
                                        borderRadius: BorderRadius.circular(16)
                                    ),
                                    child: Column(
                                        children: [
                                          Text("B+",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              )
                                          ),
                                          Text("Letter grade",
                                              style: TextStyle(
                                                color: Colors.white70,

                                              )
                                          )

                                        ]
                                    )
                                ),
                                Container(
                                    margin: EdgeInsets.only(right: 24),

                                    padding: EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                        color: kSecondaryColor2,
                                        borderRadius: BorderRadius.circular(16)
                                    ),
                                    child: Column(
                                        children: [
                                          Text("B+",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              )
                                          ),
                                          Text("Letter grade",
                                              style: TextStyle(
                                                color: Colors.white70,

                                              )
                                          )

                                        ]
                                    )
                                )
                              ]),
                            )

                        ))
                  ]),
                  SizedBox(height: 50),
                  Text("Monday,22 April",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 25
                      )

                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Obx(() {
                      final periods = timeTableController.classTimeTable
                          .where((row) => row['period_number'] != 0)
                          .toList();

                      if (periods.isEmpty) {
                        return Center(
                          child: Text(
                            "No timetable found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: periods.length,
                        itemBuilder: (context, index) {
                          final row = periods[index];

                          return Container(
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "${row['start_time'] ??
                                      ''} - ${row['end_time'] ?? ''}",
                                  style: TextStyle(color: greyColor),
                                ),
                                SizedBox(width: 20),
                                Container(
                                    height: 30, width: 2, color: Colors.grey),
                                SizedBox(width: 30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      row['subject_name'] ?? '',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: subjectColor,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?w=500',
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          row['teacher_name'] ?? '',
                                          style: TextStyle(color: teacherColor),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  )
                ]),
          ),
        ));
  }


}