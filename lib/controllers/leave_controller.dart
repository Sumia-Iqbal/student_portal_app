import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../helpers/constants.dart';
import 'students_controller.dart'; // make sure this is correctly imported

class LeaveController extends GetxController {
  final nameCtrl = TextEditingController();
  final classCtrl = TextEditingController();
  final reasonCtrl = TextEditingController();

  var fromDate = Rxn<DateTime>();
  var toDate = Rxn<DateTime>();
  var signatureImage = Rxn<Uint8List>();

  var isLoading = false.obs;

  final StudentsController studentsController = Get.find<StudentsController>();
  var leaveRequests = <Map<String, dynamic>>[].obs;
  var statusMap = <String, RxString>{}.obs;


  Future pickSignature() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) {
      final bytes = await img.readAsBytes();
      signatureImage.value = bytes;
    }
  }

  Future<void> submitLeave() async {
    if (fromDate.value == null || reasonCtrl.text.trim().isEmpty) {
      Get.snackbar("Error", "Please fill all fields.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black87);
      return;
    }

    isLoading.value = true;

    try {
      final student = studentsController.loggedInStudent.value;

      if (student == null) {
        Get.snackbar("Error", "No logged-in student found.");
        isLoading.value = false;
        return;
      }

      final studentId = student['id'];
      nameCtrl.text = student['name'] ?? '';
      classCtrl.text = student['class'] ?? '';

      await supabase.from('leave_requests').insert({
        'student_id': studentId,
        'reason': reasonCtrl.text.trim(),
        'from_date': fromDate.value!.toIso8601String(),
        'to_date': toDate.value?.toIso8601String(),
        'parent_signature': signatureImage.value != null
            ? base64Encode(signatureImage.value!)
            : null,
        'status': 'pending',
      });

      Get.snackbar("Success", "Leave request submitted",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black87);
    } catch (e) {
      log("Error submitting leave: $e");
      Get.snackbar("Error", "Failed to submit leave: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black87);
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> fetchLeaveRequests() async {
  //   try {
  //     isLoading.value = true;
  //
  //     final response = await supabase
  //         .from('leave_requests')
  //         .select('''
  //         id,
  //         student_id,
  //         reason,
  //         from_date,
  //         to_date,
  //         status,
  //         parent_signature,
  //         students (
  //           name,
  //           class
  //         )
  //       ''')
  //         .order('created_at', ascending: false);
  //
  //     leaveRequests.value = List<Map<String, dynamic>>.from(response);
  //   } catch (e) {
  //     log("Error fetching leave requests: $e");
  //     Get.snackbar("Error", "Failed to fetch leave requests",
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.red.shade100,
  //         colorText: Colors.black87);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future<void> fetchAllLeaveRequests() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('leave_requests')
          .select('''
          id,
          student_id,
          reason,
          from_date,
          to_date,
          status,
          parent_signature,
          students (
            name,
            class
          )
        ''')
          .order('created_at', ascending: false);

      leaveRequests.value = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      log("❌ Error fetching all leave requests: $e");
      Get.snackbar("Error", "Failed to fetch leave requests",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black87);
    } finally {
      isLoading.value = false;
    }
  }
  void initStatus(String requestId, String status) {
    if (!statusMap.containsKey(requestId)) {
      statusMap[requestId] = status.obs;
    }
  }

  void updateStatus(String requestId, String newStatus) {
    statusMap[requestId]?.value = newStatus;
  }

  Future<void> acceptRequest(String requestId) async {
    await Supabase.instance.client
        .from('leave_requests')
        .update({'status': 'approved'})
        .eq('id', requestId);
  }

  Future<void> rejectRequest(String requestId) async {
    await Supabase.instance.client
        .from('leave_requests')
        .update({'status': 'rejected'})
        .eq('id', requestId);
  }
}


