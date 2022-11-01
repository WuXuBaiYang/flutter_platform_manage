import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

/*
* 窗口操作按钮组
* @author wuxubaiyang
* @Time 5/18/2022 11:27 AM
*/
class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
