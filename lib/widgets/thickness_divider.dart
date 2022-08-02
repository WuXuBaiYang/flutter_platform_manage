import 'package:fluent_ui/fluent_ui.dart';

/*
* 超薄分割线
* @author JTech JH
* @Time 2022-08-01 16:44:46
*/
class ThicknessDivider extends StatelessWidget {
  // 分割线尺寸
  final double? size;

  // 分割线方向
  final Axis direction;

  // 垂直外间距
  final EdgeInsetsGeometry? verticalMargin;

  // 水平外间距
  final EdgeInsetsGeometry? horizontalMargin;

  const ThicknessDivider({
    Key? key,
    this.size,
    this.direction = Axis.horizontal,
    this.verticalMargin = const EdgeInsets.all(8),
    this.horizontalMargin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      size: size,
      direction: direction,
      style: DividerThemeData(
        thickness: 0.3,
        verticalMargin: verticalMargin,
        horizontalMargin: horizontalMargin,
      ),
    );
  }
}
