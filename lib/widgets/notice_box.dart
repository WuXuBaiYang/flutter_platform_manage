import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_svg/flutter_svg.dart';

/*
* 消息盒子提示
* @author wuxubaiyang
* @Time 2022-07-21 16:35:28
*/
class NoticeBox extends StatelessWidget {
  // 基本颜色
  final Color color;

  // 提示图标assets路径
  final String svgAssetsPath;

  // 提示语
  final String message;

  // 空盒子提示大小
  final NoticeBoxSize boxSize;

  const NoticeBox({
    Key? key,
    required this.color,
    required this.message,
    required this.svgAssetsPath,
    this.boxSize = NoticeBoxSize.middle,
  }) : super(key: key);

  // 构建空盒子提示
  NoticeBox.empty({
    Key? key,
    required this.message,
    this.boxSize = NoticeBoxSize.middle,
  })  : color = const Color(0xFF221D08).withOpacity(0.3),
        svgAssetsPath = Common.emptyBoxImage,
        super(key: key);

  // 异常盒子提示
  NoticeBox.warning({
    Key? key,
    required this.message,
    this.boxSize = NoticeBoxSize.middle,
  })  : color = const Color(0xffe81123).withOpacity(0.3),
        svgAssetsPath = Common.warningBoxImage,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildBoxImage(),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // 构建盒子提示图片
  Widget buildBoxImage() {
    var size = boxSize.size;
    return SvgPicture.asset(svgAssetsPath,
        color: color, width: size, height: size);
  }
}

/*
* 提示盒子尺寸枚举
* @author wuxubaiyang
* @Time 2022-07-21 16:36:45
*/
enum NoticeBoxSize { small, middle, large }

/*
* 扩展提示盒子尺寸枚举
* @author wuxubaiyang
* @Time 2022-07-21 16:42:57
*/
extension WarningBoxSizeExtension on NoticeBoxSize {
  // 根据枚举获取具体尺寸
  double get size => const {
        NoticeBoxSize.small: 45.0,
        NoticeBoxSize.large: 85.0,
        NoticeBoxSize.middle: 65.0,
      }[this]!;
}
