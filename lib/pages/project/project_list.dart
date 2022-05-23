import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/model/db/project.dart';
import 'package:window_manager/window_manager.dart';

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
class _ProjectListPageState extends State<ProjectListPage> with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();

    dbManage.deleteMany(dbManage.all<Project>());
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: SizedBox(),
    );
  }

  // 更新现有项目列表
  Future<void> updateProjectList() async {}

  @override
  void onWindowFocus() {
    updateProjectList();
  }

  @override
  void onWindowRestore() {
    updateProjectList();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }
}
