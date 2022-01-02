import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wedding/data/colors.dart';

Future<T?> buildPopup<T>(String title, String content) async => await Get.defaultDialog<T>(
  radius: 8,
  title: title, titleStyle: TextStyle(color: mainColor, fontSize: 20, fontWeight: FontWeight.bold), titlePadding: EdgeInsets.fromLTRB(0, 16, 0, 8),
  content: Text(content),
);

Future<T?> buildButtonPopup<T>(String title, Widget content, String label, void Function() onConfirm) async => await Get.dialog(
  AlertDialog(
    title: Text(title, textAlign: TextAlign.center, style: TextStyle(color: mainColor, fontSize: 20, fontWeight: FontWeight.bold)), titlePadding: EdgeInsets.fromLTRB(0, 16, 0, 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
    content: Column(
      children: [
        Padding(child: content, padding: EdgeInsets.all(16)),
        Container(
          child: TextButton(onPressed: onConfirm, child: Text(label, style: TextStyle(color: Colors.white))),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(31), offset: Offset(0, 3), blurRadius: 3)],
            color: mainColor, 
          ),
          margin: EdgeInsets.zero,
        )
      ],
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
    ),
    contentPadding: EdgeInsets.zero,
  )
);

Future<T?> buildButtonsPopup<T>(String title, Widget content, String confirmText, String cancelText, void Function() onConfirm, void Function() onCancel) async => await Get.dialog(
  AlertDialog(
    title: Text(title, textAlign: TextAlign.center, style: TextStyle(color: mainColor, fontSize: 20, fontWeight: FontWeight.bold)), titlePadding: EdgeInsets.fromLTRB(0, 16, 0, 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
    content: Column(
      children: [
        Padding(child: content, padding: EdgeInsets.all(16)),
        Row(
          children: [
            Expanded(child: Container(
              child: TextButton(onPressed: onCancel, child: Text(cancelText, style: TextStyle(color: Colors.white))),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(31), offset: Offset(0, 3), blurRadius: 3)],
                color: warningColor, 
              ),
              margin: EdgeInsets.zero,
            )),
            Expanded(child: Container(
              child: TextButton(onPressed: onConfirm, child: Text(confirmText, style: TextStyle(color: Colors.white))),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(8)),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(31), offset: Offset(0, 3), blurRadius: 3)],
                color: mainColor, 
              ),
              margin: EdgeInsets.zero,
            ))
          ],
        )
      ],
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
    ),
    contentPadding: EdgeInsets.zero,
  )
);