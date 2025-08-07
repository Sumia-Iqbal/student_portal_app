import 'package:al_ummah_institute/helpers/colors.dart';
import 'package:flutter/material.dart';

class PersonalInformationScreen extends StatelessWidget {
  Map<dynamic,dynamic> student;
   PersonalInformationScreen({required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Personal Information",
          style: TextStyle(
            color: drawerContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nationality Information",
                  style: TextStyle(
                    fontSize: 18,
                    color:drawerContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 10,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildField("Nationality Type", student['nationality'], bold: true),
                            SizedBox(height: 20),
                            _buildField("Country of Birth", "Pakistan"),
                            SizedBox(height: 20),
                            _buildField("CNIC/NICOP", student['cnic_number'].toString(), bold: true),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.refresh, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Please update and save your personal information first, and then add your mandatory academic history by clicking on 'Add New' tab below and save the changes",
                  style: TextStyle(
                    color: appBarBlue,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Academic History",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String title, String value, {bool bold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Divider(height:30),
      ],
    );
  }
}
