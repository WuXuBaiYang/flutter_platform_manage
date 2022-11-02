import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/manager/theme.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/widgets/logic_state.dart';
import 'package:flutter_platform_manage/widgets/project_logo.dart';
import 'package:flutter_svg/flutter_svg.dart';

/*
* 项目图标弹窗
* @author wuxubaiyang
* @Time 2022/10/31 11:05
*/
class ProjectLogoDialog extends StatefulWidget {
  // 项目图标与平台表
  final Map<PlatformType, List<ProjectIcon>> initialIconsMap;

  // 所选图标最小尺寸
  final Size minFileSize;

  const ProjectLogoDialog({
    super.key,
    required this.initialIconsMap,
    required this.minFileSize,
  });

  // 显示项目图标展示弹窗
  static Future<bool?> show(
    BuildContext context, {
    required Map<PlatformType, List<ProjectIcon>> initialIconsMap,
    required Size minFileSize,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => ProjectLogoDialog(
        initialIconsMap: initialIconsMap,
        minFileSize: minFileSize,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _ProjectLogoDialogState();
}

/*
* 项目图标弹窗-状态
* @author wuxubaiyang
* @Time 2022/10/31 11:05
*/
class _ProjectLogoDialogState
    extends LogicState<ProjectLogoDialog, _ProjectLogoDialogLogic> {
  @override
  _ProjectLogoDialogLogic initLogic() =>
      _ProjectLogoDialogLogic(widget.initialIconsMap);

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      constraints: const BoxConstraints(
        maxWidth: 600,
        maxHeight: 600,
      ),
      content: ValueListenableBuilder<int>(
        valueListenable: logic.indexController,
        builder: (_, index, __) {
          return TabView(
            currentIndex: index,
            showScrollButtons: false,
            tabWidthBehavior: TabWidthBehavior.sizeToContent,
            closeButtonVisibility: CloseButtonVisibilityMode.never,
            onChanged: (i) => logic.indexController.setValue(i),
            tabs: logic.iconsMap.keys.map<Tab>((e) {
              final icons = logic.iconsMap[e] ?? [];
              return Tab(
                text: Text(e.name),
                icon: SvgPicture.asset(
                  e.platformImage,
                  color: themeManage.currentTheme.inactiveColor,
                  width: 15,
                  height: 15,
                ),
                body: _buildPlatformLogos(icons),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  // 构建平台图标集合
  Widget _buildPlatformLogos(List<ProjectIcon> icons) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: icons.map<Widget>((e) {
          return _buildPlatformLogosItem(e);
        }).toList(),
      ),
    );
  }

  // 构建平台图标集合子项
  Widget _buildPlatformLogosItem(ProjectIcon e) {
    var text = '${logic.handleSize(e.size)}\n${e.type}';
    if (e.desc.isNotEmpty) {
      text = '$text · ${e.desc}';
    }
    var size = e.size;
    if (size.longestSide > 100) {
      size = const Size.square(100);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProjectLogo.custom(
          projectIcon: e,
          size: size,
        ),
        const SizedBox(height: 4),
        Text(
          text,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/*
* 项目图标弹窗-逻辑
* @author wuxubaiyang
* @Time 2022/11/2 9:11
*/
class _ProjectLogoDialogLogic extends BaseLogic {
  // 项目图标与平台表
  final Map<PlatformType, List<ProjectIcon>> iconsMap;

  // 平台下标
  final indexController = ValueChangeNotifier<int>(0);

  _ProjectLogoDialogLogic(this.iconsMap);

  // 接收尺寸并格式化
  String handleSize(Size size) {
    var h = size.height, w = size.width;
    return '$h x $w'.replaceAll(r'.0', '');
  }
}
