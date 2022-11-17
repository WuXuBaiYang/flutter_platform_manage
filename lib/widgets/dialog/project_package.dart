import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/logic_state.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/manager/package_task.dart';
import 'package:flutter_platform_manage/manager/theme.dart';
import 'package:flutter_platform_manage/model/db/package.dart';
import 'package:flutter_platform_manage/model/package.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/combobox_select.dart';
import 'package:flutter_platform_manage/widgets/custom_animated_size.dart';
import 'package:flutter_platform_manage/widgets/dialog/android_build_guide.dart';
import 'package:flutter_platform_manage/widgets/value_listenable_builder.dart';

/*
* 项目打包弹窗
* @author wuxubaiyang
* @Time 2022/11/16 9:47
*/
class ProjectPackageDialog extends StatefulWidget {
  // 项目信息
  final ProjectModel? initialProjectInfo;

  // 平台信息
  final PlatformType? initialPlatform;

  const ProjectPackageDialog({
    super.key,
    this.initialProjectInfo,
    this.initialPlatform,
  });

  // 展示项目打包弹窗
  static Future<PackageModel?> show(
    BuildContext context, {
    ProjectModel? initialProjectInfo,
    PlatformType? initialPlatform,
  }) {
    return showDialog<PackageModel>(
      context: context,
      builder: (_) => ProjectPackageDialog(
        initialProjectInfo: initialProjectInfo,
        initialPlatform: initialPlatform,
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
  _ProjectPackageDialogLogic initLogic() => _ProjectPackageDialogLogic(
      widget.initialProjectInfo, widget.initialPlatform);

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('项目打包'),
      content: _buildFormContent(),
      actions: [
        Button(
          child: const Text('取消'),
          onPressed: () => Navigator.maybePop(context),
        ),
        FilledButton(
          onPressed: () => logic.doPackageTask().then((v) {
            if (v == null) return Utils.showSnack(context, '添加到打包失败');
            Utils.showSnack(context, '已添加到打包队列');
            Navigator.maybePop(context, v);
          }),
          child: const Text('执行打包'),
        ),
      ],
    );
  }

  // 构建表单内容
  Widget _buildFormContent() {
    return CustomAnimatedSize(
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Form(
          key: logic.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ValueListenableBuilder2<ProjectModel?, PlatformType?>(
            first: logic.projectInfoController,
            second: logic.platformController,
            builder: (_, project, platform, __) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildProjectSelect(project),
                  if (project != null) ...[
                    const SizedBox(height: 24),
                    _buildPlatformSelect(project, platform)
                  ],
                  if (project != null && platform != null) ...[
                    const SizedBox(height: 24),
                    ..._buildPackageInfo(project, platform),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // 构建项目选择
  Widget _buildProjectSelect(ProjectModel? project) {
    return InfoLabel(
      label: '选择项目',
      child: ProjectSelectComboBox<ProjectModel>(
        getValue: (e) => e,
        isExpanded: true,
        value: project,
        simple: false,
        onChanged: logic.projectInfoController.setValue,
      ),
    );
  }

  // 当前运营平台支持打包表
  final _platformSupportMap = <String, List<PlatformType>>{
    'linux': [
      PlatformType.android,
      // PlatformType.linux,
      PlatformType.web,
    ],
    'macos': [
      PlatformType.android,
      // PlatformType.macos,
      // PlatformType.ios,
      PlatformType.web,
    ],
    'windows': [
      PlatformType.android,
      PlatformType.windows,
      PlatformType.web,
    ],
  };

  // 构建平台选择
  Widget _buildPlatformSelect(ProjectModel project, PlatformType? platform) {
    final platformSupports =
        _platformSupportMap[Platform.operatingSystem] ?? [];
    return InfoLabel(
      label: '选择平台',
      child: PlatformSelectComboBox(
        value: platform,
        isExpanded: true,
        platforms: project.platformMap.keys
            .where((e) => platformSupports.contains(e))
            .toList(),
        onChanged: logic.platformController.setValue,
      ),
    );
  }

  // 构建打包信息
  List<Widget> _buildPackageInfo(
    ProjectModel project,
    PlatformType platform,
  ) {
    final displayName = project.platformMap[platform]?.displayName;
    logic.displayNameController.text = displayName ?? '';
    return [
      _buildVersionUpdate(project),
      if (displayName != null) ...[
        const SizedBox(height: 24),
        _buildProjectName(project),
      ],
      if (platform == PlatformType.android) ...[
        const SizedBox(height: 14),
        RichText(
          text: TextSpan(
            text: '如果是首次打包android平台，请参考该',
            style: TextStyle(
              color: Colors.grey[90],
              fontSize: 12,
            ),
            children: [
              TextSpan(
                text: ' 《Android构建引导》 ',
                style: TextStyle(
                  color: themeManage.currentTheme.accentColor,
                  fontSize: 12,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => AndroidBuildGuideDialog.show(context),
              ),
              const TextSpan(text: '进行初始化配置'),
            ],
          ),
        ),
        // Text('引导进行配置')
      ],
    ];
  }

  // 输入框输入规则
  final _versionRegExp = RegExp(r'[0-9.+]');

  // 构建项目版本号更新
  Widget _buildVersionUpdate(ProjectModel project) {
    logic.versionController.text = project.version;
    return InfoLabel(
      label: '版本号 "${_versionRegExp.pattern}"',
      child: TextFormBox(
        controller: logic.versionController,
        autofocus: true,
        autovalidateMode: AutovalidateMode.always,
        suffix: Row(
          children: [
            Tooltip(
              message: '自增版本号',
              child: IconButton(
                icon: const Icon(FluentIcons.add_multiple),
                onPressed: () {
                  final v = logic.versionController.text;
                  logic.versionController.text =
                      Utils.autoIncrement(context, v);
                },
              ),
            ),
            Tooltip(
              message: '重置版本号',
              child: IconButton(
                icon: const Icon(FluentIcons.reset),
                onPressed: () => logic.versionController.text = project.version,
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
          if (null != v && project.version != v) {
            logic.versionController.text = v;
          }
        },
        inputFormatters: [
          FilteringTextInputFormatter.allow(_versionRegExp),
        ],
      ),
    );
  }

  // 构建项目名称
  Widget _buildProjectName(ProjectModel project) {
    return InfoLabel(
      label: '项目展示名',
      child: StatefulBuilder(
        builder: (_, state) {
          return TextFormBox(
            autofocus: true,
            controller: logic.displayNameController,
            suffix: Visibility(
              visible: logic.displayNameController.text.isNotEmpty,
              child: IconButton(
                icon: const Icon(FluentIcons.cancel),
                onPressed: () =>
                    state(() => logic.displayNameController.clear()),
              ),
            ),
            onChanged: (v) => state(() {}),
            validator: (v) {
              if (null == v || v.isEmpty) return '不能为空';
              return null;
            },
            onSaved: (v) {
              if (v == null || project.name == v) return;
              logic.displayNameController.text = v;
            },
          );
        },
      ),
    );
  }
}

/*
* 项目打包弹窗-逻辑
* @author wuxubaiyang
* @Time 2022/11/16 9:47
*/
class _ProjectPackageDialogLogic extends BaseLogic {
  // 项目信息
  final ValueChangeNotifier<ProjectModel?> projectInfoController;

  // 平台信息
  final ValueChangeNotifier<PlatformType?> platformController;

  // 版本号管理
  final versionController = TextEditingController();

  // 展示名管理
  final displayNameController = TextEditingController();

  // 表单key
  final formKey = GlobalKey<FormState>();

  _ProjectPackageDialogLogic(ProjectModel? projectInfo, PlatformType? platform)
      : projectInfoController = ValueChangeNotifier(projectInfo),
        platformController = ValueChangeNotifier(platform) {
    // 项目重新选择的时候则清除平台信息
    projectInfoController.addListener(() {
      platformController.setValue(null);
    });
  }

  // 打包脚本对照表
  final _packageScriptMap = {
    PlatformType.android: 'flutter build apk',
    PlatformType.ios: '',
    PlatformType.web: 'flutter build web',
    PlatformType.macos: '',
    PlatformType.windows: 'flutter build windows',
    PlatformType.linux: '',
  };

  // 指定打包操作
  Future<PackageModel?> doPackageTask() async {
    final state = formKey.currentState;
    if (state != null && state.validate()) {
      state.save();
      final project = projectInfoController.value;
      final platform = platformController.value;
      if (project == null || platform == null) return null;
      // 获取并修改版本号
      if (!await project.modifyProjectVersion(
        versionController.value.text,
        autoCommit: true,
      )) return null;
      // 获取并修改展示名
      final p = project.platformMap[platform];
      if (p == null) return null;
      if (!await p.modifyDisplayName(
        displayNameController.value.text,
      )) return null;
      // 构造打包信息并添加到队列
      final packageInfo = PackageModel(
        package: Package()
          ..projectId = project.project.id
          ..platform = platform
          ..status = PackageStatus.prepare
          ..script = _packageScriptMap[platform]!,
        projectInfo: project,
      );
      if (!await packageTaskManage.addTask(
        packageInfo.package,
      )) return null;
      return packageInfo;
    }
    return null;
  }
}
