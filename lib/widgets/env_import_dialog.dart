import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/model/db/environment.dart';
import 'package:flutter_platform_manage/utils/script_handle.dart';

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
class _EnvImportDialogState extends State<EnvImportDialog> {
  // 项目路径选择控制器
  final _envPathController = TextEditingController();

  // 环境信息对象
  Environment? _env;

  // 异常提示
  String? _errText = "";

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          FormRow(
            padding: EdgeInsets.zero,
            error: null != _errText ? Text(_errText!) : null,
            child: TextBox(
              controller: _envPathController,
              header: "flutter路径",
              placeholder: "粘贴或导入flutter根目录",
              readOnly: true,
              suffix: Button(
                onPressed: doPathPicker,
                child: const Text("选择"),
              ),
            ),
          ),
          const SizedBox(height: 14),
          null != _env
              ? Text("Flutter ${_env?.flutter} · ${_env?.channel}"
                  "\nDart ${_env?.dart}")
              : (null == _errText
                  ? const Center(child: ProgressRing())
                  : const SizedBox()),
        ],
      ),
      actions: [
        Button(
          child: const Text("取消"),
          onPressed: () => Navigator.pop(context),
        ),
        FilledButton(
          onPressed: null != _env
              ? () {
                  try {
                    dbManage.addEnvironment(_env!);
                    Navigator.pop(context, _env);
                  } catch (e) {
                    setState(() => _errText = "环境添加失败");
                  }
                }
              : null,
          child: const Text("导入"),
        ),
      ],
    );
  }

  // 路径选择
  void doPathPicker() {
    FilePicker.platform
        .getDirectoryPath(
            dialogTitle: "选择flutter路径",
            lockParentWindow: true,
            initialDirectory: _envPathController.text)
        .then((v) {
      if (null == v || v.isEmpty) return Future.value(null);
      setState(() {
        _envPathController.text = "";
        _errText = null;
        _env = null;
      });
      if (dbManage.hasEnvironment(v)) {
        setState(() {
          _errText = "已存在相同环境";
        });
        return Future.value(null);
      }
      return ScriptHandle.loadFlutterEnv(v);
    }).then((v) {
      if (null != v) {
        setState(() {
          _envPathController.text = v.path;
          _errText = null;
          _env = v;
        });
      }
    }).catchError((e) {
      setState(() {
        _envPathController.text = "";
        _errText = "环境信息读取失败";
        _env = null;
      });
    });
  }
}
