import 'package:intl/intl.dart';

List<String> get maleBodyType => [
  '곰같은', '근육질인', '평범한', '어깨가 넓은', '허벅지가 탄탄한', '엉덩이가 예쁜', '배가 나온', '근육돼지', '매끈한', '아이돌체형', '얼굴이 작은'
];

List<String> get femaleBodyType => [
  '글래머러스한', '통통한', '살집이 있는', '가슴이 큰', '엉덩이가 예쁜', '허리가 잘록한', '얼굴이 작은', '평범한', '여리여리한', '근육질인'
];

List<String> get maleCharacter => [
  '외향적인', '내성적인', '상남자같은', '차분한', '수다스러운', '과묵한', '섹시한', '유머있는', '배려심깊은', '감성적인', '이성적인', '자유로운', '계획적인', '애교있는', '귀여운', '우아한', '평범한', '못생긴', '성적성향이있는'
];

List<String> get femaleCharacter => [
  '외향적인', '내성적인', '여성스러운', '털털한', '차분한', '수다스러운', '과묵한', '섹시한', '유머있는', '배려심깊은', '감성적인', '이성적인', '자유로운', '계획적인', '애교있는', '귀여운', '수수한', '우아한', '평범한', '못생긴', '성적성향이있는'
];

extension Format on DateTime {
  String get detailLiteral => DateFormat('yy년 MM월 dd일 HH:mm a').format(this);
}