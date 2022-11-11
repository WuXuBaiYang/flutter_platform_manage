import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/widgets/logic_state.dart';

/*
* 日期区间选择弹窗
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class JDateRangPickerDialog extends StatefulWidget {
  // 初始化日期区间
  final JDateRangPicker? initialDate;

  const JDateRangPickerDialog({
    Key? key,
    this.initialDate,
  }) : super(key: key);

  // 显示项目导入弹窗
  static Future<JDateRangPicker?> show(
    BuildContext context, {
    JDateRangPicker? initialDate,
  }) {
    return showDialog<JDateRangPicker>(
      context: context,
      builder: (_) => JDateRangPickerDialog(
        initialDate: initialDate,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _DateRangPickerDialogState();
}

/*
* 日期区间选择弹窗-状态
* @author wuxubaiyang
* @Time 5/21/2022 12:32 PM
*/
class _DateRangPickerDialogState
    extends LogicState<JDateRangPickerDialog, _DateRangPickerDialogLogic> {
  @override
  _DateRangPickerDialogLogic initLogic() =>
      _DateRangPickerDialogLogic(widget.initialDate);

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('选择时间区间'),
      content: _buildDialogContent(context),
      actions: _buildDialogActions(context),
    );
  }

  // 构建内容
  Widget _buildDialogContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<DateTime?>(
          valueListenable: logic.startTimeController,
          builder: (_, selectTime, __) {
            return DatePicker(
              header: '开始时间',
              selected: selectTime,
              onChanged: (v) => logic.startTimeController.setValue(v),
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text('至'),
        ),
        ValueListenableBuilder<DateTime?>(
          valueListenable: logic.endTimeController,
          builder: (_, selectTime, __) {
            return DatePicker(
              header: '结束时间',
              selected: selectTime,
              onChanged: (v) => logic.endTimeController.setValue(v),
            );
          },
        ),
      ],
    );
  }

  // 构建动作菜单集合
  List<Widget> _buildDialogActions(BuildContext context) => [
        Button(
          child: const Text('取消'),
          onPressed: () => Navigator.maybePop(context),
        ),
        Button(
          onPressed: () => Navigator.maybePop(
            context,
            const JDateRangPicker(),
          ),
          child: const Text('清空'),
        ),
        FilledButton(
          onPressed: () => Navigator.maybePop(
            context,
            logic.datePickerResult,
          ),
          child: const Text('确认'),
        ),
      ];
}

/*
* 日期区间选择弹窗-逻辑
* @author wuxubaiyang
* @Time 2022/11/1 16:51
*/
class _DateRangPickerDialogLogic extends BaseLogic {
  // 开始时间
  final ValueChangeNotifier<DateTime?> startTimeController;

  // 结束时间
  final ValueChangeNotifier<DateTime?> endTimeController;

  _DateRangPickerDialogLogic(JDateRangPicker? initialDate)
      : startTimeController = ValueChangeNotifier(initialDate?.start),
        endTimeController = ValueChangeNotifier(initialDate?.end);

  // 获取日期选择结果
  JDateRangPicker get datePickerResult => JDateRangPicker(
        start: startTimeController.value,
        end: endTimeController.value,
      );
}

/*
* 日期区间选择结果实体
* @author wuxubaiyang
* @Time 2022/11/11 10:03
*/
class JDateRangPicker {
  // 开始时间
  final DateTime? start;

  // 结束时间
  final DateTime? end;

  const JDateRangPicker({
    this.start,
    this.end,
  });
}
