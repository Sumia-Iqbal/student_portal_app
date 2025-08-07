import 'package:al_ummah_institute/helpers/extensions.dart';
import 'package:flutter/material.dart';

import '../helpers/colors.dart';

class StudentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> student;
  final String heroTag;

  const StudentDetailScreen({Key? key, required this.student, required this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.width;
    double width = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child:
        LayoutBuilder(builder: (context,constraints){
          return         ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(Icons.arrow_back_ios_new),
                  ),
                  Text(
                    "Details",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.favorite_outline),
                ],
              ),
              SizedBox(height: 15),
              Hero(
                tag: heroTag,
                child: ClipRRect(

                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    student['picture_url'],
                    height: constraints.maxWidth>700?700:270,
                    width:constraints.maxWidth>700?width*0.2:width,

                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: 100),
                  ),
                ),
              ),
              SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text(
                          student['name'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),



                        SizedBox(height: 5),
                        Text(
                          'Muhammad Aslam',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black45,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          student['reg_no']?.toString() ?? '',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text("CNIC number",
                                style:TextStyle(
                                    fontSize:16
                                )),
                            SizedBox(width:10),
                            Text(student['cnic_number'].toString(),
                                style:TextStyle(color:drawerContainer.withOpacity(0.7))
                            )
                          ],
                        ),
                      ]),
                  Column(
                    children: [
                      Text('${student['class']} class',
                          style:TextStyle(
                              fontSize: 20,
                              fontWeight:FontWeight.bold
                          )),
                      SizedBox(height:10),
                      Container(
                          height:40,
                          width:90,
                          decoration: BoxDecoration(
                              color:drawerContainer,
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child:Center(
                            child: Text(student['status'],
                                style:TextStyle(color:Colors.white)
                            ),
                          )
                      ),


                    ],

                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(thickness: 5),
              rowColumn(Icons.language, "Nationality", student['nationality']),
              rowColumn(Icons.home, "Address", student['address']),
              rowColumn(Icons.phone_android, "Student Phone Number", student['student_number'].toString()),
              rowColumn(
                  Icons.call,
                  "Parents Phone number",
                  student['parents_number'].toString()
              )
            ],
          );


        })
        ),

    );
  }
  Widget rowColumn(icon,String title,String subtitle,){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        SizedBox(height:15),
        Row(
          children: [
            Icon(icon,
                color:drawerContainer.withOpacity(0.6)
            ),
            SizedBox(width:5),
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 15),
        Text(
         subtitle,
          style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.bold),
        ),
      ]
    );
  }
}
