import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/utils.dart';

/*
* 修改项目版本号弹窗
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class ProjectVersionDialog extends StatefulWidget {
  // 编辑项目信息时回传对象
  final ProjectModel projectModel;

  const ProjectVersionDialog({
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
      builder: (_) => ProjectVersionDialog(projectModel: projectModel),
    );
  }

  @override
  State<StatefulWidget> createState() => _ProjectVersionDialogState();
}

/*
* 修改项目版本号弹窗-状态
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class _ProjectVersionDialogState extends State<ProjectVersionDialog> {
  // 版本号输入框控制器
  late TextEditingController controller =
      TextEditingController(text: widget.projectModel.version);

  // 输入框输入规则
  final versionRegExp = RegExp(r'[0-9,.,+]');

  // 表单key
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Row(
        children: [
          const Text("修改 pubspec.yaml 文件中的项目版本"),
          IconButton(
              icon: const Icon(FluentIcons.info),
              onPressed: () {
                var filePath =
                    "${widget.projectModel.project.path}/${ProjectFilePath.pubspec}";
                Utils.showSnackWithFilePath(context, filePath);
              }),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: InfoLabel(
            label: "版本号 '${versionRegExp.pattern}'",
            child: TextFormBox(
              controller: controller,
              autofocus: true,
              autovalidateMode: AutovalidateMode.always,
              suffix: Row(
                children: [
                  Tooltip(
                    message: "自增版本号",
                    child: IconButton(
                      icon: const Icon(FluentIcons.add_multiple),
                      onPressed: () => autoIncrement(),
                    ),
                  ),
                  Tooltip(
                    message: "重置版本号",
                    child: IconButton(
                      icon: const Icon(FluentIcons.reset),
                      onPressed: () => updateInput(widget.projectModel.version),
                    ),
                  ),
                ],
              ),
              validator: (v) {
                if (null == v || v.isEmpty) return "不能为空";
                if (v.split("+").length != 2) return "'+'号必须有且只有一个";
                return null;
              },
              onSaved: (v) {
                if (null != v && widget.projectModel.version != v) {
                  widget.projectModel.modifyProjectVersion(v);
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(versionRegExp),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Button(
          child: const Text("取消"),
          onPressed: () => Navigator.pop(context),
        ),
        FilledButton(
          child: const Text("修改"),
          onPressed: () {
            var state = formKey.currentState;
            if (null != state && state.validate()) {
              state.save();
              Navigator.pop(context, widget.projectModel);
            }
          },
        ),
      ],
    );
  }

  // 更新输入框内容
  void updateInput(String text) {
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.fromPosition(
          TextPosition(affinity: TextAffinity.downstream, offset: text.length)),
    );
  }

  // 版本号自增
  void autoIncrement() {
    var t = controller.text.split("+");
    if (t.length != 2) {
      Utils.showSnack(context, "版本号格式错误");
      return;
    }
    var vName = t.first, vCode = t.last;
    var c = int.tryParse(vCode);
    if (null == c) {
      Utils.showSnack(context, "版本号格式化失败");
      return;
    }
    vCode = "${++c}";
    t = vName.split(".");
    t.last = vCode;
    vName = t.join(".");
    updateInput("$vName+$vCode");
  }
}
