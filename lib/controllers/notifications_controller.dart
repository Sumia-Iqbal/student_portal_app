import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../helpers/constants.dart';

class NotificationsController extends GetxController {
  RxList<Map<String, dynamic>> notifications = RxList([]);
  Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    selectedImage.value = null;
    fetchNotifications();
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      log("✅ Image selected: ${selectedImage.value!.path}");
    } else {
      log("❌ No image selected");
    }
  }

  Future<String?> uploadImageToSupabase(String title) async {
    if (selectedImage.value == null) {
      log("⚠️ No image to upload.");
      return null;
    }

    try {
      final file = selectedImage.value!;
      final fileExt = file.path.split('.').last;
      final filePath = 'notifications/${DateTime.now().millisecondsSinceEpoch}_$title.$fileExt';
      final fileBytes = await file.readAsBytes();

      final storageRef = supabase.storage.from('notifications-picture');
      await storageRef.uploadBinary(filePath, fileBytes);

      final imageUrl = storageRef.getPublicUrl(filePath);
      log("✅ Public Image URL: $imageUrl");
      return imageUrl;
    } catch (e) {
      log("❌ uploadImageToSupabase Error: $e");
      return null;
    }
  }

  Future<void> addNotification(String title, String about) async {
    try {
      String? imageUrl;

      if (selectedImage.value != null) {
        log("📷 Image selected. Uploading...");
        imageUrl = await uploadImageToSupabase(title);
        log("📷 Uploaded Image URL received: $imageUrl");
      } else {
        log("⚠️ No image selected. Skipping image upload.");
      }

      final notificationData = {
        'title': title,
        'about': about,
        'picture_url': imageUrl,
        'date': DateTime.now().toIso8601String(), // 👈 Date inserted here
      };

      log("📝 Inserting notification data into Supabase: $notificationData");

      final response = await supabase.from('notifications').insert(notificationData).select().single();

      log("✅ Notification added successfully: $response");
    } catch (e) {
      log("❌ addNotification Error: $e");
    }
  }

  Future<void> fetchNotifications() async {
    try {
      final response = await supabase.from('notifications').select();
      if (response != null) {
        notifications.value = List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      log('error fetching notifications:$e');
    }
  }
}
