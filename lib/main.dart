import 'package:al_ummah_institute/screens/dash_board_screen.dart';
import 'package:al_ummah_institute/screens/login_screen.dart';
import 'package:al_ummah_institute/screens/main_screen_one.dart';
import 'package:al_ummah_institute/screens/teacher_dash_board.dart';
import 'package:al_ummah_institute/sign_up_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'controllers/fee_controller.dart';
import 'helpers/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this line

  await Supabase.initialize(
    url: 'https://xnrvkcfynpnbqrmsxtxy.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhucnZrY2Z5bnBuYnFybXN4dHh5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwNTAyMzIsImV4cCI6MjA2NDYyNjIzMn0.DvkYxFuSF1gp_hpaa1xJGqz4TLSpb2-HIHP-Z0oDaaI',
  );
  Get.put(FeeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Al Ummah Institute',
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        scaffoldBackgroundColor: scaffoldColor,
        appBarTheme: AppBarTheme(
          backgroundColor: drawerContainer,
          foregroundColor: Colors.white
        )

      ),
      home:LoginScreen()
      //   home:MainScreenOne()



    );
  }
}