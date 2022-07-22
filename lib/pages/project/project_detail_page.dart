import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/manager/project_manage.dart';
import 'package:flutter_platform_manage/manager/router_manage.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/widgets/app_page.dart';
import 'package:flutter_platform_manage/widgets/notice_box.dart';
import 'package:window_manager/window_manager.dart';

/*
* 项目详情页
* @author JTech JH
* @Time 2022-07-22 11:38:04
*/
class ProjectDetailPage extends StatefulWidget {
  const ProjectDetailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProjectDetailPageState();
}

/*
* 项目详情页-状态
* @author JTech JH
* @Time 2022-07-22 11:38:37
*/
class _ProjectDetailPageState extends State<ProjectDetailPage>
    with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: "项目详情",
      content: ScaffoldPage.withPadding(
        content: FutureBuilder<ProjectModel>(
          future: loadProjectInfo(),
          builder: (_, snap) {
            if (snap.hasData) {
              var projectInfo = snap.data!;
              return Text("${projectInfo.getShowTitle()}");
            }
            if (snap.hasError) {
              return NoticeBox.warning(
                message: snap.error.toString(),
              );
            }
            return const Center(child: ProgressRing());
          },
        ),
      ),
    );
  }

  // 项目信息
  ProjectModel? _cacheProject;

  // 更新当前项目信息
  Future<ProjectModel> loadProjectInfo() async {
    if (null == _cacheProject) {
      var key = jRouter.find<String>(context, "key");
      if (null == key || key.isEmpty) throw Exception("项目key不能为空");
      _cacheProject = await projectManage.getProjectInfo(key);
      if (null == _cacheProject) throw Exception("项目信息不存在");
    }
    return Future.value(_cacheProject);
  }

  @override
  void onWindowFocus() {
    setState(() => _cacheProject = null);
  }

  @override
  void onWindowRestore() {
    setState(() => _cacheProject = null);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }
}
