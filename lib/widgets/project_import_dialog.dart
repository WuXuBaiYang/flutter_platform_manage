import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/manager/project.dart';
import 'package:flutter_platform_manage/model/db/environment.dart';
import 'package:flutter_platform_manage/model/db/project.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/env_import_dialog.dart';
import 'package:flutter_platform_manage/widgets/platform_tag_group.dart';
import 'value_listenable_builder.dart';

/*
* 项目导入弹窗
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class ProjectImportDialog extends StatefulWidget {
  // 编辑项目信息时回传对象
  final Project initialProject;

  const ProjectImportDialog({
    Key? key,
    required this.initialProject,
  }) : super(key: key);

  // 显示项目导入弹窗
  static Future<ProjectModel?> show(
    BuildContext context, {
    Project? initialProject,
  }) {
    initialProject ??= Project(Utils.genID(), '', '', '', 0);
    return showDialog<ProjectModel>(
      context: context,
      builder: (_) => ProjectImportDialog(
        initialProject: initialProject!,
      ),
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
  // 逻辑管理
  late final _logic = _ProjectImportDialogLogic(widget.initialProject);

  // 步骤视图集合
  late final Map<String, Widget Function()> _stepsMap = {
    '选择项目': () => _buildProjectSelect(),
    '确认信息': () => _buildProjectInfo(),
  };

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _logic.currentStepController,
      builder: (_, currentStep, __) {
        return ContentDialog(
          constraints: const BoxConstraints(
            maxWidth: 340,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_stepsMap.length * 2 - 1, (i) {
                    if (i.isOdd) return const Divider(size: 60);
                    i = i ~/ 2;
                    var it = _stepsMap.keys.elementAt(i);
                    return RadioButton(
                      checked: currentStep >= i,
                      content: Text(it),
                      onChanged: (v) {
                        if (i >= currentStep) return;
                        _logic.currentStepController.setValue(i);
                        _logic.projectInfoController.setValue(null);
                      },
                    );
                  }),
                ),
                const SizedBox(height: 14),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: IndexedStack(
                    index: currentStep,
                    children: _stepsMap.values.map((e) => e()).toList(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Button(
              onPressed: _logic.previewStep(),
              child: const Text('上一步'),
            ),
            Button(
              child: const Text('取消'),
              onPressed: () => Navigator.maybePop(context),
            ),
            FilledButton(
              onPressed: () => _logic.nextStep(context),
              child: Text(
                currentStep < _stepsMap.length - 1 ? '下一步' : '导入',
              ),
            ),
          ],
        );
      },
    );
  }

  // 构建步骤一，项目选择
  Widget _buildProjectSelect() {
    final project = _logic.project;
    return Form(
      key: _logic.projectSelectKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextFormBox(
            controller: TextEditingController(text: project.alias),
            header: '别名',
            placeholder: '默认取项目名',
            onSaved: (v) {
              dbManage.write((realm) {
                project.alias = v ?? '';
              });
            },
          ),
          const SizedBox(height: 14),
          _buildProjectSelectPath(project),
          const SizedBox(height: 14),
          _buildProjectSelectEnv(project),
        ],
      ),
    );
  }

  // 构建项目路径信息
  Widget _buildProjectSelectPath(Project project) {
    return TextFormBox(
      controller: _logic.projectPathController,
      header: '项目路径',
      placeholder: '粘贴或选择项目根目录',
      onSaved: (v) {
        dbManage.write((realm) {
          project.path = v ?? '';
        });
      },
      validator: (v) {
        if (null == v || v.isEmpty) return '项目路径不能为空';
        var path = '$v/${ProjectFilePath.pubspec}';
        if (!File(path).existsSync()) {
          return '项目不存在（缺少pubspec.yaml文件）';
        }
        if (!project.isManaged && projectManage.has(v)) {
          return '项目已存在';
        }
        return null;
      },
      suffix: Button(
        child: const Text('选择'),
        onPressed: () {
          Utils.pickPath(
                  dialogTitle: '选择项目路径',
                  lockParentWindow: true,
                  initialDirectory: _logic.projectPathController.text)
              .then((v) {
            if (null != v) _logic.projectPathController.text = v;
          });
        },
      ),
    );
  }

  // 构建项目环境信息
  Widget _buildProjectSelectEnv(Project project) {
    return InfoLabel(
      label: '运行时环境',
      child: FormField<Environment>(
        initialValue: dbManage.loadFirstEnvironment(
            environmentKey: project.environmentKey),
        builder: (f) {
          return FormRow(
            padding: EdgeInsets.zero,
            error: (f.errorText == null) ? null : Text(f.errorText!),
            child: Row(
              children: [
                Expanded(
                  child: ComboBox<Environment>(
                    isExpanded: true,
                    placeholder: const Text('请添加flutter环境'),
                    value: f.value,
                    onChanged: f.didChange,
                    items: dbManage
                        .loadAllEnvironments()
                        .map<ComboBoxItem<Environment>>((e) {
                      return ComboBoxItem(
                        value: e,
                        child: Text('Flutter ${e.flutter} · ${e.channel}'),
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
          if (null == v) return '运行时环境不能为空';
          return null;
        },
        onSaved: (v) {
          dbManage.write((realm) {
            project.environmentKey = v?.primaryKey ?? '';
          });
        },
      ),
    );
  }

  // 构建步骤二，项目信息查看
  Widget _buildProjectInfo() {
    return ValueListenableBuilder2<ProjectModel?, String?>(
      first: _logic.projectInfoController,
      second: _logic.errTextController,
      builder: (_, projectInfo, errText, __) {
        if (projectInfo == null) return const SizedBox.shrink();
        final env = projectInfo.environment;
        final project = projectInfo.project;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextBox(
              header: '项目名称',
              readOnly: true,
              controller: TextEditingController(
                text: projectInfo.showTitle,
              ),
            ),
            const SizedBox(height: 14),
            TextBox(
              header: '版本号',
              readOnly: true,
              controller: TextEditingController(
                text: projectInfo.version,
              ),
            ),
            const SizedBox(height: 14),
            TextBox(
              header: '环境',
              readOnly: true,
              controller: TextEditingController(
                text: 'Flutter ${env?.flutter} · ${env?.channel}',
              ),
            ),
            const SizedBox(height: 14),
            TextBox(
              header: '项目地址',
              readOnly: true,
              controller: TextEditingController(
                text: project.path,
              ),
            ),
            const SizedBox(height: 14),
            InfoLabel(
              label: '平台支持',
              child: PlatformTagGroup(
                platforms: projectInfo.platformList,
              ),
            ),
            null != errText
                ? Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Text(
                      errText,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }
}

/*
* 项目导入弹窗-逻辑
* @author wuxubaiyang
* @Time 2022/11/1 13:58
*/
class _ProjectImportDialogLogic extends BaseLogic {
  // 记录当前所在步骤
  final currentStepController = ValueChangeNotifier<int>(0);

