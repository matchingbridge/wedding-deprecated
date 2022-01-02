import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wedding/components/elements.dart';
import 'package:wedding/components/popup.dart';
import 'package:wedding/data/colors.dart';
import 'package:wedding/data/models.dart';
import 'package:wedding/data/strings.dart';
import 'package:wedding/pages/mobile/history_page.dart';
import 'package:wedding/pages/mobile/matching_page.dart';
import 'package:wedding/pages/mobile/matchings_page.dart';
import 'package:wedding/pages/mobile/setting_page.dart';
import 'package:wedding/services/mobile/base_service.dart';
import 'package:wedding/services/mobile/match_service.dart';
import 'package:wedding/services/mobile/user_service.dart';

class RootController extends GetxController {
  var currentIndex = 0.obs;
  var user = User.dummy().obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {
    await getUser();
    await getUnansweredMatches();
  }

  void onTapTouched(int newIndex) {
    currentIndex.value = newIndex;
    switch (currentIndex.value) {
      case 0:
      if (Get.isRegistered<MatchingsController>()) {
        var matchingsController = Get.find<MatchingsController>();
        matchingsController.getMatch();
      }
      break;
      case 1:
      if (Get.isRegistered<HistoryController>()) {
        var historyController = Get.find<HistoryController>();
        historyController.getMatches();
      }
      break;
    }
  }

  Future<void> getUser() async {
    try {
      user.value = await UserService.getUser();
    } catch (e) {
      await buildPopup(failedToGetUserPopup, '$e');
    }
  }

  Future<void> getUnansweredMatches() async {
    try {
      var unanswered = await MatchService.getUnanswered();
      for (var each in unanswered) {
        var show = await buildButtonPopup(unansweredMatchPopup, Column(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Image.network(
              '${BaseService.endpoint}/user/media/face1/${each.senderID}', 
              fit: BoxFit.none, height: 75, width: 75, 
              errorBuilder: (context, error, stack) => buildEmptyThumbnail(width: 75, height: 75)
            ),
          ),
          Divider(height: 16, color: Colors.transparent),
          Text('새로운 매칭 요청이 있습니다.'),
        ],), '프로필 보기', () => Get.back(result: true));
        if (show == null)
          continue;
        await Get.to(() => MatchingPage(), arguments: {'partner_id': each.senderID});
        if (each.matchedAt != null)
          return;
      }
    } catch (e) {
      await buildPopup(failedToGetMatchesPopup, '$e');
    }
  }
}

class RootPage extends StatelessWidget {
  final controller = Get.put(RootController());

  String get title {
    switch (controller.currentIndex.value) {
      case 0: return '오늘의 맞선';
      case 1: return '매칭 히스토리';
      case 2: return '내 프로필';
      default: return '';
    }
  }

  Widget get body {
    switch (controller.currentIndex.value) {
      case 0: return MatchingsPage();
      case 1: return HistoryPage();
      case 2: return SettingPage();
      default: return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, 
        centerTitle: true,
        elevation: 0,
        title: Obx(() => Text(title, style: TextStyle(color: mainColor, fontSize: 20, fontWeight: FontWeight.bold)))
      ),
      backgroundColor: Colors.white,
      body: Obx(() => body),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        items: [
          BottomNavigationBarItem(
            label: '매칭',
            icon: Icon(Icons.emoji_emotions),
          ),
          BottomNavigationBarItem(
            label: '히스토리',
            icon: Icon(Icons.history),
          ),
          BottomNavigationBarItem(
            label: '내 프로필',
            icon: Icon(Icons.person),
          ),
        ],
        onTap: controller.onTapTouched,
        selectedItemColor: mainColor,
      )),
    );
  }
}