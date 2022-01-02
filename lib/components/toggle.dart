import 'package:flutter/material.dart';
import 'package:wedding/data/colors.dart';

Widget buildLabelToggle(String label, {required bool value, required void Function(bool) onToggle}) => Row(
  children: [
    Flexible(child: Text(label, style: TextStyle(color: greyColor, fontSize: 14)), flex: 1,),
    Flexible(child: buildToggle(value: value, onToggle: onToggle), flex: 3,)
  ],
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
);

Widget buildToggle({required bool value, required void Function(bool) onToggle}) => Stack(
  children: [
    Container(
      decoration: BoxDecoration(
        color: toggleColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(31), offset: Offset(0, 3), blurRadius: 3, spreadRadius: -3)],
      ),
      height: 32, width: 54,
    ),
    Positioned(
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: value ? mainColor : hintColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(31), offset: Offset(0, 3), blurRadius: 3)],
          ),
          width: 24, height: 24,
        ),
        onTap: () => onToggle(!value)
      ),
      top: value ? 4 : null, left: value ? 4 : null, right: value ? null : 4, bottom: value ? null : 4
    )
  ],
);