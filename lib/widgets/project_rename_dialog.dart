import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/utils.dart';

/*
* 修改项目名弹窗
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class ProjectReNameDialog extends StatefulWidget {
  // 编辑项目信息时回传对象
  final ProjectModel projectModel;

  const ProjectReNameDialog({
    Key? key,
    required this.projectModel,
  }) : super(key: key);

  // 显示项目导入弹窗
  static Future<ProjectModel?> show(
    BuildContext context, {
    required ProjectModel projectModel,
  }) {
    return showDialog<ProjectModel>(
      context: context,
      builder: (_) => ProjectReNameDialog(projectModel: projectModel),
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
  // 输入框控制器
  late TextEditingController controller =
      TextEditingController(text: widget.projectModel.name);

  // 输入框输入规则
  final reNameRegExp = RegExp(r'[A-Z,a-z,_]');

  // 表单key
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Row(
        children: [
          const Text("修改 pubspec.yaml 文件中的项目名称"),
          IconButton(
            icon: const Icon(FluentIcons.info),
            onPressed: () {
              var filePath =
                  "${widget.projectModel.project.path}/${ProjectFilePath.pubspec}";
              Utils.showSnackWithFilePath(context, filePath);
            },
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: InfoLabel(
            label: "项目名称 '${reNameRegExp.pattern}'",
            child: StatefulBuilder(
              builder: (_, state) {
                return TextFormBox(
                  controller: controller,
                  autofocus: true,
                  suffix: Visibility(
                    visible: controller.text.isNotEmpty,
                    child: IconButton(
                      icon: const Icon(FluentIcons.cancel),
                      onPressed: () => state(() => controller.clear()),
                    ),
                  ),
                  onChanged: (v) => state(() {}),
                  validator: (v) {
                    if (null == v || v.isEmpty) return "不能为空";
                    return null;
                  },
                  onSaved: (v) {
                    if (null != v && widget.projectModel.name != v) {
                      widget.projectModel
                          .modifyProjectName(v, autoCommit: true);
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(reNameRegExp),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      actions: [
        Button(
          child: const Text("取消"),
          onPressed: () => Navigator.maybePop(context),
        ),
        FilledButton(
          child: const Text("修改"),
          onPressed: () {
            var state = formKey.currentState;
            if (null != state && state.validate()) {
              state.save();
              Navigator.maybePop(context, widget.projectModel);
            }
          },
        ),
      ],
    );
  }
}
