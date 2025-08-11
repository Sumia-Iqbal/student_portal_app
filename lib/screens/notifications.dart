import 'package:al_ummah_institute/controllers/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/colors.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotificationsController notificationsController = Get.put(NotificationsController());

    double screenWidth = MediaQuery.of(context).size.width;
    double baseFontSize = screenWidth * 0.042;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          backgroundColor: drawerContainer,
          elevation:0,
          title: Text(
            "Notifications",
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: baseFontSize + 2,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Obx(() {
          if (notificationsController.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    "No notifications yet.",
                    style: GoogleFonts.lato(fontSize: baseFontSize, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: notificationsController.notifications.length,
            itemBuilder: (context, index) {
              final notification = notificationsController.notifications[index];

              return GestureDetector(
                onTap: () {
                  Get.snackbar(
                    "Notification",
                    notification['title'] ?? '',
                    backgroundColor: drawerContainer,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 2),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(2, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🖼️ Image
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Image.network(
                          notification['picture_url'].toString().trim(),
                          height: screenWidth * 0.5,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: screenWidth * 0.5,
                              color: Colors.grey.shade100,
                              child: const Center(
                                child: Icon(Icons.image_not_supported_outlined, size: 50, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// 🧾 Title + Date
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    notification['title'] ?? '',
                                    style: GoogleFonts.roboto(
                                      fontSize: baseFontSize + 2,
                                      fontWeight: FontWeight.w600,
                                      color: drawerContainer,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 15, color: myGreyColor),
                                    const SizedBox(width: 5),
                                    Text(
                                      formatDate(notification['date']),
                                      style: GoogleFonts.lato(
                                        fontSize: baseFontSize - 2,
                                        color: myGreyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// 📃 Description
                            Text(
                              notification['about'] ?? '',
                              style: GoogleFonts.lato(
                                fontSize: baseFontSize,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  String formatDate(dynamic dateStr) {
    if (dateStr == null || dateStr.toString().isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr.toString());
      return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
    } catch (e) {
      return '';
    }
  }
}
