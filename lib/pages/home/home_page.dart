import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_manage/model/db/project.dart';
import 'package:jtech_pomelo/pomelo.dart';

/*
* 首页
* @author wuxubaiyang
* @Time 2022/5/12 12:49
*/
class HomePage extends BaseStatefulPage {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

/*
* 首页-状态
* @author wuxubaiyang
* @Time 2022/5/12 12:49
*/
class _HomePageState extends BaseState<HomePage> {
  Project? a;

  @override
  Widget build(BuildContext context) {
    return JAppPage(
      showAppbar: false,
      body: Center(
        child: TextButton(
          child: Text("test button"),
          onPressed: () {
            a ??= Project("primaryKey", "name", "path", "environmentKey", 0);
            a?.updateInfo(checkFileUpdate: (path) {
              print("aaaaaaaaaaaaa");
              return true;
            });
          },
        ),
      ),
    );
  }
}
