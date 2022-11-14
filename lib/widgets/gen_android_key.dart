import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/widgets/logic_state.dart';

/*
* android签名文件生成
* @author wuxubaiyang
* @Time 2022/11/14 15:51
*/
class GenAndroidKeyDialog extends StatefulWidget {
  const GenAndroidKeyDialog({super.key});

  // 显示android签名文件生成弹窗
  static Future<String?> show(
    BuildContext context,
  ) {
    return showDialog<String>(
      context: context,
      builder: (_) => const GenAndroidKeyDialog(),
    );
  }

  @override
  State<StatefulWidget> createState() => _GenAndroidKeyDialogState();
}

/*
* android签名文件生成-状态
* @author wuxubaiyang
* @Time 2022/11/14 15:51
*/
class _GenAndroidKeyDialogState
    extends LogicState<GenAndroidKeyDialog, _GenAndroidKeyDialogLogic> {
  @override
  _GenAndroidKeyDialogLogic initLogic() => _GenAndroidKeyDialogLogic();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('生成Android签名文件'),
      content: SizedBox(),
      actions: _getActions(context),
    );
  }

  // 动态加载操作按钮集合
  List<Widget> _getActions(BuildContext context) => [
        Button(
          child: const Text('取消'),
          onPressed: () => Navigator.maybePop(context),
        ),
        FilledButton(
          onPressed: () => logic.genAndroidKey().then(
                (v) => Navigator.maybePop(context, v),
              ),
          child: const Text(
            '生成签名',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ];
}

/*
* android签名文件生成-逻辑
* @author wuxubaiyang
* @Time 2022/11/14 15:51
*/
class _GenAndroidKeyDialogLogic extends BaseLogic {
  // 生成android签名
  Future<String?> genAndroidKey() async {
    ///
    return null;
  }
}
