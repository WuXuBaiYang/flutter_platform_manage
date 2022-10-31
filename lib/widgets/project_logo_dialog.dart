import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';

/*
* 项目图标弹窗
* @author wuxubaiyang
* @Time 2022/10/31 11:05
*/
class ProjectLogoDialog extends StatefulWidget {
  // 项目图标与平台表
  final Map<String, List<ProjectIcon>> iconsMap;

  // 所选图标最小尺寸
  final Size minFileSize;

  const ProjectLogoDialog({
    super.key,
    required this.iconsMap,
    required this.minFileSize,
  });

  // 显示项目图标展示弹窗
  static Future<bool?> show(
    BuildContext context, {
    required Map<String, List<ProjectIcon>> iconsMap,
    required Size minFileSize,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => ProjectLogoDialog(
        iconsMap: iconsMap,
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
class _ProjectLogoDialogState extends State<ProjectLogoDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      content: Text('aaaaaaaaaaaaaaaaaa'),
    );
  }
}
