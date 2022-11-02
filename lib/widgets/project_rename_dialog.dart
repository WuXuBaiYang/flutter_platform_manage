import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/utils.dart';

/*
* 修改项目名弹窗
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class ProjectReNameDialog extends StatefulWidget {
  // 编辑项目信息时回传对象
  final ProjectModel initialProjectInfo;

  const ProjectReNameDialog({
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
      builder: (_) => ProjectReNameDialog(
        initialProjectInfo: initialProjectInfo,
      ),
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
  // 逻辑管理
  late final _logic = _ProjectReNameDialogLogic(widget.initialProjectInfo);

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Row(
        children: [
          const Text('修改 pubspec.yaml 文件中的项目名称'),
          IconButton(
            icon: const Icon(FluentIcons.info),
            onPressed: () {
              final projectPath = _logic.projectInfo.project.path;
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
          key: _logic.formKey,
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
          onPressed: () => _logic.submit(context),
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
            controller: _logic.nameController,
            autofocus: true,
            suffix: Visibility(
              visible: _logic.nameController.text.isNotEmpty,
              child: IconButton(
                icon: const Icon(FluentIcons.cancel),
                onPressed: () => state(() => _logic.nameController.clear()),
              ),
            ),
            onChanged: (v) => state(() {}),
            validator: (v) {
              if (null == v || v.isEmpty) return '不能为空';
              return null;
            },
            onSaved: (v) {
              if (null != v && _logic.projectInfo.name != v) {
                _logic.projectInfo.modifyProjectName(v, autoCommit: true);
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(_reNameRegExp),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }
}

/*
* 修改项目名弹窗-逻辑
* @author wuxubaiyang
* @Time 2022/11/1 16:51
*/
class _ProjectReNameDialogLogic extends BaseLogic {
  // 表单key
  final formKey = GlobalKey<FormState>();

  // 输入框控制器
  final TextEditingController nameController;

  // 项目对象
  final ProjectModel projectInfo;

  _ProjectReNameDialogLogic(this.projectInfo)
      : nameController = TextEditingController(text: projectInfo.name);

  // 提交项目名修改
  Future<void> submit(BuildContext context) async {
    var state = formKey.currentState;
    if (null != state && state.validate()) {
      state.save();
      Navigator.maybePop(context, projectInfo);
    }
  }
}
