import 'dart:developer';

import 'package:al_ummah_institute/helpers/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../helpers/constants.dart';

class AuthController {
  Future<String> createUser(String email,String password )async{
   try{
     final  response = await supabase.auth.signUp(password: password,email: email);
     if(response.user!=null){
       return "success";
     }else{
       return "went something wrong";
     }
   }catch(e){
     return e.toString();
   }
  }
  Future<String> loginUser(String email,String password)async{
    try{
      var response = await supabase.auth.signInWithPassword(password: password,email:email);
      if(response.user!=null){
        return "success";
      }else{
        return "Went Something wrong";
      }
    }catch(e){
     return e.toString();

    }

  }
  Future<String> sendPasswordResetEmail(String email)async{
    try{
     await supabase.auth.resetPasswordForEmail(email);
        return "Password reset email sent successfully";
    }catch(e){
      return "Failed to send reset Email :$e";
    }
  }
}