  // 项目信息
  final Project project;

  // 项目包装信息
  final projectInfoController = ValueChangeNotifier<ProjectModel?>(null);

  // 项目路径选择控制器
  final TextEditingController projectPathController;

  // 项目选择表单的key
  final projectSelectKey = GlobalKey<FormState>();

  // 异常提示
  final errTextController = ValueChangeNotifier<String?>(null);

  _ProjectImportDialogLogic(this.project)
      : projectPathController = TextEditingController(text: project.path);

  // 上一步
  VoidCallback? previewStep() {
    final currentStep = currentStepController.value;
    if (currentStep <= 0) return null;
    return () {
      currentStepController.setValue(currentStep - 1);
      projectInfoController.setValue(null);
    };
  }

  // 下一步
  Future<void> nextStep(BuildContext context) async {
    final currentStep = currentStepController.value;
    if (currentStep == 0) return confirmProject(context);
    if (currentStep == 1) return importProject(context);
  }

  // 生成项目信息
  Future<void> confirmProject(BuildContext context) async {
    try {
      // 执行项目选择的表单提交
      final state = projectSelectKey.currentState;
      if (state == null || !state.validate()) return;
      state.save();
      final projectInfo = ProjectModel(project: project);
      await projectInfo.update(true);
      // 跳转到第二步
      projectInfoController.setValue(projectInfo);
      currentStepController.setValue(1);
    } catch (e) {
      errTextController.setValue('项目信息读取失败');
    }
  }

  // 导入所选项目
  Future<void> importProject(BuildContext context) async {
    try {
      projectManage.add(project);
      Navigator.maybePop(
        context,
        projectInfoController.value,
      );
    } catch (e) {
      errTextController.setValue('项目导入失败');
    }
  }
}
