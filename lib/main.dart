import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/pages/home/home_page.dart';
import 'package:jtech_pomelo/pomelo.dart';

void main() async {
  //运行项目
  runJAppRoot(
    debug: true,
    title: Common.appName,
    homePage: const HomePage(),
    initialize: () async {
      // 初始化数据库管理
      await dbManage.init();
    },
    routes: {
      "/home": (_) => const HomePage(),
    },
  );
}
