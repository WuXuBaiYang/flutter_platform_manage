import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../model/project.dart';

/*
* 平台支持标签组
* @author JTech JH
* @Time 2022-07-21 11:00:25
*/
class PlatformChipGroup extends StatelessWidget {
  // 平台列表
  final List<BasePlatform> platforms;

  // 标签尺寸
  final PlatformChipSize chipSize;

  const PlatformChipGroup({
    Key? key,
    required this.platforms,
    this.chipSize = PlatformChipSize.middle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: platforms.map<Widget>((e) {
        return Chip.selected(
          image: SvgPicture.asset(
            e.type.platformImage,
            color: Colors.white,
            width: chipSize.getSize(),
            height: chipSize.getSize(),
          ),
          text: Text(
            e.type.name,
            style: TextStyle(
              fontSize: chipSize.getSize(),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/*
* 平台类型标签大小
* @author JTech JH
* @Time 2022-07-21 17:58:51
*/
enum PlatformChipSize { small, middle }

/*
* 平台类型标签大小扩展
* @author JTech JH
* @Time 2022-07-21 18:00:02
*/
extension PlatformChipSizeExtension on PlatformChipSize {
  // 获取实际尺寸
  double getSize() {
    switch (this) {
      case PlatformChipSize.small:
        return 10;
      case PlatformChipSize.middle:
      default:
        return 14;
    }
  }
}
