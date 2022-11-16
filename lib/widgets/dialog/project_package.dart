import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/logic_state.dart';
import 'package:flutter_platform_manage/model/package.dart';
import 'package:flutter_platform_manage/model/project.dart';

/*
* 项目打包弹窗
* @author wuxubaiyang
* @Time 2022/11/16 9:47
*/
class ProjectPackageDialog extends StatefulWidget {
  // 项目信息
  final ProjectModel initialProjectInfo;

  const ProjectPackageDialog({
    super.key,
    required this.initialProjectInfo,
  });

  // 展示项目打包弹窗
  static Future<PackageModel?> show(
    BuildContext context, {
    required ProjectModel initialProjectInfo,
  }) {
    return showDialog<PackageModel>(
      context: context,
      builder: (_) => ProjectPackageDialog(
        initialProjectInfo: initialProjectInfo,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _ProjectPackageDialogState();
}

/*
* 项目打包弹窗-状态
* @author wuxubaiyang
* @Time 2022/11/16 9:47
*/
class _ProjectPackageDialogState
    extends LogicState<ProjectPackageDialog, _ProjectPackageDialogLogic> {
  @override
  _ProjectPackageDialogLogic initLogic() => _ProjectPackageDialogLogic();

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}

/*
* 项目打包弹窗-逻辑
* @author wuxubaiyang
* @Time 2022/11/16 9:47
*/
class _ProjectPackageDialogLogic extends BaseLogic {}
