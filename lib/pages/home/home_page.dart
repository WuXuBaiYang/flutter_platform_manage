import 'package:flutter/material.dart';
import 'package:flutter_platform_manage/model/db/project.dart';
import 'package:flutter_platform_manage/utils/info_handle.dart';
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
            var projectInfoHandle = ProjectInfoHandle();

            /// 应用版本号
            var version = await projectInfoHandle.loadVersion(rootPath);
            print(version);
            await projectInfoHandle.setVersion(rootPath, "1.3.2+12");
            version = await projectInfoHandle.loadVersion(rootPath);
            print(version);
            /// 应用名称（仅英文）
            var name = await projectInfoHandle.loadName(rootPath);
            print(name);
            await projectInfoHandle.setName(rootPath, "testName");
            name = await projectInfoHandle.loadName(rootPath);
            print(name);
            var androidInfoHandle = AndroidInfoHandle();

            /// android项目名称
            var label = await androidInfoHandle.loadLabel(rootPath);
            print(label);
            await androidInfoHandle.setLabel(rootPath, "测试名称");
            label = await androidInfoHandle.loadLabel(rootPath);
            print(label);

            /// android项目包名
            var package = await androidInfoHandle.loadPackage(rootPath);
            print(package);
            await androidInfoHandle.setPackage(rootPath, "com.jtech.test");
            package = await androidInfoHandle.loadPackage(rootPath);
            print(package);
            /// android图标名
            var icon = await androidInfoHandle.loadIconPath(rootPath);
            print(icon);
          },
        ),
      ),
    );
  }
}
