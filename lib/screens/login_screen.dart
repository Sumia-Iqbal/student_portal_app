import 'package:al_ummah_institute/screens/student_dash_board.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/students_controller.dart';
import '../helpers/colors.dart';
import '../helpers/extensions.dart';
import 'dash_board_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StudentsController studentsController = Get.put(StudentsController());
    TextEditingController cnicController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    // Get screen width & height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/WhatsApp Image 2025-06-22 at 11.46.09_529b70e0.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Login Card Centered
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: screenWidth>700?screenWidth * 0.3:screenWidth*0.8, // 80% of screen width
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: blueColor.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'assets/images/WhatsApp Image 2025-06-22 at 11.46.14_8a6cdfc1.jpg'),
                    ),
                    const SizedBox(height: 20),

                    // CNIC Field
                    TextFormField(
                      controller: cnicController,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration("CNIC Number"),
                    ),

                    const SizedBox(height: 16),

                    // Password Field
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration("Password"),
                    ),

                    const SizedBox(height: 30),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          var cnic = cnicController.text.trim();
                          var password = passwordController.text.trim();

                          var loginResult = await studentsController
                              .loginUser(cnic, password);

                          if (loginResult == 'success') {
                            await studentsController.fetchStudentData(
                                cnic, password);
                            context.openScreen(StudentDashBoard());
                          } else {
                            context
                                .showSnackBar("Invalid CNIC or Password");
                          }
                        },
                        child: const Text(
                          "Log In",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }
}
