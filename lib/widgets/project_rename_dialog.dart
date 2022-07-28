import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/project.dart';

/*
* 修改项目名弹窗
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class ProjectReNameDialog extends StatefulWidget {
  // 编辑项目信息时回传对象
  final ProjectModel projectInfo;

  const ProjectReNameDialog({
    Key? key,
    required this.projectInfo,
  }) : super(key: key);

  // 显示项目导入弹窗
  static Future<ProjectModel?> show(
    BuildContext context, {
    required ProjectModel projectInfo,
  }) {
    return showDialog<ProjectModel>(
      context: context,
      builder: (_) => ProjectReNameDialog(projectInfo: projectInfo),
    );
  }

  @override
  State<StatefulWidget> createState() => _ProjectReNameDialogState();
}

/*
* 修改项目名弹窗-状态
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class _ProjectReNameDialogState extends State<ProjectReNameDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      content: SizedBox(),
      actions: [],
    );
  }
}
