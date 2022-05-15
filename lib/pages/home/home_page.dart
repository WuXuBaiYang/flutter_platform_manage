import 'package:flutter/material.dart';
import 'package:flutter_platform_manage/model/db/project.dart';
import 'package:flutter_platform_manage/utils/platform_info_handler.dart';
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
          onPressed: () async {
            var rootPath =
                r"C:\Users\wuxubaiyang\Documents\WorkSpace\platform_test";
            // var version = await ProjectInfoHandle.loadVersion(rootPath);
            // print(version);
            // await ProjectInfoHandler.setVersion(rootPath, "1.3.2+12");
            // version = await ProjectInfoHandle.loadVersion(rootPath);
            // print(version);
          },
        ),
      ),
    );
  }
}
