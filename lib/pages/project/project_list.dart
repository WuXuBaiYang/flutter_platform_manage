import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';

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
          onPressed: () {},
        ),
      ),
    );
  }
}
