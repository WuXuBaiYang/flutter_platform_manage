import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/project.dart';

/*
* 项目图标组件
* @author wuxubaiyang
* @Time 2022-07-22 17:14:34
*/
class ProjectLogo extends StatelessWidget {
  // 项目信息
  final ProjectModel projectInfo;

  // 项目图标尺寸
  final ProjectLogoSize logoSize;

  const ProjectLogo({
    Key? key,
    required this.projectInfo,
    this.logoSize = ProjectLogoSize.middle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var iconSize = logoSize.size;
    if (!projectInfo.exist) {
      return Icon(
        FluentIcons.warning,
        color: Colors.red,
        size: iconSize,
      );
    }
    final icon = projectInfo.projectIcon;
    if (icon != null) {
      return Image.file(
        File(icon.src),
        width: iconSize,
        height: iconSize,
      );
    }
    return FlutterLogo(size: iconSize);
  }
}

/*
* 图标尺寸
* @author wuxubaiyang
* @Time 2022-07-22 17:16:06
*/
enum ProjectLogoSize { small, middle, large }

/*
* 图标尺寸方法扩展
* @author wuxubaiyang
* @Time 2022-07-22 17:16:26
*/
extension ProjectlogoSizeExtension on ProjectLogoSize {
  // 获取图标尺寸
  double get size => const {
        ProjectLogoSize.small: 35.0,
        ProjectLogoSize.large: 65.0,
        ProjectLogoSize.middle: 50.0,
      }[this]!;
}
