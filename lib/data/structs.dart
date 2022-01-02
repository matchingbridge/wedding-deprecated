import 'dart:math' as math;

import 'package:flutter/material.dart';
// import 'package:wedding/data/enums.dart';

class Range<T extends num> {
  final T A;
  final T B;
  Range({required this.A, required this.B});
  T get min => math.min(A, B);
  T get max => math.max(A, B);
  RangeValues get values => RangeValues(min.toDouble(), max.toDouble());
}

// class Sibling {
//   // Gender gender;
//   String job;
//   bool married;
//   String address;
//   Sibling({required this.job, required this.married, required this.address});
// }