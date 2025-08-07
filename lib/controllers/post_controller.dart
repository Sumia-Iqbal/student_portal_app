import 'dart:developer';

import 'package:al_ummah_institute/helpers/constants.dart';
import 'package:get/get.dart';

class PostController extends GetxController{
  var posts  = [];
  void addPost(image,description){
    try{
      final response = supabase.from('posts').insert({
        'picture-url': image,
        'body':description

      });
    }catch(e){}
  }
Future<void> getPost()async{
    try{
      final response = supabase.from('posts').select();
      posts = response as List;
    }catch( e){

      log(e.toString());
    }
}
}