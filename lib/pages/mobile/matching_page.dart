import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:wedding/components/button.dart';
import 'package:wedding/components/popup.dart';
import 'package:wedding/data/colors.dart';
import 'package:wedding/data/enums.dart';
import 'package:wedding/data/models.dart';
import 'package:wedding/data/strings.dart';
import 'package:wedding/pages/mobile/root_page.dart';
import 'package:wedding/services/mobile/match_service.dart';
import 'package:wedding/services/mobile/user_service.dart';

class MatchingController extends GetxController {
  void back() => Get.back();
  var partner = Rxn<User>();
  var match = Rxn<Match>();

  @override
  void onInit() {
    super.onInit();

    var partnerID = Get.arguments['partner_id'] as String;
    getPartner(partnerID);
    getMatch(partnerID);
  }

  Future<void> getPartner(String partnerID) async {
    try {
      partner.value = await UserService.getPartner(partnerID);
    } catch (e) {
      await buildPopup(failedToGetUserPopup, '$e');
    }
  }

  Future<void> getMatch(String partnerID) async {
    try {
      match.value = await MatchService.getMatch(partnerID: partnerID);
    } catch (e) {
      await buildPopup(failedToGetMatchPopup, '$e');
    }
  }

  Future<void> askMatch() async {
    var partnerValue = partner.value;
    if (partnerValue == null)
      return;

    var confirm = await buildButtonPopup(
      confirmToAskMatchPopup, 
      Column(children: [Text('${partnerValue.userID}님께 매칭을 신청하시겠습니까?')],), 
      '매칭 신청하기', 
      () => Get.back(result: true)
    );
    if (confirm == null)
      return;

    try {
        match.value = await MatchService.askMatch(partnerValue.userID);
    } catch (e) {
      await buildPopup(failedToAskMatchPopup, '$e');
    }
  }

  Future<void> answerMatch() async {
    var partnerValue = partner.value;
    if (partnerValue == null)
      return;

    var accept = await buildButtonsPopup(
      confirmToAskMatchPopup, 
      Column(children: [Text('${partnerValue.userID}님의 신청을 수락하시겠습니까?')],), 
      '매칭 수락하기', 
      '매칭 거절하기',
      () => Get.back(result: true),
      () => Get.back(result: false)
    );
    if (accept == null)
      return;
    
    try{
      match.value = await MatchService.answerMatch(partnerValue.userID, accept);
    } catch (e) {
      await buildPopup(failedToAskMatchPopup, '$e');
    }
  }
}

class MatchingPage extends StatelessWidget {
  final controller = Get.put(MatchingController());
  final mediaTypes = ["face1", "face2", "body1", "body2", "video"];

  Widget buildMedia(User partner) => LayoutBuilder(builder: (context, constraint) => SizedBox(
    child: ListView.builder(
      itemBuilder: (context, index) => Container(
        child: index == 4 ? 
          SizedBox(
            child: VideoPlayer(VideoPlayerController.network(partner.media(mediaTypes[index]))..initialize()),
            width: constraint.maxWidth
          ): 
          Image.network(
            partner.media(mediaTypes[index]), 
            fit: BoxFit.fitWidth, width: constraint.maxWidth,
          ),
        color: Colors.black,
      ), 
      itemCount: mediaTypes.length, 
      scrollDirection: Axis.horizontal, 
      physics: PageScrollPhysics(),
      shrinkWrap: true
    ),
    width: constraint.maxWidth,
    height: 500
  ));

  Widget buildLabelText(String label, String content) => Row(
    children: [
      Flexible(child: Text(label), flex: 1,),
      Flexible(child: Text(content), flex: 3)
    ],
    mainAxisAlignment: MainAxisAlignment.spaceBetween
  );

