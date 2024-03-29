import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/common/logic_state.dart';

/*
* 修改项目名弹窗
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class ProjectNameUpdateDialog extends StatefulWidget {
  // 编辑项目信息时回传对象
  final ProjectModel initialProjectInfo;

  const ProjectNameUpdateDialog({
    Key? key,
    required this.initialProjectInfo,
  }) : super(key: key);

  // 显示项目导入弹窗
  static Future<ProjectModel?> show(
    BuildContext context, {
    required ProjectModel initialProjectInfo,
  }) {
    return showDialog<ProjectModel>(
      context: context,
      builder: (_) => ProjectNameUpdateDialog(
        initialProjectInfo: initialProjectInfo,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _ProjectNameUpdateDialogState();
}

/*
* 修改项目名弹窗-状态
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class _ProjectNameUpdateDialogState
    extends LogicState<ProjectNameUpdateDialog, _ProjectNameUpdateDialogLogic> {
  @override
  _ProjectNameUpdateDialogLogic initLogic() =>
      _ProjectNameUpdateDialogLogic(widget.initialProjectInfo);

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Row(
        children: [
          const Text('修改 pubspec.yaml 文件项目名称'),
          IconButton(
            icon: const Icon(FluentIcons.info),
            onPressed: () {
              final projectPath = logic.projectInfo.project.path;
              Utils.showSnackWithFilePath(
                context,
                '$projectPath/${ProjectFilePath.pubspec}',
              );
            },
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Form(
          key: logic.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: _buildProjectName(),
        ),
      ),
      actions: [
        Button(
          child: const Text('取消'),
          onPressed: () => Navigator.maybePop(context),
        ),
        FilledButton(
          onPressed: () => logic.submit(context),
          child: const Text('修改'),
        ),
      ],
    );
  }

  // 输入框输入规则
  final _reNameRegExp = RegExp(r'[A-Za-z_]');

  // 构建项目名称
  Widget _buildProjectName() {
    return InfoLabel(
      label: '项目名称 "${_reNameRegExp.pattern}"',
      child: StatefulBuilder(
        builder: (_, state) {
          return TextFormBox(
            controller: logic.nameController,
            autofocus: true,
            suffix: Visibility(
              visible: logic.nameController.text.isNotEmpty,
              child: IconButton(
                icon: const Icon(FluentIcons.cancel),
                onPressed: () => state(() => logic.nameController.clear()),
              ),
            ),
            onChanged: (v) => state(() {}),
            validator: (v) {
              if (null == v || v.isEmpty) return '不能为空';
              return null;
            },
            onSaved: (v) {
              if (v == null || logic.projectInfo.name == v) return;
              logic.projectInfo.modifyProjectName(v, autoCommit: true);
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(_reNameRegExp),
            ],
          );
        },
      ),
    );
  }
}

/*
* 修改项目名弹窗-逻辑
* @author wuxubaiyang
* @Time 2022/11/1 16:51
*/
class _ProjectNameUpdateDialogLogic extends BaseLogic {
  // 输入框控制器
  final TextEditingController nameController;

  // 表单key
  final formKey = GlobalKey<FormState>();

  // 项目对象
  final ProjectModel projectInfo;

  _ProjectNameUpdateDialogLogic(this.projectInfo)
      : nameController = TextEditingController(text: projectInfo.name);

  // 提交项目名修改
  Future<void> submit(BuildContext context) async {
    var state = formKey.currentState;
    if (null != state && state.validate()) {
      state.save();
      Navigator.maybePop(context, projectInfo);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
