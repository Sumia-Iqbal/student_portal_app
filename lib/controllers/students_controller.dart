import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../helpers/constants.dart';

class StudentsController extends GetxController {
  RxList<Map<String, dynamic>> students = RxList([]);
  RxList<Map<String, dynamic>> allStudents = RxList([]); // 🆕 for search
  RxList<Map<String, dynamic>> studentData = RxList([]);
  Rx<Map<String, dynamic>?> loggedInStudent = Rx<Map<String, dynamic>?>(null);

  String currentCnic = '';
  String currentPassword = '';

  Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchAllStudents();
  }

  // 🖼 Pick Image
  Future<void> pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      log("✅ Image selected: ${selectedImage.value!.path}");
    } else {
      log("❌ No image selected");
    }
  }

  // ☁️ Upload Image to Supabase
  Future<String?> uploadImageToSupabase(String studentName) async {
    if (selectedImage.value == null) return null;

    try {
      final fileExt = selectedImage.value!.path.split('.').last;
      final filePath = 'students/${DateTime.now().millisecondsSinceEpoch}_$studentName.$fileExt';
      final fileBytes = await selectedImage.value!.readAsBytes();

      await supabase.storage.from('students-pictures').uploadBinary(filePath, fileBytes);
      final imageUrl = supabase.storage.from('students-pictures').getPublicUrl(filePath);

      return imageUrl;
    } catch (e) {
      log("❌ uploadImageToSupabase Error: $e");
      return null;
    }
  }

  // ➕ Add Student
  Future<Map<String, dynamic>?> addStudents(
      String name,
      String regNumber,
      String cnicNumber,
      String password,
      String address,
      String studentNumber,
      String parentsNumber,
      String nationality,
      String status,
      String grade,
      String percentage,
      String joinDate,
      String campus,
      ) async {
    try {
      String? imageUrl = await uploadImageToSupabase(name);

      final response = await supabase.from('students').insert({
        'name': name,
        'cnic_number': cnicNumber,
        'password': password,
        'reg_no': regNumber,
        'address': address,
        'student_number': studentNumber,
        'parents_number': parentsNumber,
        'nationality': nationality,
        'status': status,
        'class': grade,
        'percentage': percentage,
        'join_date': joinDate,
        'campus': campus,
        'picture_url': imageUrl,
      }).select().single();

      return response;
    } catch (e) {
      log("❌ addStudents Error: $e");
      return null;
    }
  }

  // 🔄 Fetch all students
  Future<void> fetchAllStudents() async {
    try {
      final response = await supabase.from("students").select();
      if (response != null) {
        final data = List<Map<String, dynamic>>.from(response);
        students.value = data;
        allStudents.value = data; // keep original for search
      }
    } catch (e) {
      log("❌ error fetching students: $e");
    }
  }

  // 🔍 Local search from allStudents
  Future<void> searchStudents(String query) async {
    final results = allStudents
        .where((student) => student['name']
        .toString()
        .toLowerCase()
        .contains(query.toLowerCase()))
        .toList();

    students.value = results;
  }

  // 🔐 Login

  Future<String> loginUser(String cnicNumber, String password) async {
    try {
      final response = await supabase
          .from('students')
          .select()
          .eq('cnic_number', cnicNumber)
          .eq('password', password)
          .maybeSingle();

      if (response != null) {
        loggedInStudent.value = response; // ✅ Save the student
        currentCnic = cnicNumber;
        currentPassword = password;
        return "success";
      } else {
        return "Invalid CNIC or password";
      }
    } catch (e) {
      return e.toString();
    }
  }

  // 🧍‍♂️ Fetch Single Student
  Future<Map<String, dynamic>?> fetchStudentData(String cnic, String password) async {
    try {
      final response = await supabase
          .from('students')
          .select()
          .eq('cnic_number', cnic)
          .eq('password', password)
          .maybeSingle();

      if (response != null) {
        studentData.value = [response];
        return response;
      } else {
        return null;
      }
    } catch (e) {
      log("❌ fetchStudentData Error: $e");
      return null;
    }
  }

}
