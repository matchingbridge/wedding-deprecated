import 'package:flutter/material.dart';
import 'package:wedding/data/colors.dart';
import 'package:wedding/data/structs.dart';

Widget buildLabelRangeSlider(String label, Range<int> value, Range<int> limit, void Function(Range<int>) onChanged) => Row(
  children: [
    Flexible(child: Text(label, style: TextStyle(color: greyColor, fontSize: 14)), flex: 1,),
    Flexible(child: RangeSlider(
      values: value.values, onChanged: (value) => onChanged(Range<int>(A: value.start.toInt(), B: value.end.toInt())), min: limit.min.toDouble(), max: limit.max.toDouble(), divisions: limit.max - limit.min, 
      labels: RangeLabels('${value.min}', '${value.max}'), 
      activeColor: mainColor, inactiveColor: hintColor,
    ), flex: 3)
  ],
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
);

Widget buildLabelSlider(String label, int value, Range<int> limit, void Function(int) onChanged) => Row(
  children: [
    Flexible(child: Text(label, style: TextStyle(color: greyColor, fontSize: 14)), flex: 1,),
    Flexible(child: Slider(
      value: value.toDouble(), onChanged: (value) => onChanged(value.toInt()), min: limit.min.toDouble(), max: limit.max.toDouble(), divisions: limit.max - limit.min,
      label: value.toString(),
      activeColor: mainColor, inactiveColor: hintColor,
    ), flex: 3)
  ],
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
);