import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/leave_controller.dart';
import '../helpers/colors.dart';

class ShowRequest extends StatelessWidget {
  final Map<String, dynamic> request;
  final LeaveController ctrl = Get.put(LeaveController());

  ShowRequest({Key? key, required this.request}) : super(key: key) {
    // Initialize observable status when widget is created
    ctrl.initStatus(request['id'].toString(), request['status'] ?? 'pending');
  }

  @override
  Widget build(BuildContext context) {
    final signature = request['parent_signature'];
    final decodedSignature = signature != null ? base64Decode(signature) : null;
    final student = request['students'] ?? {};

    final requestId = request['id'].toString();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        title: const Text("Leave Application"),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderText("To,"),
              _buildBodyText("The Principal,\nAl-Ummah Institute,\nCity XYZ."),

              const SizedBox(height: 16),
              _buildBodyText(
                "Respected Sir/Madam,\n\nI, ${student['name'] ?? '__________'}, "
                    "a student of class ${student['class'] ?? '_____'}, request leave for the following reason:\n",
              ),

              _buildReasonBox(request['reason'] ?? 'N/A'),

              const SizedBox(height: 20),
              _buildBodyText("Kindly grant me leave as requested.\n\nThanking you,\nYours obediently,\n\n${student['name'] ?? '__________'}"),

              const SizedBox(height: 24),
              _buildLabelText("Parent Signature"),
              const SizedBox(height: 8),
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: decodedSignature != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(decodedSignature, fit: BoxFit.contain),
                )
                    : const Center(child: Text("No Signature Provided")),
              ),

              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: Obx(() => _buildStatusStamp(ctrl.statusMap[requestId]?.value ?? 'pending')),
              ),

              const SizedBox(height: 32),
              Divider(height: 3, color: Colors.grey.shade300),
              const SizedBox(height: 16),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.check_circle,
                    label: 'Approve',
                    color: drawerContainer,
                    onPressed: () async {
                      await ctrl.acceptRequest(requestId);
                      ctrl.updateStatus(requestId, 'approved');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Request Approved")),
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.cancel,
                    label: 'Reject',
                    color: drawerContainer.withOpacity(0.3),
                    onPressed: () async {
                      await ctrl.rejectRequest(requestId);
                      ctrl.updateStatus(requestId, 'rejected');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Request Rejected")),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20, color: Colors.white),
      label: Text(label, style: const TextStyle(fontSize: 15)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.9),
        foregroundColor: Colors.white,
        elevation: 1,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15.5,
        height: 1.7,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildLabelText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget _buildReasonBox(String reason) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: drawerContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: drawerContainer.withOpacity(0.4), width: 2),
      ),
      child: Text(
        reason,
        style: TextStyle(
          fontSize: 15,
          fontStyle: FontStyle.italic,
          color: Colors.blueGrey.shade900,
        ),
      ),
    );
  }

  Widget _buildStatusStamp(String status) {
    Color color;
    String label;

    switch (status.toLowerCase()) {
      case 'approved':
        color = Colors.green.shade600;
        label = "APPROVED";
        break;
      case 'rejected':
        color = Colors.red.shade600;
        label = "REJECTED";
        break;
      default:
        color = drawerContainer.withOpacity(0.5);
        label = "PENDING";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 14,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
