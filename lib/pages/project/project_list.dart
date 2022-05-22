import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/utils/script_handle.dart';
import 'package:flutter_platform_manage/widgets/env_import_dialog.dart';
import 'package:flutter_platform_manage/widgets/project_import_dialog.dart';

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
    dbManage.deleteMany(dbManage.loadAllEnvironments());
    return ScaffoldPage(
      content: Center(
        child: TextButton(
          child: Text("click"),
          onPressed: () async {
            ProjectImportDialog.show(context);
          },
        ),
      ),
    );
  }
}
