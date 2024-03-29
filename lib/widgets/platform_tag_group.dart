import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_svg/flutter_svg.dart';

/*
* 平台支持标签组
* @author wuxubaiyang
* @Time 2022-07-21 11:00:25
*/
class PlatformTagGroup extends StatelessWidget {
  // 平台列表
  final List<BasePlatform> platforms;

  // 标签尺寸
  final PlatformTagSize tagSize;

  const PlatformTagGroup({
    Key? key,
    required this.platforms,
    this.tagSize = PlatformTagSize.middle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: tagSize.gapSize,
      runSpacing: tagSize.gapSize,
      children: platforms.map<Widget>((e) {
        return _buildTagItem(e);
      }).toList(),
    );
  }

  // 构建标签子项
  Widget _buildTagItem(BasePlatform platform) {
    final type = platform.type;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            type.platformImage,
            color: Colors.white,
            width: tagSize.size,
            height: tagSize.size,
          ),
          const SizedBox(width: 4),
          Text(
            type.name,
            style: TextStyle(
              fontSize: tagSize.size,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/*
* 平台类型标签大小
* @author wuxubaiyang
* @Time 2022-07-21 17:58:51
*/
enum PlatformTagSize { small, middle }

/*
* 平台类型标签大小扩展
* @author wuxubaiyang
* @Time 2022-07-21 18:00:02
*/
extension PlatformTagSizeExtension on PlatformTagSize {
  // 获取实际尺寸
  double get size => const {
        PlatformTagSize.small: 10.0,
        PlatformTagSize.middle: 14.0,
      }[this]!;

  // 获取间隔尺寸
  double get gapSize => const {
        PlatformTagSize.small: 4.0,
        PlatformTagSize.middle: 8.0,
      }[this]!;
}
