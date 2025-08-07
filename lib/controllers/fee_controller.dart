import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeeController extends GetxController {
  final supabase = Supabase.instance.client;

  RxList<Map<String, dynamic>> classes = RxList([]);
  RxList<Map<String, dynamic>> students = RxList([]);
  RxList<Map<String, dynamic>> fees = RxList([]);
  RxBool isLoading = false.obs;

  String selectedClass = '';
  Map<String, dynamic>? selectedStudent;

  @override
  void onInit() {
    super.onInit();
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    final res = await supabase.from('students').select('class');
    final allClasses = res.map((row) => (row['class'] ?? '').toString().trim()).toSet().toList();
    classes.value = allClasses.map((c) => {'class': c}).toList();
  }

  Future<void> fetchStudentsByClass(String className) async {
    isLoading.value = true;
    final res = await supabase.from('students').select().eq('class', className);
    students.value = List<Map<String, dynamic>>.from(res);
    isLoading.value = false;
  }

  Future<void> fetchFees() async {
    if (selectedStudent == null) return;
    isLoading.value = true;
    final res = await supabase
        .from('fees')
        .select()
        .eq('student_id', selectedStudent!['id'])
        .order('year', ascending: false)
        .order('month', ascending: false);
    fees.value = List<Map<String, dynamic>>.from(res);
    isLoading.value = false;
  }

  Future<void> addFee(Map<String, dynamic> newFee) async {
    await supabase.from('fees').insert(newFee);
    await fetchFees();
  }

  Future<void> markPaid(String feeId) async {
    await supabase
        .from('fees')
        .update({
      'paid_date': DateTime.now().toIso8601String(),
      'status': 'paid',
      'fine': 0,
    })
        .eq('id', feeId);
    await fetchFees();
  }

  double calcFine(Map<String, dynamic> fee) {
    if ((fee['status'] ?? '') == 'paid') return 0;
    final dueDate = DateTime.tryParse(fee['due_date'] ?? '');
    if (dueDate == null) return 0;
    if (DateTime.now().isAfter(dueDate)) {
      return (DateTime.now().difference(dueDate).inDays * 20).toDouble();
    }
    return (fee['fine'] ?? 0).toDouble();
  }
}
