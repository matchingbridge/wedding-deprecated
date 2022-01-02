import 'package:flutter/material.dart';
import 'package:wedding/components/button.dart';
import 'package:wedding/components/dropdown.dart';
import 'package:wedding/components/textfield.dart';
import 'package:wedding/data/colors.dart';

Widget buildLabelStringList(String label, String hint, List<String> list, int max, Function(String) onAddItem, Function(int) onRemoveAt) {
  final controller = TextEditingController();
  return Row(
    children: [
      Flexible(child: Text(label, style: TextStyle(color: greyColor, fontSize: 14)), flex: 1,),
      Flexible(child: Column(
        children: [
          if (list.length < max)
            Row(
              children: [
                Flexible(child: buildTextField(controller: controller, hint: hint, radius: 8),),
                buildButton(child: Text('추가', style: TextStyle(color: Colors.white),), color: mainColor, margin: EdgeInsets.only(left: 16), onPressed: () {
                  if (list.contains(controller.text) || controller.text.isEmpty)
                    return;
                  onAddItem(controller.text);
                })
              ],
            )
        ]..addAll(list.map<Widget>((e) => Row(children: [
          Text(e),
          IconButton(onPressed: () => onRemoveAt(list.indexOf(e)), icon: Icon(Icons.cancel), color: Colors.red,)
        ], mainAxisAlignment: MainAxisAlignment.end,)).toList())
      ), flex: 3,)
    ],
    // crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
  );
}

Widget buildEnumList<T>(String hint, List<T> items, List<T> all, T initial, int max, String Function(T) literal, Function(T) onAddItem, Function(int) onRemoveAt) {
  T value = initial;
  return Column(
    children: [
      if (items.length < max)
        buildDropdown(DropdownButton<T>(
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down_rounded, size: 48, color: hintColor),
          items: all.map((e) => DropdownMenuItem(child: Text(literal(e), style: TextStyle(color: greyColor, fontSize: 12)), value: e,)).toList(),
          onChanged: (changed) {
            if (changed != null) onAddItem(changed);
          },
          value: value,
        ))
    ]..addAll(items.map<Widget>((e) => Row(children: [
        Text(literal(e)),
        IconButton(onPressed: () => onRemoveAt(items.indexOf(e)), icon: Icon(Icons.cancel), color: Colors.red,)
      ], mainAxisAlignment: MainAxisAlignment.end,)).toList()),
  );
}

Widget buildLabelEnumList<T>(String label, String hint, List<T> items, List<T> all, T initial, int max, String Function(T) literal, Function(T) onAddItem, Function(int) onRemoveAt) => Row(
  children: [
    Flexible(child: Text(label, style: TextStyle(color: greyColor, fontSize: 14)), flex: 1,),
    Flexible(child: buildEnumList(hint, items, all, initial, max, literal, onAddItem, onRemoveAt), flex: 3,)
  ],
  // crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
);

Widget buildLabelStructList<T>(String label, Widget Function(T) itemBuilder, Widget createBuilder, List<T> items, Function(T) onAddItem) {
  return Row(
    children: [
      Flexible(child: Text(label, style: TextStyle(color: greyColor, fontSize: 14)), flex: 1,),
      Flexible(child: Column(
        children: [createBuilder]..addAll(items.map<Widget>((e) => itemBuilder(e)).toList()),
      ), flex: 3)
    ]
  );
}