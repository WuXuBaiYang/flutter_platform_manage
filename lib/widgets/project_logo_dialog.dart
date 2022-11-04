import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/manager/event.dart';
import 'package:flutter_platform_manage/manager/theme.dart';
import 'package:flutter_platform_manage/model/event/project_logo.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/utils/log.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/logic_state.dart';
import 'package:flutter_platform_manage/widgets/project_logo.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image/image.dart' as handle;

/*
* 项目图标弹窗
* @author wuxubaiyang
* @Time 2022/10/31 11:05
*/
class ProjectLogoDialog extends StatefulWidget {
  // 项目平台集合
  final List<BasePlatform> initialPlatforms;

  // 所选图标最小尺寸
  final Size minFileSize;

  const ProjectLogoDialog({
    super.key,
    required this.initialPlatforms,
    required this.minFileSize,
  });

  // 显示项目图标展示弹窗
  static Future<bool?> show(
    BuildContext context, {
    required List<BasePlatform> initialPlatforms,
    required Size minFileSize,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => ProjectLogoDialog(
        initialPlatforms: initialPlatforms,
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
      _ProjectLogoDialogLogic(widget.initialPlatforms);

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      constraints: const BoxConstraints(
        maxWidth: 600,
        maxHeight: 600,
      ),
      content: Column(
        children: [
          _buildPlatformHeader(),
          const Divider(
            style: DividerThemeData(
              horizontalMargin: EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          Expanded(child: _buildPlatformTabs()),
        ],
      ),
      actions: [
        Button(
          child: const Text('关闭'),
          onPressed: () => Navigator.pop(context),
        ),
        ValueListenableBuilder(
          valueListenable: logic.selectIconFile,
          builder: (_, v, __) {
            return FilledButton(
              onPressed: v != null
                  ? () => Utils.showLoading(context,
                      loadFuture: logic.replaceLogos().then((v) {
                        if (!v) Utils.showSnack(context, '图标替换失败');
                      }))
                  : null,
              child: const Text('替换'),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: logic.selectIconFile,
          builder: (_, v, __) {
            return FilledButton(
              onPressed: v != null
                  ? () => Utils.showLoading(context,
                      loadFuture: logic.replaceLogos().then((v) {
                        if (!v) Utils.showSnack(context, '图标替换失败');
                        Navigator.pop(context);
                      }))
                  : null,
              child: const Text('替换并返回'),
            );
          },
        ),
      ],
    );
  }

  // 构建图标管理头部
  Widget _buildPlatformHeader() {
    return ValueListenableBuilder<File?>(
      valueListenable: logic.selectIconFile,
      builder: (_, selectFile, __) {
        return ListTile(
          leading: selectFile != null
              ? Image.file(
                  selectFile,
                  fit: BoxFit.cover,
                  width: 45,
                  height: 45,
                )
              : Icon(
                  FluentIcons.image_search,
                  size: 45,
                  color: Colors.grey[90],
                ),
          trailing: const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Icon(FluentIcons.settings),
          ),
          title: Text('选择图标文件（${logic.handleSize(widget.minFileSize)}）'),
          subtitle: Text(selectFile?.path ?? '未选择'),
          onPressed: () {
            Utils.pickProjectLogo(minSize: widget.minFileSize).then((result) {
              if (result != null) {
                logic.selectIconFile.setValue(result);
              }
            });
          },
        );
      },
    );
  }

  // 构建图标分页
  Widget _buildPlatformTabs() {
    return ValueListenableBuilder<int>(
      valueListenable: logic.indexController,
      builder: (_, index, __) {
        return TabView(
          currentIndex: index,
          showScrollButtons: false,
          tabWidthBehavior: TabWidthBehavior.sizeToContent,
          closeButtonVisibility: CloseButtonVisibilityMode.never,
          onChanged: (i) => logic.indexController.setValue(i),
          tabs: logic.platforms.map<Tab>((e) {
            final icons = e.projectIcons;
            return Tab(
              text: Text(e.type.name),
              icon: SvgPicture.asset(
                e.type.platformImage,
                color: themeManage.currentTheme.inactiveColor,
                width: 15,
                height: 15,
              ),
              body: _buildPlatformLogos(icons),
            );
          }).toList(),
        );
      },
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
        }).toList(),
      ),
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
  final List<BasePlatform> platforms;

  // 平台下标
  final indexController = ValueChangeNotifier<int>(0);

  // 所选图标数据
  final selectIconFile = ValueChangeNotifier<File?>(null);

  _ProjectLogoDialogLogic(this.platforms);

  // 接收尺寸并格式化
  String handleSize(Size size) {
    var h = size.height, w = size.width;
    return '$h x $w'.replaceAll(r'.0', '');
  }

  // 替换当前所选平台图标
  Future<bool> replaceLogos() async {
    try {
      final source = selectIconFile.value;
      if (source == null) return false;
      final imageSource = handle.decodeImage(
        await source.readAsBytes(),
      );
      if (imageSource == null) return false;
      final temp = <String>[];
      for (var platform in platforms) {
        for (var icon in platform.projectIcons) {
          final targetPath = icon.src;
          if (!temp.contains(targetPath)) {
            temp.add(targetPath);
            final size = icon.size;
            final w = size.width.toInt(), h = size.height.toInt();
            var target = handle.copyResize(imageSource, width: w, height: h);
            final f = File(targetPath);
            if (!await f.exists()) {
              await f.create(recursive: true);
            }
            if (icon.fileType == 'png') {
              await f.writeAsBytes(handle.encodePng(target));
            } else if (icon.fileType == 'ico') {
              await f.writeAsBytes(handle.encodeIco(target));
            }
          }
        }
      }
    } catch (e) {
      LogTool.e('平台编辑图标失败：', error: e);
      return false;
    }
    eventManage.fire(ProjectLogoChangeEvent());
    return true;
  }
}
