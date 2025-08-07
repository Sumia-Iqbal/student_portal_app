import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/time_table_controller.dart';
import '../../helpers/colors.dart';

class Invoices extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: drawerContainer,
        title: Text("Invoices", style: TextStyle(color: Colors.white)),
      ),
      body:
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                      'assets/images/WhatsApp Image 2025-06-22 at 11.46.14_8a6cdfc1.jpg'),
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    Text("Doctor's Junior School",
                        style: TextStyle(color: myGreyColor, fontSize: 24)),
                    SizedBox(height: 10),
                    Text("Rawalpindi Campus",
                        style: TextStyle(color: myGreyColor, fontSize: 18)),
                  ],
                ),
              ]),
              SizedBox(height: 20),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Table(
                    border: TableBorder.all(),
                    defaultColumnWidth: const FixedColumnWidth(140),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey[300]),
                        children: [
                          _headerCell("Student Name"),
                          _headerCell("CNIC number"),
                          _headerCell("Class"),
                          _headerCell("Admission"),
                          _headerCell("Security fee"),
                          _headerCell("Tution fee"),
                          _headerCell("Total fee"),

                        ],
                      ),

                      // Loop through periods

                      TableRow(
                        children: [
                          _cellText("Aysha"),
                          _cellText("353012367908"),
                          _cellText("12th"),
                          _cellText("2000"),
                          _cellText(7000.toString()),
                          _cellText(8000.toString()),
                          _cellText("17000"),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )

    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
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
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
