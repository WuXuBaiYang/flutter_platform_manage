import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/logic_state.dart';
import 'package:flutter_platform_manage/widgets/thickness_divider.dart';

/*
* android平台构建引导
* @author wuxubaiyang
* @Time 2022/11/16 11:30
*/
class AndroidBuildGuideDialog extends StatefulWidget {
  const AndroidBuildGuideDialog({super.key});

  // 展示android构建引导弹窗
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const AndroidBuildGuideDialog(),
    );
  }

  @override
  State<StatefulWidget> createState() => _AndroidBuildGuideDialogState();
}

/*
* android平台构建引导-状态
* @author wuxubaiyang
* @Time 2022/11/16 11:30
*/
class _AndroidBuildGuideDialogState
    extends LogicState<AndroidBuildGuideDialog, _AndroidBuildGuideDialogLogic> {
  @override
  _AndroidBuildGuideDialogLogic initLogic() => _AndroidBuildGuideDialogLogic();

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 24);
    return ContentDialog(
      title: const Text('Android平台打包引导'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('#0', style: textStyle),
            ..._buildStep0(context),
            const ThicknessDivider(
              horizontalMargin: EdgeInsets.all(8),
            ),
            const Text('#1', style: textStyle),
            ..._buildStep1(context),
            const ThicknessDivider(
              horizontalMargin: EdgeInsets.all(8),
            ),
            const Text('#2', style: textStyle),
            ..._buildStep2(context),
            const ThicknessDivider(
              horizontalMargin: EdgeInsets.all(8),
            ),
          ],
        ),
      ),
    );
  }

  // 构建步骤0
  List<Widget> _buildStep0(BuildContext context) {
    return const [
      Text('\t\t\t\t首次进行Android平台打包，请参考本引导进行配置,'
          '本引导将协助使用者对打包的必要操作进行设置并提供完整的操作流程'),
    ];
  }

  // 构建步骤1
  List<Widget> _buildStep1(BuildContext context) {
    return [
      const Text('\t\t\t\t填写下方参数'),
      const SizedBox(height: 8),
    ];
  }

  // 构建步骤2
  List<Widget> _buildStep2(BuildContext context) {
    return [];
  }
}

/*
* android平台构建引导-逻辑
* @author wuxubaiyang
* @Time 2022/11/16 11:30
*/
class _AndroidBuildGuideDialogLogic extends BaseLogic {}
