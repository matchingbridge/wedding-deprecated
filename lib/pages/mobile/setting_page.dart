import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding/components/toggle.dart';
import 'package:wedding/data/colors.dart';
import 'package:wedding/pages/mobile/auth_page.dart';

class SettingController extends GetxController {
  var messageNoti = true.obs;
  var appNoti = true.obs;

  Future<void> signOut() async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Get.off(() => AuthPage());
  }
}

class SettingPage extends StatelessWidget {
  final controller = Get.put(SettingController());
  
  Widget buildButtonMenu({required IconData icon, required String label, required void Function() onPressed}) => Row(
    children: [
      Row(
        children: [
          Padding(child: Icon(icon, size: 32), padding: EdgeInsets.all(8),), 
          Text(label, style: TextStyle(color: greyColor, fontSize: 14))
        ]
      ), 
      IconButton(onPressed: onPressed, icon: Icon(Icons.arrow_forward_ios, color: hintColor), iconSize: 16)
    ],
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
  );

  Widget buildToggleMenu({required IconData icon, required String label, required bool value, required void Function(bool) onToggle}) => Row(
    children: [
      Row(
        children: [
          Padding(child: Icon(icon, size: 32), padding: EdgeInsets.all(8),), 
          Text(label, style: TextStyle(color: greyColor, fontSize: 14))
        ]
      ), 
      buildToggle(value: value, onToggle: onToggle)
    ],
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
  );

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      Text('내 정보 수정', style: TextStyle(color: hintColor, fontSize: 14, fontWeight: FontWeight.bold)),
      buildButtonMenu(icon: Icons.person, label: '프로필 수정', onPressed: () {}),
      buildButtonMenu(icon: Icons.details, label: '상세 정보 수정', onPressed: () {}),
      Divider(color: Colors.transparent, height: 16),
      Text('기타', style: TextStyle(color: hintColor, fontSize: 14, fontWeight: FontWeight.bold)),
      buildButtonMenu(icon: Icons.notifications, label: '공지사항', onPressed: () {}),
      buildButtonMenu(icon: Icons.event, label: '이벤트', onPressed: () {}),
      buildButtonMenu(icon: Icons.warning, label: '지인피하기', onPressed: () {}),
      Divider(color: Colors.transparent, height: 16),
      Text('고객 센터', style: TextStyle(color: hintColor, fontSize: 14, fontWeight: FontWeight.bold)),
      buildButtonMenu(icon: Icons.mood_bad, label: '불량 회원 신고', onPressed: () {}),
      buildButtonMenu(icon: Icons.question_answer, label: '자주 묻는 질문', onPressed: () {}),
      buildButtonMenu(icon: Icons.headphones, label: '1:1 문의하기', onPressed: () {}),
      Divider(color: Colors.transparent, height: 16),
      Text('설정', style: TextStyle(color: hintColor, fontSize: 14, fontWeight: FontWeight.bold)),
      Obx(() => buildToggleMenu(icon: Icons.alarm, label: '메시지 알림', value: controller.messageNoti.value, onToggle: (value) => controller.messageNoti.value = value)),
      Obx(() => buildToggleMenu(icon: Icons.alarm, label: '앱 알림', value: controller.appNoti.value, onToggle: (value) => controller.appNoti.value = value)),
      buildButtonMenu(icon: Icons.pause, label: '휴면 신청하기', onPressed: () {}),
      buildButtonMenu(icon: Icons.logout, label: '로그아웃', onPressed: controller.signOut),
      buildButtonMenu(icon: Icons.close, label: '탈퇴하기', onPressed: () {}),
    ],
    padding: EdgeInsets.all(20),
    shrinkWrap: true,
  );
}