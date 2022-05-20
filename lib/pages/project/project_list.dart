import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/model/db/project.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

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
          onPressed: () async {},
        ),
      ),
    );
  }
}
