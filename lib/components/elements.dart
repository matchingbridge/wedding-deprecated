import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wedding/data/colors.dart';

class PersonAction {
  Color color;
  String label;
  Color labelColor;
  void Function() onPressed;
  PersonAction({required this.color, required this.label, this.labelColor=Colors.white, required this.onPressed});
}

Widget buildEmptyThumbnail({double? width, double? height}) => Container(
  constraints: BoxConstraints.expand(width: width, height: height),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    color: hintColor
  ),
  width: width, height: height
);

Widget _buildAdd({double? width, double? height}) => Container(
  child: Icon(Icons.add_circle, color: Colors.white),
  constraints: BoxConstraints.expand(width: width, height: height),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    color: hintColor
  ),
  width: width, height: height
);

Widget buildPerson({String? thumbnail, PersonAction? action, bool shadow=false, double? width, double? height, EdgeInsets? margin}) => Container(
  child: Stack(
    children: [
      if (thumbnail != null)
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(thumbnail, errorBuilder: (context, error, stack) => buildEmptyThumbnail(width: width, height: height), fit: BoxFit.cover, height: height, width: width),
        )
      else
        buildEmptyThumbnail(width: width, height: height),
      if (action != null)
        Positioned(
          child: GestureDetector(
            child: Container(
              child: Text(
                action.label, 
                textAlign: TextAlign.center, 
                style: TextStyle(color: action.labelColor, fontSize: 12, fontWeight: FontWeight.bold)
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                color: action.color,
              ),
              padding: EdgeInsets.symmetric(vertical: 4),
            ),
            onTap: action.onPressed,
          ),
          left: 0, bottom: 0, right: 0,
        ),
      if (shadow)
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black.withAlpha(127),
          ),
        )
    ],
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    boxShadow: [BoxShadow(color: Colors.black.withAlpha(31), offset: Offset(0, 3), blurRadius: 3)],
  ),
  margin: margin
);

Widget buildProfile(String label, {String? path, double? width, double? height}) => Column(
  children: [
    if (path != null) 
      ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: label == 'video' ? 
          SizedBox(width: width, height: height, child: VideoPlayer(VideoPlayerController.file(File(path))..initialize())) : 
          Image.file(File(path), errorBuilder: (context, error, stack) => _buildAdd(width: width, height: height), fit: BoxFit.cover, height: height, width: width),
      )
    else
      _buildAdd(width: width, height: height),
    Divider(color: Colors.transparent, height: 8),
    Text(label),
  ],
);