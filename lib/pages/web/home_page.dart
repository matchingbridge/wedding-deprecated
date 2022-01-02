import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wedding/pages/web/announcements_page.dart';
import 'package:wedding/pages/web/consults_page.dart';
import 'package:wedding/pages/web/events_page.dart';
import 'package:wedding/pages/web/matches_part.dart';
import 'package:wedding/pages/web/users_page.dart';
import 'package:wedding/pages/web/operators_page.dart';

enum PageType { Users, Consults, Announcements, Events, Operators, Matches }

class HomeController extends GetxController {
  var pageType = PageType.Users.obs;

  void changePage(PageType newPageType) {
    if (pageType.value == newPageType) return;
    pageType.value = newPageType;
  }
}

class HomePage extends StatelessWidget {
  final controller = Get.put(HomeController());

  Widget get page {
    switch (controller.pageType.value) {
      case PageType.Users: return UsersPage();
      case PageType.Consults: return ConsultsPage();
      case PageType.Announcements: return AnnouncementsPage();
      case PageType.Events: return EventsPage();
      case PageType.Operators: return OperatorsPage();
      case PageType.Matches: return MatchesPage();
    }
  }

  Widget buildDrawerTile(String label, PageType type) => ListTile(
    title: Obx(() => Text(label, style: TextStyle(color: controller.pageType.value == type ? Colors.black : Colors.grey))),
    onTap: () => controller.changePage(type),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: Obx(() => page),
    drawer: Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text('운영툴')),
          buildDrawerTile('회원 조회', PageType.Users),
          buildDrawerTile('메시지 상담', PageType.Consults),
          buildDrawerTile('공지사항 작성', PageType.Announcements),
          buildDrawerTile('이벤트 공지', PageType.Events),
          buildDrawerTile('운영자 공지', PageType.Operators),
          buildDrawerTile('매칭 회원 기록 조회', PageType.Matches),
        ],
      ),
    ),
  );
}