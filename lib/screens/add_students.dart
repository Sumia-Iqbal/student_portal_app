import 'package:flutter/material.dart';

import '../helpers/colors.dart';

class AddStudents extends StatelessWidget {
  const AddStudents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController userNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      body:Stack(
        children:[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'assets/images/WhatsApp Image 2025-06-22 at 11.46.09_529b70e0.jpg'),
                  fit: BoxFit.fitHeight),
            ),
          ),
          Center(
            child:
            Container(
                padding: EdgeInsets.all(30),
                height: 400,
                width: 400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: blueColor.withOpacity(0.7)),
                child: Column(children: [
                  CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/WhatsApp Image 2025-06-22 at 11.46.14_8a6cdfc1.jpg')
                  ),


                  TextFormField(
                      controller:emailController,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: "Email",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Default border color
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Border color when focused
                        ),
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      )),
                  SizedBox(height: 10),
                  TextFormField(
                      controller:passwordController,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: "Password",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Default border color
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Border color when focused
                        ),
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      )),
                  SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed:(){},



                      child:
                      Text("Log In", style: TextStyle(color: Colors.white)),
                    ),
                  )
                ])),
          )

        ]
      )
    );
  }
}
