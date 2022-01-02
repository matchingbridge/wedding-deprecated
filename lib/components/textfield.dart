import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedding/data/colors.dart';

Widget buildLabelTextField(
  String label, {
  TextEditingController? controller, 
  String? hint, 
  TextInputType? keyboardType, 
  bool obscure=false, 
  double radius=4,
  FocusNode? focus,
  int? maxLines=1
}) => Row(
  children: [
    Flexible(child: Text(label, style: TextStyle(color: greyColor, fontSize: 14)), flex: 1,),
    Flexible(child: buildTextField(
      controller: controller, hint: hint, keyboardType: keyboardType, 
      obscure: obscure, radius: radius, focus: focus, maxLines: maxLines
    ), flex: 3)
  ],
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
);

Widget buildTextField({
  TextEditingController? controller, 
  String? hint, 
  TextInputType? keyboardType,
  bool obscure=false, 
  double radius=4, 
  FocusNode? focus,
  int? maxLines=1,
  int? length
  }) => Container(
  child: TextField(
    controller: controller,
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide.none),
      contentPadding: EdgeInsets.all(16),
      fillColor: Colors.white.withAlpha(63),
      filled: true, 
      hintStyle: TextStyle(color: hintColor),
      hintText: hint,
      counterText: ''
    ),
    focusNode: focus,
    keyboardType: keyboardType,
    obscureText: obscure,
    maxLines: maxLines,
    maxLength: length,
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [BoxShadow(color: Colors.black.withAlpha(31), offset: Offset(0, 3), blurRadius: 3)],
    color: Colors.white
  ),
);