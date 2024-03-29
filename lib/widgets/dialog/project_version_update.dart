import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/common/logic_state.dart';

/*
* 修改项目版本号弹窗
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class ProjectVersionUpdateDialog extends StatefulWidget {
  // 编辑项目信息时回传对象
  final ProjectModel initialProjectInfo;

  const ProjectVersionUpdateDialog({
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
      builder: (_) => ProjectVersionUpdateDialog(
        initialProjectInfo: initialProjectInfo,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _ProjectVersionUpdateDialogState();
}

/*
* 修改项目版本号弹窗-状态
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class _ProjectVersionUpdateDialogState extends LogicState<
    ProjectVersionUpdateDialog, _ProjectVersionUpdateDialogLogic> {
  @override
  _ProjectVersionUpdateDialogLogic initLogic() =>
      _ProjectVersionUpdateDialogLogic(widget.initialProjectInfo);

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Row(
        children: [
          const Text('修改 pubspec.yaml 文件中的项目版本'),
          IconButton(
              icon: const Icon(FluentIcons.info),
              onPressed: () {
                final projectPath = logic.projectInfo.project.path;
                Utils.showSnackWithFilePath(
                  context,
                  '$projectPath/${ProjectFilePath.pubspec}',
                );
              }),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Form(
          key: logic.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: _buildProjectVersion(context),
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
  final _versionRegExp = RegExp(r'[0-9.+]');

  // 构建项目版本号
  Widget _buildProjectVersion(BuildContext context) {
    return InfoLabel(
      label: '版本号 "${_versionRegExp.pattern}"',
      child: TextFormBox(
        controller: logic.versionController,
        autofocus: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        suffix: Row(
          children: [
            Tooltip(
              message: '自增版本号',
              child: IconButton(
                icon: const Icon(FluentIcons.add_multiple),
                onPressed: () {
                  final v = logic.versionController.value.text;
                  logic.updateInput(Utils.autoIncrement(context, v));
                },
              ),
            ),
            Tooltip(
              message: '重置版本号',
              child: IconButton(
                icon: const Icon(FluentIcons.reset),
                onPressed: () =>
                    logic.updateInput(widget.initialProjectInfo.version),
              ),
            ),
          ],
        ),
        validator: (v) {
          if (null == v || v.isEmpty) return '不能为空';
          if (v.split('+').length != 2) return '"+"号必须有且只有一个';
          return null;
        },
        onSaved: (v) {
          if (null != v && logic.projectInfo.version != v) {
            logic.projectInfo.modifyProjectVersion(v, autoCommit: true);
          }
        },
        inputFormatters: [
          FilteringTextInputFormatter.allow(_versionRegExp),
        ],
      ),
    );
  }
}

/*
* 修改项目版本号弹窗-逻辑
* @author wuxubaiyang
* @Time 2022/11/1 17:15
*/
class _ProjectVersionUpdateDialogLogic extends BaseLogic {
  // 版本号输入框控制器
  final TextEditingController versionController;

  // 表单key
  final formKey = GlobalKey<FormState>();

  // 项目信息
  final ProjectModel projectInfo;

  _ProjectVersionUpdateDialogLogic(this.projectInfo)
      : versionController = TextEditingController(text: projectInfo.version);

  // 更新输入框内容
  void updateInput(String text) {
    versionController.value = TextEditingValue(
      text: text,
      selection: TextSelection.fromPosition(
        TextPosition(
          affinity: TextAffinity.downstream,
          offset: text.length,
        ),
      ),
    );
  }

  // 提交项目版本号修改
  Future<void> submit(BuildContext context) async {
    var state = formKey.currentState;
    if (null != state && state.validate()) {
      state.save();
      Navigator.maybePop(context, projectInfo);
    }
  }

  @override
  void dispose() {
    versionController.dispose();
    super.dispose();
  }
}
