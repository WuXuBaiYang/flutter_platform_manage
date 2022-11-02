import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/model/db/environment.dart';
import 'package:flutter_platform_manage/utils/script_handle.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/logic_state.dart';
import 'value_listenable_builder.dart';

/*
* 环境导入弹窗
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class EnvImportDialog extends StatefulWidget {
  const EnvImportDialog({Key? key}) : super(key: key);

  // 显示项目导入弹窗
  static Future<Environment?> show(BuildContext context) {
    return showDialog<Environment>(
      context: context,
      builder: (_) => const EnvImportDialog(),
    );
  }

  @override
  State<StatefulWidget> createState() => _EnvImportDialogState();
}

/*
* 环境导入弹窗-状态
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class _EnvImportDialogState
    extends LogicState<EnvImportDialog, _EnvImportDialogLogic> {
  @override
  _EnvImportDialogLogic initLogic() => _EnvImportDialogLogic();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder2<Environment?, String?>(
      first: logic.envController,
      second: logic.errTextController,
      builder: (_, env, errText, __) {
        return ContentDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              FormRow(
                padding: EdgeInsets.zero,
                error: null != errText ? Text(errText) : null,
                child: TextBox(
                  controller: logic.envPathController,
                  header: 'flutter路径',
                  placeholder: '选择flutter根目录',
                  readOnly: true,
                  minLines: 1,
                  maxLines: 5,
                  suffix: Button(
                    onPressed: logic.doPathPicker,
                    child: const Text('选择'),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              null != env
                  ? Text('Flutter ${env.flutter} · ${env.channel}'
                      '\nDart ${env.dart}')
                  : (null == errText
                      ? const Center(child: ProgressRing())
                      : const SizedBox()),
            ],
          ),
          actions: [
            Button(
              child: const Text('取消'),
              onPressed: () => Navigator.maybePop(context),
            ),
            FilledButton(
              onPressed: logic.onImportEnv(context, env),
              child: const Text('导入'),
            ),
          ],
        );
      },
    );
  }
}

/*
* 环境导入弹窗-逻辑
* @author wuxubaiyang
* @Time 2022/11/1 9:31
*/
class _EnvImportDialogLogic extends BaseLogic {
  // 项目路径选择控制器
  final envPathController = TextEditingController();

  // 环境信息对象
  final envController = ValueChangeNotifier<Environment?>(null);

  // 异常提示
  final errTextController = ValueChangeNotifier<String?>('');

  // 导入环境配置
  VoidCallback? onImportEnv(BuildContext context, Environment? env) {
    if (env == null) return null;
    return () {
      try {
        dbManage.addEnvironment(env);
        Navigator.maybePop(context, env);
      } catch (e) {
        errTextController.setValue('环境添加失败');
      }
    };
  }

  // 路径选择
  Future<void> doPathPicker() async {
    try {
      final path = await Utils.pickPath(
        dialogTitle: '选择flutter路径',
        lockParentWindow: true,
        initialDirectory: envPathController.text,
      );
      if (null == path || path.isEmpty) return;
      envPathController.text = '';
      errTextController.setValue(null);
      envController.setValue(null);
      if (dbManage.hasEnvironment(path)) {
        errTextController.setValue('已存在相同环境');
        return;
      }
      envPathController.text = path;
      final env = await ScriptHandle.loadFlutterEnv(path);
      errTextController.setValue(null);
      envController.setValue(env);
    } catch (e) {
      envPathController.text = '';
      errTextController.setValue('环境信息读取失败');
      envController.setValue(null);
    }
  }
}
