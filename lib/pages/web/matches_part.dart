import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wedding/components/popup.dart';
import 'package:wedding/data/strings.dart';
import 'package:wedding/services/web/admin_service.dart';
import 'package:wedding/data/models.dart';
import 'package:wedding/data/util.dart';

class MatchesController extends GetxController {
  var matches = <Match>[].obs;
  @override
  void onInit() {
    super.onInit();
    getMatches();
  }

  Future<void> getMatches() async {
    try {
      matches.value = await AdminService.getMatches();
    } catch (error) {
      buildPopup(failedToGetMatchPopup, '$error');
    }
  }
}

class MatchesPage extends StatelessWidget {
  final controller = Get.put(MatchesController());

  Widget buildLabel() => Row(
    children: [
      Text('신청자 ID'),
      Text('상대방 ID'),
      Text('매칭 신청'),
      Text('매칭 수락'),
      Text('매칭 종료')
    ],
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
  );

  Widget buildMatch(Match match) => Row(
    children: [
      Text(match.senderID),
      Text(match.receiverID),
      Text(match.askedAt?.detailLiteral ?? '기록 없음'),
      Text(match.matchedAt?.detailLiteral ?? '기록 없음'),
      Text(match.terminatedAt?.detailLiteral ?? '기록 없음'),
    ],
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
  );

  @override
  Widget build(BuildContext context) => Obx(() => controller.matches.isEmpty ? Center(child: Text('no matches')) : ListView.separated(
    itemBuilder: (context, index) => index == 0 ? buildLabel() : buildMatch(controller.matches[index - 1]), 
    separatorBuilder: (context, index) => Divider(height: 16), 
    itemCount: controller.matches.length + 1,
    padding: EdgeInsets.all(20)
  ));
}