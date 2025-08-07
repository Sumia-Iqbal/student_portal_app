import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/leave_controller.dart';
import '../helpers/colors.dart';

class LeaveRequestScreen extends StatelessWidget {
  final controller = Get.put(LeaveController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f7fb),
      appBar: AppBar(
        title: Text("Leave Application"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🏫 School Name
              Center(
                child: Text(
                  "Al-Ummah Leaders Institute",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),

              // To Principal
              Text("To,"),
              Text("The Principal,"),
              Text("Respected Sir/Madam,"),
              SizedBox(height: 10),

              // Leave Request Body (Editable like letter)
              Text("Subject: Application for Leave", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextField(
                controller: controller.reasonCtrl,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: "I am [Student Name] of class [Class] kindly grant me leave from [Date] to [Date] due to [Reason]...",
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),

              SizedBox(height: 30),

              Divider(),
              SizedBox(height: 10),

              // From
              _buildLineField("From", controller.nameCtrl),

              // Class
              _buildLineField("Class", controller.classCtrl),

              // Date
              Obx(() => _buildDatePickerLine("Date", controller.fromDate.value,
                      (date) => controller.fromDate.value = date)),

              // Parent Signature
              SizedBox(height: 20),
              Text("Parent's Signature:", style: TextStyle(fontWeight: FontWeight.w600)),
              Obx(() => GestureDetector(
                onTap: controller.pickSignature,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                  controller.signatureImage.value != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(controller.signatureImage.value!, fit: BoxFit.contain),
                  )
                      : Center(
                    child: Icon(Icons.upload_file, size: 40, color: Colors.grey),
                  ),
                ),
              )),

              SizedBox(height: 30),
              Center(
                child:
                Obx(() {
                  return controller.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: drawerContainer,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: controller.submitLeave,
                    icon: Icon(Icons.send, color: Colors.white),
                    label: Text("Submit Request", style: TextStyle(color: Colors.white)),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLineField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          SizedBox(width: 70, child: Text("$label:")),
          Expanded(
            child: TextField(
              controller: ctrl,
              enabled: false, // 🔒 make read-only
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerLine(String label, DateTime? date, Function(DateTime) onPicked) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text("$label:")),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: Get.context!,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(Duration(days: 30)),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
              if (pickedDate != null) {
                onPicked(pickedDate);
              }
            },
            child: Text(date != null
                ? "${date.toLocal()}".split(' ')[0]
                : "Pick Date"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        )
      ],
    );
  }
}
