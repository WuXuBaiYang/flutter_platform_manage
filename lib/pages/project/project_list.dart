import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/manager/project_manage.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/widgets/project_import_dialog.dart';
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
  // 项目列表
  late List<ProjectModel> _projectList = [];

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
    // 加载项目列表
    updateProjectList();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: const Text("项目列表"),
        commandBar: Row(
          children: [
            Visibility(
              visible: _projectList.isNotEmpty,
              child: buildAddButton(),
            ),
          ],
        ),
      ),
      content: _projectList.isEmpty
          ? Center(child: buildAddButton())
          : buildProjectList(),
    );
  }

  // 构建新增按钮
  Widget buildAddButton() {
    return FilledButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(FluentIcons.add),
          SizedBox(width: 8),
          Text("新增"),
        ],
      ),
      onPressed: () => ProjectImportDialog.show(context),
    );
  }

  // 构建项目列表
  Widget buildProjectList() {
    return TextButton(
      child: Text("项目列表"),
      onPressed: () {},
    );
  }

  // 更新现有项目列表
  void updateProjectList() {
    projectManage.loadAll().then((v) {
      setState(() => _projectList = v);
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    print("update");
  }

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