  Widget buildProfile(User partner) => Padding(
    child: Column(
      children: [
        Text('${partner.userID} / ${partner.age}세', style: TextStyle(color: greyColor, fontSize: 20, fontWeight: FontWeight.bold)),
        Divider(color: Colors.transparent, height: 24),
        Text('${partner.introduction}', style: TextStyle(color: greyColor, fontSize: 16)),
        Divider(color: Colors.transparent, height: 12),
        buildLabelText('학력', '${partner.scholar.literal} / ${partner.school}'),
        Divider(color: Colors.transparent, height: 12),
        buildLabelText('직업', '${partner.job.literal} / ${partner.workplace}'),
        Divider(color: Colors.transparent, height: 12),
        buildLabelText('거주지역', partner.area.literal),
        Divider(color: Colors.transparent, height: 12),
        buildLabelText('결혼경험 여부', partner.marriage.literal),
        Divider(color: Colors.transparent, height: 12),
        buildLabelText('연봉', partner.salaryLiteral),
        Divider(color: Colors.transparent, height: 12),
        buildLabelText('보유 자산 총액', partner.assetLiteral),
        Divider(color: Colors.transparent, height: 12),
        buildLabelText('부동산', partner.realestateLiteral),
        Divider(color: Colors.transparent, height: 12),
        buildLabelText('부동산', partner.vehicleLiteral),
        Divider(color: Colors.transparent, height: 12),
        buildLabelText('체형', '${partner.bodyTypeLiteral} ${partner.height}cm / ${partner.weight}kg'),
        Divider(color: Colors.transparent, height: 12),
        buildLabelText('성격', partner.characterLiteral),
        Divider(color: Colors.transparent, height: 12),
        buildLabelText('흡연여부', partner.smoke.literal),
        Divider(color: Colors.transparent, height: 12),
        buildLabelText('종교', partner.religion.literal),
        Divider(color: Colors.transparent, height: 12),
        buildLabelText('장거리\n가능 여부', partner.longDistance ? '예' : '아니오'),
        Divider(color: Colors.transparent, height: 12),
        buildLabelText('희망 결혼시기', partner.wedding.literal),
        Divider(color: Colors.transparent, height: 12),
        Text(partner.partnerOther, style: TextStyle(color: greyColor, fontSize: 12)),
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch
    ),
    padding: EdgeInsets.all(20),
  );

  Widget buildMatch() {
    if (controller.partner.value == null)
      return buildButton(child: Text('로딩 중', style: TextStyle(color: Colors.white)), color: loadingColor, radius: 0);
    else if (controller.match.value == null)
      return buildButton(child: Text('매칭 신청', style: TextStyle(color: Colors.white)), color: mainColor, radius: 0, onPressed: controller.askMatch);
    else if (controller.match.value!.matchedAt == null) {
      var user = Get.find<RootController>().user.value;
      if (controller.match.value!.senderID == user.userID)
        return buildButton(child: Text('매칭 대기중', style: TextStyle(color: Colors.white)), color: waitColor, radius: 0);
      else
        return buildButton(child: Text('매칭 응답하기', style: TextStyle(color: Colors.white)), color: mainColor, radius: 0, onPressed: controller.answerMatch);
    }
    else if (controller.match.value!.terminatedAt == null)
      return buildButton(child: Text('매칭 완료', style: TextStyle(color: Colors.white)), color: okColor, radius: 0);
    else
      return buildButton(child: Text('종료된 매칭', style: TextStyle(color: Colors.white)), color: greyColor, radius: 0);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: mainColor,
      centerTitle: true,
      leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: controller.back),
      title: Text('오늘의 맞선'),
    ),
    backgroundColor: Colors.white,
    body: Obx(() => ListView(
      children: [
        if (controller.partner.value != null)
          buildMedia(controller.partner.value!),
        buildMatch(),
        if (controller.partner.value != null)
          buildProfile(controller.partner.value!),
      ],
      shrinkWrap: true,
      physics: ClampingScrollPhysics()
    ),
  ));
}