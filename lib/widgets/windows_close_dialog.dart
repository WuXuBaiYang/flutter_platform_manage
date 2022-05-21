import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

/*
* 窗口关闭弹窗
* @author wuxubaiyang
* @Time 5/21/2022 12:47 PM
*/
class WindowsCloseDialog extends StatefulWidget {
  const WindowsCloseDialog({Key? key}) : super(key: key);

  // 展示弹窗
  static Future show(BuildContext context) async {
    if (await windowManager.isPreventClose()) {
      return showDialog(
        context: context,
        builder: (_) => const WindowsCloseDialog(),
      );
    }
  }

  @override
  State<StatefulWidget> createState() => _WindowsCloseDialogState();
}

/*
* 窗口关闭弹窗-状态
* @author wuxubaiyang
* @Time 5/21/2022 12:48 PM
*/
class _WindowsCloseDialogState extends State<WindowsCloseDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text("关闭提醒"),
      content: const Text("确定要关闭应用吗？"),
      actions: [
        Button(
          child: const Text("取消"),
          onPressed: () => Navigator.pop(context),
        ),
        FilledButton(
          child: const Text("关闭"),
          onPressed: () {
            Navigator.pop(context);
            windowManager.destroy();
          },
        ),
      ],
    );
  }
}
