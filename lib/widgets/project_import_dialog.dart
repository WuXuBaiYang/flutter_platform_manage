import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/manager/project_manage.dart';
import 'package:flutter_platform_manage/model/db/environment.dart';
import 'package:flutter_platform_manage/model/db/project.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/info_handle.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/env_import_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  // 步骤视图集合
  late Map<String, Widget Function()> stepsMap = {
    "选择项目": () => buildProjectSelect(),
    "确认信息": () => buildProjectInfo(),
  };

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
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: IndexedStack(
              index: _currentStep,
              children: stepsMap.values.map((e) => e()).toList(),
            ),
          ),
        ],
      ),
      actions: [
        Button(
          onPressed: _currentStep > 0
              ? () => setState(() {
                    _projectInfo = null;
                    _currentStep -= 1;
                  })
              : null,
          child: const Text("上一步"),
        ),
        Button(
          child: const Text("取消"),
          onPressed: () => Navigator.pop(context),
        ),
        FilledButton(
          child: Text(_currentStep < stepsMap.length - 1 ? "下一步" : "导入"),
          onPressed: () async {
            switch (_currentStep) {
              case 0: // 项目选择
                // 执行项目选择的表单提交
                if (!(_projectSelectKey.currentState?.validate() ?? true)) {
                  return;
                }
                _projectSelectKey.currentState?.save();
                _projectInfo = ProjectModel(project: project);
                await _projectInfo?.updateSimple();
                // 增加步长
                setState(() => _currentStep += 1);
                break;
              case 1: // 信息确认
                submit();
                break;
            }
          },
        ),
      ],
    );
  }

  // 项目路径选择控制器
  final _projectPathController = TextEditingController();

  // 项目选择表单的key
  final _projectSelectKey = GlobalKey<FormState>();

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
              if (projectManage.has(v)) return "项目已存在";
              if (!InfoHandle.projectExistSync(v)) {
                return "项目不存在（缺少pubspec.yaml文件）";
              }
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
              initialValue: dbManage.loadFirstEnvironment(),
              builder: (f) {
                return FormRow(
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
                              child:
                                  Text("Flutter ${e.flutter} · ${e.channel}"),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(width: 14),
                      IconButton(
                        icon: const Icon(FluentIcons.add),
                        onPressed: () {
                          EnvImportDialog.show(context).then((v) {
                            if (null != v) {
                              f.didChange(v);
                            }
                          });
                        },
                      )
                    ],
                  ),
                );
              },
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

  // 项目信息对象
  ProjectModel? _projectInfo;

  // 构建步骤二，项目信息查看
  Widget buildProjectInfo() {
    if (null == _projectInfo) {
      _errText = null;
      return const SizedBox.shrink();
    }
    var name = project.alias;
    name = name.isEmpty
        ? _projectInfo?.name ?? ""
        : "$name(${_projectInfo?.name})";
    var env = _projectInfo?.getEnvironment();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextBox(
          header: "项目名称",
          readOnly: true,
          controller: TextEditingController(text: name),
        ),
        const SizedBox(height: 14),
        TextBox(
          header: "版本号",
          readOnly: true,
          controller: TextEditingController(
            text: _projectInfo?.version,
          ),
        ),
        const SizedBox(height: 14),
        TextBox(
          header: "环境",
          readOnly: true,
          controller: TextEditingController(
            text: "Flutter ${env?.flutter} · ${env?.channel}",
          ),
        ),
        const SizedBox(height: 14),
        TextBox(
          header: "项目地址",
          readOnly: true,
          controller: TextEditingController(
            text: project.path,
          ),
        ),
        const SizedBox(height: 14),
        InfoLabel(
          label: "平台支持",
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _projectInfo?.platforms.map<Widget>((e) {
                  return Chip.selected(
                    image: SvgPicture.asset(
                      e.type.platformImage,
                      color: Colors.white,
                      width: 20,
                      height: 20,
                    ),
                    text: Text(e.type.name),
                  );
                }).toList() ??
                [],
          ),
        ),
        null != _errText
            ? Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Text(
                  _errText!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  // 异常提示
  String? _errText;

  // 导入所选项目
  void submit() {
    try {
      projectManage.add(project);
      Navigator.pop(context, _projectInfo);
    } catch (e) {
      setState(() => _errText = "项目导入失败");
    }
  }
}
