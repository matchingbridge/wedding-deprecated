import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wedding/components/elements.dart';
import 'package:wedding/components/popup.dart';
import 'package:wedding/data/colors.dart';
import 'package:wedding/data/models.dart';
import 'package:wedding/data/strings.dart';
import 'package:wedding/pages/mobile/matching_page.dart';
import 'package:wedding/services/mobile/match_service.dart';

class HistoryController extends GetxController {
  var matched = List<Match>.empty().obs;
  var pending = List<Match>.empty().obs;

  @override
  void onInit() {
    super.onInit();
    getMatches();
  }

  void showPartner(String partnerID) {
    Get.to(() => MatchingPage(), arguments: {'partner_id': partnerID});
  }

  Future<void> finish(String partnerID) async {
    var reviewController = TextEditingController();
    var action = await Get.defaultDialog(
      radius: 8,
      title: '만남 종료', titleStyle: TextStyle(color: mainColor, fontSize: 20, fontWeight: FontWeight.bold), titlePadding: EdgeInsets.fromLTRB(0, 16, 0, 8),
      content: Padding(
        child: Column(
          children: [
            Text('매칭 상대는 어떠셨나요?', style: TextStyle(color: hintColor, fontSize: 12)),
            Divider(color: Colors.transparent, height: 12),
            TextField(
              controller: reviewController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: hintColor)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: hintColor)),
                fillColor: toggleColor,
                filled: true,
                hintText: '상세한 후기는 서비스 발전에 큰 도움이 됩니다.',
                hintStyle: TextStyle(color: hintColor, fontSize: 12)
              ),
              maxLines: 5,
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
      contentPadding: EdgeInsets.zero,
      confirm: GestureDetector(
        child: Container(
          child: Text('후기 남기기', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            color: mainColor, 
          ),
          padding: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity
        ),
        onTap: () => Get.back(result: true),
      ),
    );
    if (action != null)
      terminateMatch(partnerID, reviewController.text);
  }

  Future<void> getMatches() async {
    matched.clear();
    pending.clear();
    try {
      var matches = await MatchService.getHistory(); 
      for (var match in matches) {
        if (match.matchedAt != null)
          matched.add(match);
        else
          pending.add(match);
      }
    } catch (e) {
      await buildPopup(failedToGetMatchesPopup, '$e');
    }
  }

  Future<void> answerMatch(String partnerID, bool accept) async {
    try {
      await MatchService.answerMatch(partnerID, accept);
    } catch (e) {
      await buildPopup(failedToAnswerMatchPopup, '$e');
    }
  }

  Future<void> terminateMatch(String partnerID, String review) async {
    try {
      await MatchService.terminateMatch(partnerID, review);
    } catch (e) {
      await buildPopup(failedToTerminateMatchPopup, '$e');
    }
  }
}

class HistoryPage extends StatelessWidget {
  final controller = Get.put(HistoryController());
  int get matchedRowCount => (controller.matched.length / 3).ceil();
  int get pendingRowCount => (controller.pending.length / 3).ceil();

  Widget buildEmpty() => Center(child: Text('아직 매칭 기록이 없어요!', style: TextStyle(color: greyColor, fontSize: 16)));
  
  Widget buildMatched(List<Match> matches) => Row(
    children: matches.map<Widget>((e) => buildPerson()).toList()
  );

  Widget buildPending(List<Match> pending) => Row(
    children: pending.map<Widget>((e) => buildPerson(width: 100, height: 100)).toList(),
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  );

  Widget buildHistory() => CustomScrollView(
    slivers: [
      SliverAppBar(
        title: Text('지금까지의 인연', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), 
        backgroundColor: mainColor
      ),
      SliverPadding(
        sliver: SliverGrid.count(
          children: controller.matched.map((e) => LayoutBuilder(builder: (context, constraints) => buildPerson(
            action: e.terminatedAt == null ? PersonAction(color: warningColor, label: '만남 종료', onPressed: () => controller.finish(e.partnerID)) : null,
            thumbnail: e.thumbnail, 
            shadow: e.terminatedAt != null, 
            width: constraints.maxWidth, 
            height: constraints.maxHeight
          ))).toList(), 
          crossAxisCount: 3, 
          mainAxisSpacing: 20, 
          crossAxisSpacing: 20
        ), 
        padding: EdgeInsets.all(20)
      ),
      SliverAppBar(
        title: Text('나를 선택한 인연', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), 
        backgroundColor: mainColor
      ),
      SliverPadding(
        sliver: SliverGrid.count(
          children: controller.pending.map((e) => LayoutBuilder(builder: (context, constraints) => buildPerson(
            action: e.terminatedAt == null ? PersonAction(color: mainColor, label: '프로필 보기', onPressed: () => controller.showPartner(e.partnerID),) : null, 
            thumbnail: e.thumbnail,
            shadow: e.terminatedAt != null, 
            width: constraints.maxWidth, 
            height: constraints.maxHeight
          ))).toList(), 
          crossAxisCount: 3, 
          mainAxisSpacing: 20, 
          crossAxisSpacing: 20
        ), 
        padding: EdgeInsets.all(20)
      ),
    ],
    shrinkWrap: true,
  );
  
  @override
  Widget build(BuildContext context) => Obx(() => controller.matched.isEmpty && controller.pending.isEmpty ? buildEmpty() : buildHistory());
}