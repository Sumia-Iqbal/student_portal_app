import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension Extensions on BuildContext{
  void openScreen(Widget screen){
    Navigator.push(this, MaterialPageRoute(builder:(context)=>screen));
  }
  void showSnackBar(String message){
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
  void pop(){
    Navigator.pop(this);
  }
}