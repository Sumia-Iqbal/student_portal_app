import 'package:al_ummah_institute/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/colors.dart';
import '../controllers/notifications_controller.dart';

class AddNotificationScreen extends StatelessWidget {
  var editText;

  @override
  Widget build(BuildContext context) {
    var loading = false.obs;
    var notificationController = Get.put(NotificationsController());
    var titleController = TextEditingController();
    var aboutController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Updates"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              width: 70,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.blue),
              child: Obx(() {
                return TextButton(
                  onPressed: loading.value
                      ? null
                      : () async {
                    var title = titleController.text;
                    var about = aboutController.text;
                    if (title.isEmpty) {
                      return;
                    }
                    await notificationController
                        .addNotification(title, about)
                        .then((_) {
                      context.pop();
                    }).catchError((e) {
                      context.showSnackBar(e.toString());
                    });
                  },
                  child: Text("Add", style: TextStyle(color: Colors.white)),
                );
              }),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () async {
                await notificationController.pickImageFromGallery();
              },
              icon: Icon(Icons.photo, color: Colors.white),
              label: Text("Upload Student Picture", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: drawerContainer),
            ),
            SizedBox(height:10),

            Obx(() {
              final pickedImage = notificationController.selectedImage.value;
              return Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: pickedImage != null
                        ? FileImage(pickedImage) as ImageProvider
                        : NetworkImage('https://archive.org/download/placeholder-image//placeholder-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),

            Container(
              height: 200,
              decoration: BoxDecoration(color: drawerContainer),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.white, fontSize: 30),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: "What's the update today",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 30),
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  maxLines: 10,
                  controller: titleController,
                ),
              ),
            ),

            Container(
              height: 200,
              decoration: BoxDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.grey, fontSize: 30),
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    hintText: "About the update",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  maxLines: 10,
                  controller: aboutController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
