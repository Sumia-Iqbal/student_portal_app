import 'dart:developer';

import 'package:al_ummah_institute/controllers/students_controller.dart';
import 'package:al_ummah_institute/helpers/extensions.dart';
import 'package:al_ummah_institute/screens/teacher_dash_board.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../helpers/colors.dart';

class AddInfoScreen extends StatelessWidget {
  const AddInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StudentsController studentsController = Get.put(StudentsController());
    TextEditingController nameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController regNoController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController statusController = TextEditingController();
    TextEditingController percentageController = TextEditingController();
    TextEditingController studentNoController = TextEditingController();
    TextEditingController parentsNoController = TextEditingController();
    TextEditingController nationalityController = TextEditingController();
    TextEditingController joinDateController = TextEditingController();
    TextEditingController campusController = TextEditingController();
    TextEditingController gradeController = TextEditingController();
    TextEditingController cnicController = TextEditingController();

    return Scaffold(
        body: Stack(children: [
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  'assets/images/WhatsApp Image 2025-06-22 at 11.46.09_529b70e0.jpg'),
              fit: BoxFit.fitHeight),
        ),
      ),
      Center(
        child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: blueColor.withOpacity(0.7)),
            child: SingleChildScrollView(
              child: Column(children: [
                CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                        'assets/images/WhatsApp Image 2025-06-22 at 11.46.14_8a6cdfc1.jpg')),
                _buildTextField("Name", nameController),
                _buildTextField("Password", passwordController),

                _buildTextField("Reg No", regNoController),
                _buildTextField("CNIC number", cnicController),
                _buildTextField("Address", addressController),
                _buildTextField("Join Date", joinDateController),
                _buildTextField("Class ", gradeController),
                _buildTextField("Campus ", campusController),
                _buildTextField("status", statusController),
                _buildTextField("Percentage", percentageController),
                _buildTextField("nationality", nationalityController),
                _buildTextField("Students Number", studentNoController),
                _buildTextField("Parents Number", parentsNoController),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    onPressed: ()async {
                      var name = nameController.text;
                      var regNumber = regNoController.text;
                      var cnicNumber = cnicController.text;
                      var  percentage = percentageController.text;
                      var password = passwordController.text;
                      var status = statusController.text;
                      var address = addressController.text;
                      var studentNumber = studentNoController.text;
                      var parentsNumber = parentsNoController.text;
                      var nationality = nationalityController.text;
                      var joinDate = joinDateController.text;
                      var campus = campusController.text;
                      var grade = gradeController.text;
                      try{
                        var response =await studentsController.addStudents(name, regNumber, cnicNumber, password, address, studentNumber, parentsNumber, nationality, status, grade, percentage, joinDate, campus);
                        if(response!= null){
                          context.showSnackBar('Student added successfully');
                          context.openScreen(TeacherDashBoard());
                        }else{
                          context.showSnackBar("Went Some thing wrong");
                        }
                      }catch(e){
                        log(e.toString());
                        context.showSnackBar(e.toString());
                      }
                    },
                    child:
                        Text("Add Student", style: TextStyle(color: Colors.white)),
                  ),
                )
              ]),
            )),
      )
    ]));
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
