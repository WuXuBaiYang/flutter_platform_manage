import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_svg/flutter_svg.dart';

/*
* 空盒子提示
* @author JTech JH
* @Time 2022-07-21 16:35:28
*/
class EmptyBoxNotice extends StatelessWidget {
  // 基本颜色
  final primaryColor = const Color(0xFF221D08).withOpacity(0.3);

  // 提示语
  final String message;

  // 空盒子提示大小
  final EmptyBoxSize boxSize;

  EmptyBoxNotice({
    Key? key,
    required this.message,
    this.boxSize = EmptyBoxSize.middle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildEmptyBoxImage(),
        const SizedBox(height: 8),
        Text(message, style: TextStyle(color: primaryColor)),
      ],
    );
  }

  // 构建空盒子图片
  Widget buildEmptyBoxImage() {
    var size = boxSize.getSize();
    return SvgPicture.asset(
      Common.EmptyBoxImage,
      color: primaryColor,
      width: size,
      height: size,
    );
  }
}

/*
* 图片大小枚举
* @author JTech JH
* @Time 2022-07-21 16:36:45
*/
enum EmptyBoxSize { small, middle, large }

/*
* 扩展图片大小枚举
* @author JTech JH
* @Time 2022-07-21 16:42:57
*/
extension EmptyBoxSizeExtension on EmptyBoxSize {
  // 根据枚举获取具体尺寸
  double getSize() {
    switch (this) {
      case EmptyBoxSize.small:
        return 45;
      case EmptyBoxSize.large:
        return 85;
      case EmptyBoxSize.middle:
      default:
        return 65;
    }
  }
}
