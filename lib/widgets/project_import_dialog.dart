import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/model/db/environment.dart';
import 'package:flutter_platform_manage/model/db/project.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/utils.dart';

/*
* 项目导入弹窗
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class ProjectImportDialog extends StatefulWidget {
  const ProjectImportDialog({Key? key}) : super(key: key);

  // 显示项目导入弹窗
  static Future<ProjectModel?> show(BuildContext context) {
    return showDialog<ProjectModel>(
      context: context,
      builder: (_) => const ProjectImportDialog(),
    );
  }

  @override
  State<StatefulWidget> createState() => _ProjectImportDialogState();
}

/*
* 项目导入弹窗-状态
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class _ProjectImportDialogState extends State<ProjectImportDialog> {
  // 记录当前所在步骤
  int _currentStep = 0;

  // 项目选择表单的key
  final _projectSelectKey = GlobalKey<FormState>();

  // 步骤视图集合
  late Map<String, Widget> stepsMap = {
    "选择项目": buildProjectSelect(),
    "确认信息": buildProjectInfo(),
  };

  // 步骤表单key集合
  late List<GlobalKey<FormState>?> stepsFormKeyList = [
    _projectSelectKey,
    null,
  ];

  // 项目信息
  late Project project = Project(Utils.genID(), "", "", "");

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(stepsMap.length * 2 - 1, (i) {
              if (i.isOdd) return const Divider(size: 60);
              i = i ~/ 2;
              var it = stepsMap.keys.elementAt(i);
              return RadioButton(
                checked: _currentStep >= i,
                content: Text(it),
                onChanged: (v) {
                  if (i >= _currentStep) return;
                  setState(() => _currentStep = i);
                },
              );
            }),
          ),
          const SizedBox(height: 14),
          IndexedStack(
            index: _currentStep,
            children: stepsMap.values.toList(),
          ),
        ],
      ),
      actions: [
        Button(
          onPressed:
              _currentStep > 0 ? () => setState(() => _currentStep -= 1) : null,
          child: const Text("上一步"),
        ),
        Button(
          child: const Text("取消"),
          onPressed: () => Navigator.pop(context),
        ),
        FilledButton(
          child: Text(_currentStep < stepsMap.length - 1 ? "下一步" : "导入"),
          onPressed: () {
            // 执行当前步骤的表单校验与提交
            var key = stepsFormKeyList[_currentStep];
            if (null != key) {
              if (!(key.currentState?.validate() ?? true)) return;
              key.currentState?.save();
            }
            // 如果是最后一步则执行提交操作
            if (_currentStep >= stepsMap.length - 1) return submit();
            // 增加步长
            setState(() => _currentStep += 1);
          },
        ),
      ],
    );
  }

  // 项目路径选择控制器
  final _projectPathController = TextEditingController();

  // 构建步骤一，项目选择
  Widget buildProjectSelect() {
    return Form(
      key: _projectSelectKey,
      child: Column(
        children: [
          TextFormBox(
            header: "别名",
            onSaved: (v) => project.alias = v ?? "",
          ),
          const SizedBox(height: 14),
          TextFormBox(
            controller: _projectPathController,
            header: "项目路径",
            onSaved: (v) => project.path = v ?? "",
            validator: (v) {
              if (null == v || v.isEmpty) return "项目路径不能为空";
              return null;
            },
            suffix: Button(
              child: const Text("选择"),
              onPressed: () {
                FilePicker.platform
                    .getDirectoryPath(
                        dialogTitle: "选择项目路径",
                        lockParentWindow: true,
                        initialDirectory: _projectPathController.text)
                    .then((v) {
                  if (null != v) _projectPathController.text = v;
                });
              },
            ),
          ),
          const SizedBox(height: 14),
          InfoLabel(
            label: "运行时环境",
            child: FormField<Environment>(
              builder: (f) => FormRow(
                padding: EdgeInsets.zero,
                error: (f.errorText == null) ? null : Text(f.errorText!),
                child: Row(
                  children: [
                    Expanded(
                      child: Combobox<Environment>(
                        isExpanded: true,
                        value: f.value,
                        onChanged: f.didChange,
                        items: dbManage
                            .loadAllEnvironments()
                            .map<ComboboxItem<Environment>>((e) {
                          return ComboboxItem(
                            value: e,
                            child: Text(e.flutterVersion),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 14),
                    IconButton(
                      icon: const Icon(FluentIcons.add),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              validator: (v) {
                if (null == v) return "运行时环境不能为空";
                return null;
              },
              onSaved: (v) => project.environmentKey = v?.primaryKey ?? "",
            ),
          ),
        ],
      ),
    );
  }

  // 构建步骤二，项目信息查看
  Widget buildProjectInfo() {
    return Text("步骤二");
  }

  // 导入所选项目
  void submit() {
    Navigator.pop(context);
  }
}
