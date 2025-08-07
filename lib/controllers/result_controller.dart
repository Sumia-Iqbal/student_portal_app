import 'dart:developer';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../helpers/constants.dart';

class ResultController extends GetxController {
  Future<void> addResults(
      List<Map<String, dynamic>> students,
      String selectedSemester,
      String selectedClass) async {
    final supabase = Supabase.instance.client;

    try {
      for (var student in students) {
        final studentId = student['student_id'];
        final studentName = student['student_name'];

        final subjectEntries = student['subjects'] as List<Map<String, dynamic>>;

        final inserts = subjectEntries.map((subject) {
          return {
            'student_id': studentId,
            'name': studentName,
            'semester': selectedSemester,
            'class': selectedClass,
            'subject': subject['name'],
            'obtained_marks': subject['obtained_marks'],
            'total_marks': subject['total_marks'],
          };
        }).toList();

        await supabase.from('results').insert(inserts);
      }

      Get.snackbar("✅ Success", "All results added successfully");
    } catch (e) {
      Get.snackbar("❌ Error", "Failed to add results: $e");
      log("📛 addResults error: $e");
    }
  }
  Future<Map<String, dynamic>?> fetchStudentWithResults(String studentId) async {
    try {
      // Fetch student info
      final studentResponse = await supabase
          .from('students')
          .select()
          .eq('id', studentId)
          .maybeSingle();

      if (studentResponse == null) return null;

      // Fetch results
      final resultResponse = await supabase
          .from('results')
          .select()
          .eq('student_id', studentId)
          .order('semester', ascending: true)
          .order('subject', ascending: true);

      return {
        'student': studentResponse,
        'results': List<Map<String, dynamic>>.from(resultResponse),
      };
    } catch (e) {
      log("❌ Error fetching student results: $e");
      return null;
    }
  }

}
