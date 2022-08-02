import 'package:fluent_ui/fluent_ui.dart';

// 确认按钮点击事件
typedef ConfirmCallback<T> = T? Function();

/*
* 重要操作警告弹窗
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class ImportantOptionDialog<T> extends StatefulWidget {
  // 标题
  final String? title;

  // 图标
  final IconData? icon;

  // 提示内容
  final String message;

  // 确认按钮
  final String? confirm;

  // 中间按钮
  final Widget? middle;

  // 确认按钮点击事件
  final ConfirmCallback<T?> onConfirmTap;

  const ImportantOptionDialog({
    Key? key,
    required this.message,
    required this.onConfirmTap,
    this.icon,
    this.title,
    this.middle,
    this.confirm,
  }) : super(key: key);

  // 显示项目导入弹窗
  static Future<T?> show<T>(
    BuildContext context, {
    required String message,
    required ConfirmCallback<T> onConfirmTap,
    IconData? icon,
    String? title,
    String? confirm,
    Widget? middle,
  }) {
    return showDialog<T>(
      context: context,
      builder: (_) => ImportantOptionDialog<T>(
        message: message,
        onConfirmTap: onConfirmTap,
        icon: icon,
        title: title,
        confirm: confirm,
        middle: middle,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _ImportantOptionDialogState<T>();
}

/*
* 重要操作警告弹窗-状态
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class _ImportantOptionDialogState<T> extends State<ImportantOptionDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Row(
        children: [
          Icon(widget.icon ?? FluentIcons.warning, color: Colors.red),
          const SizedBox(width: 8),
          Text(widget.title ?? "操作警告", style: TextStyle(color: Colors.red)),
        ],
      ),
      content: Text(widget.message),
      actions: actions,
    );
  }

  // 动态加载操作按钮集合
  List<Widget> get actions {
    var actions = <Widget>[
      Button(
        child: const Text("取消"),
        onPressed: () => Navigator.maybePop(context),
      ),
      FilledButton(
        style: ButtonStyle(
          backgroundColor: ButtonState.all(Colors.red),
        ),
        child: Text(widget.confirm ?? "确认"),
        onPressed: () {
          var result = widget.onConfirmTap();
          Navigator.pop<T>(context, result);
        },
      ),
    ];
    if (null != widget.middle) {
      actions.insert(1, widget.middle!);
    }
    return actions;
  }
}
