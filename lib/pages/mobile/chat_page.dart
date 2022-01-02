import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wedding/components/elements.dart';
import 'package:wedding/components/popup.dart';
import 'package:wedding/data/colors.dart';
import 'package:wedding/data/models.dart';
import 'package:wedding/data/strings.dart';
import 'package:wedding/pages/mobile/matching_page.dart';
import 'package:wedding/services/mobile/base_service.dart';
import 'package:wedding/services/mobile/chat_service.dart';

class ChatController extends GetxController {
  var chats = List<Chat>.empty().obs;
  var controller = TextEditingController();
  void back() => Get.back();

  @override
  void onInit() {
    super.onInit();
    getChats();
  }

  Future<void> getChats() async {
    try {
      chats.value = await ChatService.getChats();
    } catch (e) {
      await buildPopup(failedToGetChatPopup, '$e');
    }
  }

  Future<void> makeChat() async {
    try {
      var chat = await ChatService.makeChat(controller.text);
      chat.chattedAt = DateTime.now();
      chats.add(chat);
      controller.text = "";
    } catch (e) {
      await buildPopup(failedToGetChatPopup, '$e');
    }
  } 

  void showMatching(String partnerID) => Get.to(() => MatchingPage(), arguments: {'partnerID': partnerID});
}

class ChatPage extends StatelessWidget {
  final controller = Get.put(ChatController());
  
  Widget buildChat(Chat chat) => Row(
    children: [
      if (chat.isTalking)
        Text(DateFormat('HH:mm a').format(chat.chattedAt), style: TextStyle(color: greyColor, fontSize: 10)),
      Container(
        child: Text(chat.message, style: TextStyle(color: chat.isTalking ? Colors.white : greyColor, fontSize: 12)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8), 
            bottomRight: Radius.circular(chat.isTalking ? 0 : 8), 
            bottomLeft: Radius.circular(chat.isTalking? 8 : 0)
          ),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(31), offset: Offset(0, 0), blurRadius: 3)],
          color: chat.isTalking ? mainColor: Colors.white,
        ),
        margin: EdgeInsets.only(left: chat.isTalking ? 4 : 0, right: chat.isTalking ? 0 : 4),
        padding: EdgeInsets.all(8),
      ),
      if (!chat.isTalking)
        Text(DateFormat('HH:mm a').format(chat.chattedAt), style: TextStyle(color: greyColor, fontSize: 10)),
    ],
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: chat.isTalking ? MainAxisAlignment.end : MainAxisAlignment.start,
  );

  Widget buildItem(int index) {
    if (controller.chats[index].message.startsWith('{') && controller.chats[index].message.endsWith('}')) {
      var message = controller.chats[index].message;
      var partnerID = message.substring(1, message.length-1);
      return Row(
        children: [
          buildPerson(
            action: PersonAction(color: pinkColor, label: '프로필 보기', onPressed: () => controller.showMatching(partnerID), labelColor: greyColor),
            thumbnail: '${BaseService.endpoint}/user/media/face1/$partnerID',
            width: 100, height: 100
          )
        ],
      );
    }
    else
      return buildChat(controller.chats[index]);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white, 
      centerTitle: true,
      elevation: 0,
      leading: IconButton(color: mainColor, icon: Icon(Icons.arrow_back_ios), onPressed: controller.back),
      title: Text('주선자', style: TextStyle(color: mainColor, fontSize: 20, fontWeight: FontWeight.bold))
    ),
    backgroundColor: Colors.white,
    body: Column(
      children: [
        Expanded(child: Obx(() => ListView.separated(
          itemBuilder: (context, index) => buildItem(index),
          itemCount: controller.chats.length,
          separatorBuilder: (context, index) => Divider(color: Colors.transparent, height: 16,),
          shrinkWrap: true,
          padding: EdgeInsets.all(20),
        ))),
        Container(
          child: Container(
            child: Row(
              children: [
                Flexible(child: TextField(
                  controller: controller.controller,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.all(16),
                    fillColor: Colors.white.withAlpha(63),
                    filled: true, 
                    hintStyle: TextStyle(color: hintColor),
                    hintText: '메시지를 입력하세요',
                  ),
                  minLines: 1, maxLines: 5,
                )),
                IconButton(icon: Icon(Icons.arrow_upward), color: mainColor, onPressed: controller.makeChat,)
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.white
            ),
            margin: EdgeInsets.all(8),
          ),
          color: backgroundColor,
        )
      ],

    )
  );
}