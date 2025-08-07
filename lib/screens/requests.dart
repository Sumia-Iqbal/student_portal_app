import 'dart:convert';
import 'package:al_ummah_institute/helpers/extensions.dart';
import 'package:al_ummah_institute/screens/show_request.dart';
import 'package:flutter/material.dart';

class Requests extends StatelessWidget {
  final List<Map<String, dynamic>> leaveData;

  const Requests({Key? key, required this.leaveData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leave Requests")),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: leaveData.length,
        itemBuilder: (context, index) {
          final request = leaveData[index];
          final student = request['students'] ?? {};
          final signature = request['parent_signature'];
          final decodedSignature = signature != null ? base64Decode(signature) : null;

          return GestureDetector(
            onTap:(){context.openScreen(ShowRequest(request: request));},
            child: Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue.shade50,
                    child:Icon(Icons.person,color: Colors.blue,)
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${student['name'] ?? 'N/A'}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Class: ${student['class'] ?? 'N/A'}\nFrom: ${request['from_date']}",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: request['status'] == 'approved'
                          ? Colors.green.shade100
                          : request['status'] == 'rejected'
                          ? Colors.red.shade100
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      request['status'].toString().toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: request['status'] == 'approved'
                            ? Colors.green
                            : request['status'] == 'rejected'
                            ? Colors.red
                            : Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
