import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wedding/components/popup.dart';
import 'package:wedding/data/enums.dart';
import 'package:wedding/data/models.dart';
import 'package:wedding/data/strings.dart';
import 'package:wedding/services/web/admin_service.dart';

class UsersController extends GetxController {
  var users = <UserBase>[].obs;
  @override
  void onInit() {
    super.onInit();
    getUsers();
  }

  Future<void> getUsers() async {
    try {
      users.value = await AdminService.getUsers();
    } catch (error) {
      buildPopup(failedToGetUserPopup, '$error');
    }
  }

  Future<void> review(int authID) async {
    try {
      await AdminService.reviewUser(authID);
      for (var user in users) {
        if (user.authID == authID)
          user.reviewedAt = DateTime.now();
      }
      users.refresh();
    } catch (error) {
      buildPopup(failedToReviewPopup, '$error');
    }
  }
}

class UsersPage extends StatelessWidget {
  final controller = Get.put(UsersController());

  Widget buildLabel() => Row(
    children: [
      Text('ID'),
      Text('이름'),
      Text('성별'),
      Text('결혼여부'),
      Text('지역'),
      Text('학력'),
      Text('직업'),
      Text('심사')
    ],
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
  );

  Widget buildUser(UserBase user) => Row(
    children: [
      Text(user.userID),
      Text(user.name),
      Text(user.gender.literal),
      Text(user.marriage.literal),
      Text(user.area.literal),
      Text(user.scholar.literal),
      Text(user.job.literal),
      if (user.reviewedAt == null)
        TextButton(onPressed: () => controller.review(user.authID), child: Text('통과'))
      else
        Text('완료')
    ],
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
  );

  @override
  Widget build(BuildContext context) => Obx(() => controller.users.isEmpty ? Center(child: Text('no user')) : ListView.separated(
    itemBuilder: (context, index) => index == 0 ? buildLabel() : buildUser(controller.users[index - 1]), 
    separatorBuilder: (context, index) => Divider(height: 16), 
    itemCount: controller.users.length + 1,
    padding: EdgeInsets.all(20)
  ));
}