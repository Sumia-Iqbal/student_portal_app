import 'dart:developer';
import 'dart:io';
import 'package:al_ummah_institute/controllers/students_controller.dart';
import 'package:al_ummah_institute/helpers/extensions.dart';
import 'package:al_ummah_institute/screens/login_screen.dart';
import 'package:al_ummah_institute/screens/teacher_dash_board.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/colors.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StudentsController studentsController = Get.put(StudentsController());

    final nameController = TextEditingController();
    final passwordController = TextEditingController();
    final regNoController = TextEditingController();
    final addressController = TextEditingController();
    final statusController = TextEditingController();
    final percentageController = TextEditingController();
    final studentNoController = TextEditingController();
    final parentsNoController = TextEditingController();
    final nationalityController = TextEditingController();
    final joinDateController = TextEditingController();
    final campusController = TextEditingController();
    final gradeController = TextEditingController();
    final cnicController = TextEditingController();

    return Scaffold(

      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/WhatsApp Image 2025-06-22 at 11.46.09_529b70e0.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(color: Colors.black.withOpacity(0.4)), // Dark overlay
          ),

          // Form Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                constraints: const BoxConstraints(maxWidth: 570),
                decoration: BoxDecoration(
                  color: blueColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() {
                      final image = studentsController.selectedImage.value;
                      return CircleAvatar(
                        radius: 45,
                        backgroundImage: image != null
                            ? FileImage(image)
                            : const AssetImage('assets/images/WhatsApp Image 2025-06-22 at 11.46.14_8a6cdfc1.jpg') as ImageProvider,
                      );
                    }),
                    const SizedBox(height: 16),
                    const Text(
                      "Add New Student",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const SizedBox(height: 12),

                    ElevatedButton.icon(
                      onPressed: () async {
                        await studentsController.pickImageFromGallery();
                      },
                      icon: const Icon(Icons.photo, color: Colors.white),
                      label: const Text("Upload Student Picture", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildTextField("Name", nameController),
                    _buildTextField("Password", passwordController),
                    _buildTextField("Reg No", regNoController),
                    _buildTextField("CNIC number", cnicController),
                    _buildTextField("Address", addressController),
                    _buildTextField("Join Date", joinDateController),
                    _buildTextField("Class", gradeController),
                    _buildTextField("Campus", campusController),
                    _buildTextField("Status", statusController),
                    _buildTextField("Percentage", percentageController),
                    _buildTextField("Nationality", nationalityController),
                    _buildTextField("Students Number", studentNoController),
                    _buildTextField("Parents Number", parentsNoController),

                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async
                        {
                          try {
                            var response =
                            await studentsController.addStudents(
                                                  nameController.text,
                              regNoController.text,
                              cnicController.text,
                              passwordController.text,
                              addressController.text,
                              studentNoController.text,
                              parentsNoController.text,
                              nationalityController.text,
                              statusController.text,
                              gradeController.text,
                              percentageController.text,
                              joinDateController.text,
                              campusController.text,
                            );
                            // context.openScreen(TeacherDashBoard());
                            if(response!=null){
                              Get.showSnackbar(GetSnackBar(message: 'Student added successfully',));
                              context.openScreen(TeacherDashBoard());

                            }
                            else{
                              Get.showSnackbar(GetSnackBar(message:'Get something wrong',backgroundColor: Colors.white54,));
                            }
                          } catch (e) {
                            log(e.toString());
                            Get.showSnackbar(GetSnackBar(message:e.toString()));
                          }
                        },
                        child: const Text("Add Student", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          // Force underline to always show
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white70, width: 1.5),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
          ),
          // This line is important:
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
        ),
      ),
    );
  }

}
