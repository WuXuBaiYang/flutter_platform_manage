import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/logic_state.dart';

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
    return SizedBox();
  }
}

/*
* android平台构建引导-逻辑
* @author wuxubaiyang
* @Time 2022/11/16 11:30
*/
class _AndroidBuildGuideDialogLogic extends BaseLogic {}
