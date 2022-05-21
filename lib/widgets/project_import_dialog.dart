import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/project.dart';

/*
* 项目导入弹窗
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class ProjectImportDialog extends StatefulWidget {
  const ProjectImportDialog({Key? key}) : super(key: key);

  // 显示项目导入弹窗
  static Future<ProjectModel?> show(BuildContext context) {
    return showDialog<ProjectModel>(
      context: context,
      builder: (_) => const ProjectImportDialog(),
    );
  }

  @override
  State<StatefulWidget> createState() => _ProjectImportDialogState();
}

/*
* 项目导入弹窗-状态
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class _ProjectImportDialogState extends State<ProjectImportDialog> {
  // 记录当前所在步骤
  int _currentStep = 0;

  // 步骤视图集合
  final Map<String, Widget> _stepsMap = {};

  @override
  void initState() {
    super.initState();
    // 添加步骤内容组件
    _stepsMap.addAll({
      "选择项目": buildProjectSelect(),
      "确认信息": buildProjectInfo(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      constraints: const BoxConstraints(
        maxWidth: 500,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_stepsMap.length * 2 - 1, (i) {
              if (i.isOdd) return const Divider(size: 60);
              i = i ~/ 2;
              var it = _stepsMap.keys.elementAt(i);
              return RadioButton(
                checked: _currentStep >= i,
                content: Text(it),
                onChanged: (v) {
                  if (i >= _currentStep) return;
                  setState(() => _currentStep = i);
                },
              );
            }),
          ),
          const SizedBox(height: 14),
          IndexedStack(
            index: _currentStep,
            children: _stepsMap.values.toList(),
          ),
        ],
      ),
      actions: [
        Button(
          onPressed:
              _currentStep > 0 ? () => setState(() => _currentStep -= 1) : null,
          child: const Text("上一步"),
        ),
        Button(
          child: const Text("取消"),
          onPressed: () => Navigator.pop(context),
        ),
        FilledButton(
          child: Text(_currentStep < _stepsMap.length - 1 ? "下一步" : "导入"),
          onPressed: () {
            if (_currentStep >= _stepsMap.length - 1) return submit();
            setState(() => _currentStep += 1);
          },
        ),
      ],
    );
  }

  // 构建步骤一，项目选择
  Widget buildProjectSelect() {
    return Text("步骤一");
  }

  // 构建步骤二，项目信息查看
  Widget buildProjectInfo() {
    return Text("步骤二");
  }

  // 导入所选项目
  void submit() {
    Navigator.pop(context);
  }
}
