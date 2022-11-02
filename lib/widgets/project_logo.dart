import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';

/*
* 项目图标组件
* @author wuxubaiyang
* @Time 2022-07-22 17:14:34
*/
class ProjectLogo extends StatelessWidget {
  // 项目图标
  final ProjectIcon? projectIcon;

  // 项目图标尺寸
  final Size size;

  ProjectLogo({
    super.key,
    required this.projectIcon,
    ProjectLogoSize logoSize = ProjectLogoSize.middle,
  }) : size = logoSize.size;

  // 自定义图标尺寸
  const ProjectLogo.custom({
    super.key,
    required this.projectIcon,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final filePath = projectIcon?.src;
    if (filePath != null) {
      return Image.file(
        File(filePath),
        width: size.width,
        height: size.height,
        fit: BoxFit.cover,
      );
    }
    return FlutterLogo(
      size: size.shortestSide,
    );
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
  Size get size => const {
        ProjectLogoSize.small: Size.square(35.0),
        ProjectLogoSize.large: Size.square(65.0),
        ProjectLogoSize.middle: Size.square(50.0),
      }[this]!;
}
