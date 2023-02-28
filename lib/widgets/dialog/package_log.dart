import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/logic_state.dart';

/*
* 打包日志浏览
* @author wuxubaiyang
* @Time 2022/11/21 14:18
*/
class PackageLogDialog extends StatefulWidget {
  // 日志列表
  final List<String> logs;

  const PackageLogDialog({super.key, required this.logs});

  // 展示打包日志弹窗
  static Future<void> show(
    BuildContext context, {
    required List<String> logs,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => PackageLogDialog(logs: logs),
    );
  }

  @override
  State<StatefulWidget> createState() => _PackageLogDialogState();
}

/*
* 打包日志浏览-状态
* @author wuxubaiyang
* @Time 2022/11/21 14:18
*/
class _PackageLogDialogState
    extends LogicState<PackageLogDialog, _PackageLogDialogLogic> {
  @override
  _PackageLogDialogLogic initLogic() => _PackageLogDialogLogic();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      constraints: const BoxConstraints(
        maxWidth: 550,
      ),
      title: Text('日志浏览（${widget.logs.length}）'),
      content: SingleChildScrollView(
        child: Column(
          children: List.generate(widget.logs.length, (i) {
            final text = widget.logs[i];
            return Expander(
              header: Text(
                text,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              content: Text(text, maxLines: 99999),
            );
          }),
        ),
      ),
    );
  }
}

/*
* 打包日志浏览-逻辑
* @author wuxubaiyang
* @Time 2022/11/21 14:18
*/
class _PackageLogDialogLogic extends BaseLogic {}
