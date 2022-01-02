import 'package:flutter/material.dart';
import 'package:wedding/data/colors.dart';

Widget buildDropdown(DropdownButton button) => Container(
  child: DropdownButtonHideUnderline(child: button),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    boxShadow: [BoxShadow(color: Colors.black.withAlpha(31), offset: Offset(0, 3), blurRadius: 3)],
    color: Colors.white,
  ),
  margin: EdgeInsets.only(left: 16),
  padding: EdgeInsets.only(left: 20),
);

Widget buildLabelDropdown<T>(String label, void Function(T?) onChanged, T? value, List<DropdownMenuItem<T>> items) => Row(
  children: [
    Flexible(child: Text(label, style: TextStyle(color: greyColor, fontSize: 14)), flex: 2,),
    Flexible(
      child: buildDropdown(DropdownButton<T>(
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down_rounded, size: 48, color: hintColor),
        items: items,
        onChanged: onChanged,
        value: value,
      )),
      flex: 7,
    ),
  ],
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
);

// Widget buildLabelDropdowns<T>(String label, void Function(int, T?) onChanged, List<T?> values, List<DropdownMenuItem<T>> items, int count) => Row(
//   children: [
//     Flexible(child: Text(label, style: TextStyle(color: greyColor, fontSize: 14)), flex: count,),
//     for (var i = 0; i < count; i++)
//       Flexible(
//         child: buildDropdown(DropdownButton<T>(
//           isExpanded: true,
//           icon: Icon(Icons.arrow_drop_down_rounded, size: 48, color: hintColor),
//           items: items,
//           onChanged: (changed) => onChanged(i, changed),
//           value: values[i],
//         )),
//         flex: 3,
//       ),
//   ],
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// );