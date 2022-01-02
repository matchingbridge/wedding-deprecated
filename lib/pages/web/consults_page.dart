import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wedding/components/popup.dart';
import 'package:wedding/data/models.dart';
import 'package:wedding/data/strings.dart';
import 'package:wedding/services/web/admin_service.dart';

class ConsultsController extends GetxController {
  var chats = <Chat>[].obs;
  @override
  void onInit() {
    super.onInit();
    getChats();
  }

  Future<void> getChats() async {
    try {
      chats.value = await AdminService.getChats();
    } catch (error) {
      buildPopup(failedToGetChatPopup, '$error');
    }
  }
}

class ConsultsPage extends StatelessWidget {
  final controller = Get.put(ConsultsController());

  Widget buildLabel() => Row(
    children: [
      Text('ID'),
      Text('메시지'),
      Text('시간')
    ],
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
  );

  Widget buildChat(Chat chat) => Row(
    children: [
      Text(chat.userID),
      Text(chat.message),
      Text(DateFormat('yy년 MM월 dd일 HH:mm a').format(chat.chattedAt))
    ],
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
  );

  @override
  Widget build(BuildContext context) => Obx(() => controller.chats.isEmpty ? Center(child: Text('no chats')) : ListView.separated(
    itemBuilder: (context, index) => index == 0 ? buildLabel() : buildChat(controller.chats[index - 1]), 
    separatorBuilder: (context, index) => Divider(height: 16), 
    itemCount: controller.chats.length + 1,
    padding: EdgeInsets.all(20)
  ));
}