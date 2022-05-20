import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/model/db/project.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/utils.dart';

/*
* 项目列表页
* @author wuxubaiyang
* @Time 5/18/2022 5:14 PM
*/
class ProjectListPage extends StatefulWidget {
  const ProjectListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProjectListPageState();
}

/*
* 项目列表页-状态
* @author wuxubaiyang
* @Time 5/18/2022 5:14 PM
*/
class _ProjectListPageState extends State<ProjectListPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      content: Center(
        child: TextButton(
          child: Text("click"),
          onPressed: () async {
            var p = await ProjectModel.create(
                project: Project(
                    Utils.genID(),
                    r"C:\Users\wuxubaiyang\Documents\WorkSpace\platform_test",
                    "",
                    0));
            // p?.name = "test_name1";
            // p?.version = "1.2.3+123";
            var a = p?.platforms.firstWhere(
                    (element) => element.type == PlatformType.android)
                as AndroidPlatform;
            // a.package = "com.jt.a1";
            // a.label = "测试项目";
            // p?.commit();
            var b = a.loadIcons(p?.project.path ?? "");
            print(b);
          },
        ),
      ),
    );
  }
}
