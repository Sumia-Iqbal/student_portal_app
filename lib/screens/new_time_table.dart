import 'package:flutter/material.dart';

class NewTimeTable extends StatelessWidget {
  const NewTimeTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:Text("Sumia Iqbal"),
      leading:IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios,color:Colors.grey.withOpacity(0.8)))
      ),
      body: SafeArea(
        child: Padding(
          padding:EdgeInsets.all(24),
          child: Column(
            children:[
              Row(
                children:[
                  Text("Time",
                  style:TextStyle(
                    color:Colors.grey.withOpacity(0.9),
                    fontSize:17
                  )
                  ),
                  SizedBox(width:30),
                  Text("Subject",
                      style:TextStyle(
                          color:Colors.grey.withOpacity(0.9),
                        fontSize:18
                      )
                  ),

                ]
              )
            ]
          ),
        ),
      )
    );
  }
}
