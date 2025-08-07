// time_table_controller.dart
import 'dart:developer';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../helpers/constants.dart';

class TimeTableController extends GetxController {
  RxList<Map<String, dynamic>> classTimeTable = <Map<String, dynamic>>[].obs;

  Future<void> fetchTimeTableForClass(String className) async {
    try {
      final response = await supabase
          .from('timetables')
          .select()
          .eq('class_name', className)
          .order('period_number', ascending: true);

      classTimeTable.assignAll(List<Map<String, dynamic>>.from(response));
      log("Fetched \${classTimeTable.length} periods for class \$className");
    } catch (e) {
      log("Fetch Error: \$e");
      classTimeTable.clear();
    }
  }

  Future<void> addTimeTable({
    required String className,
    required int periodNumber,
    required String teacherName,
    required String subjectName,
    required String startTime,
    required String endTime,
  }) async {
    try {
      await supabase.from('timetables').insert({
        'start_time': startTime,
        'class_name': className,
        'period_number': periodNumber,
        'end_time': endTime,
        'teacher_name': teacherName,
        'subject_name': subjectName,
      });
      log('Time table inserted for \$className Period \$periodNumber');
    } catch (e) {
      log("Insert Error: \$e");
    }
  }

  Future<List<String>> fetchUniqueClassNames() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.from('students').select('class');

      // Convert and normalize all class names
      final Set<String> cleanedClasses = response
          .map<String>((row) {
        final raw = (row['class'] ?? '').toString().trim().toLowerCase();

        // Handle cases like '4' -> '4th', '1' -> '1st'
        final normalized = switch (raw) {
          '1' => '1st',
          '2' => '2nd',
          '3' => '3rd',
          '4' => '4th',
          '5' => '5th',
          '6' => '6th',
          '7' => '7th',
          '8' => '8th',
          '9' => '9th',
          '10' => '10th',
          _ => raw,
        };

        return normalized;
      })
          .where((c) => c.isNotEmpty)
          .toSet();

      // Custom sort: 1st, 2nd, 3rd, ..., 10th, then anything else alphabetically
      final sorted = cleanedClasses.toList()
        ..sort((a, b) {
          final numberA = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), '')) ?? 999;
          final numberB = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), '')) ?? 999;
          return numberA.compareTo(numberB);
        });

      return sorted;
    } catch (e) {
      log("Class Fetch Error: $e");
      return [];
    }
  }
}
