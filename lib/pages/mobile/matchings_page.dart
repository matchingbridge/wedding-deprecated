import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wedding/components/button.dart';
import 'package:wedding/components/elements.dart';
import 'package:wedding/components/popup.dart';
import 'package:wedding/data/colors.dart';
import 'package:wedding/data/models.dart';
import 'package:wedding/data/strings.dart';
import 'package:wedding/pages/mobile/chat_page.dart';
import 'package:wedding/pages/mobile/matching_page.dart';
import 'package:wedding/services/mobile/base_service.dart';
import 'package:wedding/services/mobile/match_service.dart';
import 'package:wedding/services/mobile/suggestion_service.dart';

class MatchingsController extends GetxController {
  var partnerIDs = <String>[].obs;
  var match = Rxn<Match>();

  @override
  void onInit() {
    super.onInit();
    getMatch();
  }

  Future<void> getMatch() async  {
    try {
      match.value = await MatchService.getMatch();
      if (match.value == null) {
        getSuggestions();
      }
    } catch (e) {
      await buildPopup(failedToFindMatchesPopup, '$e');
    }
  }

  Future<void> getSuggestions() async {
    try {
      var suggestion = await SuggestionService.getSuggestion();
      partnerIDs.value = suggestion.partnerIDs;
    } catch (e) {
      await buildPopup(failedToFindMatchesPopup, '$e');
    }
  }

  void chat() => Get.to(() => ChatPage());

  void showPartner(String partnerID) {
    Get.to(() => MatchingPage(), arguments: {'partner_id': partnerID});
  }
}

class MatchingsPage extends StatelessWidget {
  final controller = Get.put(MatchingsController());

  Widget buildSuggestions() => Column(
    children: [
      GridView.count(
        children: controller.partnerIDs.map(
          (partnerID) => LayoutBuilder(builder: (context, constraint) => buildPerson(
              thumbnail: '${BaseService.endpoint}/user/media/face1/$partnerID', 
              action: PersonAction(color: mainColor, label: '프로필 보기', onPressed: () => controller.showPartner(partnerID),),
              width: constraint.maxWidth, height: constraint.maxHeight
            )
          ),
        ).toList(),
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        shrinkWrap: true,
        padding: EdgeInsets.all(20),
      ),
      Column(
        children: [
          Text('마음에 드는 이성이 없으신가요?', style: TextStyle(color: greyColor, fontSize: 16, fontWeight: FontWeight.bold)),
          Divider(color: Colors.transparent, height: 8),
          Text('주선자에게 원하는 조건의 이성을 직접 소개받을 수 있습니다.', style: TextStyle(color: greyColor, fontSize: 12, fontWeight: FontWeight.bold)),
          Divider(color: Colors.transparent, height: 32),
          buildButton(
            child: Text('주선자에게 소개받기', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),), 
            color: mainColor,
            onPressed: controller.chat,
            padding: EdgeInsets.symmetric(horizontal: 16)
          )
        ],
      )
    ],
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  );

  Widget buildMatch() => Column(
    children: [
      buildPerson(
        thumbnail: controller.match.value!.thumbnail,
        action: PersonAction(color: mainColor, label: '프로필 보기', onPressed: () => controller.showPartner(controller.match.value!.partnerID)),
        width: 150, height: 150
      ),
      Column(
        children: [
          Text('데이트 성공 확률을 높이고 싶으신가요?', style: TextStyle(color: greyColor, fontSize: 16, fontWeight: FontWeight.bold)),
          Divider(color: Colors.transparent, height: 8),
          Text('주선자가 제공하는 만남 관리를 활용해 보세요!.', style: TextStyle(color: greyColor, fontSize: 12, fontWeight: FontWeight.bold)),
          Divider(color: Colors.transparent, height: 32),
          buildButton(
            child: Text('주선자 만남 관리받기', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),), 
            color: mainColor,
            onPressed: controller.chat,
            padding: EdgeInsets.symmetric(horizontal: 16)
          )
        ],
      )
    ],
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  );
  
  @override
  Widget build(BuildContext context) => Obx(() => controller.match.value == null ? buildSuggestions() : buildMatch());
}