import 'package:flutter/material.dart';

Widget buildButton({
  void Function()? onPressed, 
  required Widget child, 
  required Color color, 
  double radius=40, 
  EdgeInsets padding=EdgeInsets.zero,
  EdgeInsets margin=EdgeInsets.zero,
}) => Container(
  child: TextButton(onPressed: onPressed, child: child,),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [BoxShadow(color: Colors.black.withAlpha(31), offset: Offset(0, 3), blurRadius: 3)],
    color: color, 
  ),
  padding: padding,
  margin: margin,
);