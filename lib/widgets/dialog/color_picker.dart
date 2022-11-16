import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/widgets/custom_color_picker_input.dart';
import 'package:flutter_platform_manage/common/logic_state.dart';

/*
* 颜色选择器弹窗
* @author wuxubaiyang
* @Time 2022/11/8 11:24
*/
class ColorPickerDialog extends StatefulWidget {
  // 初始化颜色
  final Color? initialColor;

  // 是否启用透明通道
  final bool enableAlpha;

  // 是否启用色值输入
  final bool enableInput;

  const ColorPickerDialog({
    Key? key,
    this.initialColor,
    this.enableAlpha = true,
    this.enableInput = true,
  }) : super(key: key);

  // 显示颜色选择器弹窗
  static Future<Color?> show(
    BuildContext context, {
    Color? initialColor,
    bool enableAlpha = true,
    bool enableInput = true,
  }) {
    return showDialog<Color>(
      context: context,
      builder: (_) => ColorPickerDialog(
        initialColor: initialColor,
        enableAlpha: enableAlpha,
        enableInput: enableInput,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _ColorPickerDialogState();
}

/*
* 颜色选择器弹窗-状态
* @author wuxubaiyang
* @Time 2022/11/8 11:24
*/
class _ColorPickerDialogState
    extends LogicState<ColorPickerDialog, _ColorPickerDialogLogic> {
  @override
  _ColorPickerDialogLogic initLogic() =>
      _ColorPickerDialogLogic(widget.initialColor);

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      constraints: const BoxConstraints(
        maxWidth: 700,
        maxHeight: 350,
      ),
      content: _buildColorPicker(),
      actions: [
        Button(
          child: const Text('取消'),
          onPressed: () => Navigator.maybePop(context),
        ),
        FilledButton(
          onPressed: () => Navigator.maybePop(
              context, logic.colorController.value?.toColor()),
          child: const Text('选择'),
        ),
      ],
    );
  }

  // 构建颜色选择器
  Widget _buildColorPicker() {
    return ValueListenableBuilder<HSVColor?>(
      valueListenable: logic.colorController,
      builder: (_, selectColor, __) {
        final color = selectColor ?? const HSVColor.fromAHSV(0, 0, 0, 0);
        return material.Material(
          child: Row(
            children: [
              SizedBox.square(
                dimension: 200,
                child: ColorPickerArea(
                  color,
                  logic.updateColor,
                  PaletteType.hsv,
                ),
              ),
              const Spacer(),
              _buildColorPickerRing(color),
              const Spacer(),
              _buildColorPickerSlider(color),
            ],
          ),
        );
      },
    );
  }

  // 构建颜色选择的环形
  Widget _buildColorPickerRing(HSVColor hsvColor) {
    final color = hsvColor.toColor();
    return SizedBox.square(
      dimension: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ColorPickerHueRing(
              hsvColor,
              logic.updateColor,
              strokeWidth: 15,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Container(
                  width: 35,
                  height: 35,
                  color: color,
                ),
              ),
              CustomColorPickerInput(
                color,
                (v) => logic.updateColor(HSVColor.fromColor(v)),
                embeddedText: true,
                enableAlpha: widget.enableAlpha,
                disable: !widget.enableInput,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 构建滑动条颜色选择器
  Widget _buildColorPickerSlider(HSVColor color) {
    // 滚动条颜色选择器尺寸
    const itemSize = Size(200, 30);
    const labelTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SizedBox.fromSize(
              size: itemSize,
              child: ColorPickerSlider(
                TrackType.red,
                color,
                logic.updateColor,
              ),
            ),
            const Text('R', style: labelTextStyle),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            SizedBox.fromSize(
              size: itemSize,
              child: ColorPickerSlider(
                TrackType.green,
                color,
                logic.updateColor,
              ),
            ),
            const Text('G', style: labelTextStyle),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            SizedBox.fromSize(
              size: itemSize,
              child: ColorPickerSlider(
                TrackType.blue,
                color,
                logic.updateColor,
              ),
            ),
            const Text('B', style: labelTextStyle),
          ],
        ),
        Visibility(
          visible: widget.enableAlpha,
          child: const SizedBox(height: 14),
        ),
        Visibility(
          visible: widget.enableAlpha,
          child: Row(
            children: [
              SizedBox.fromSize(
                size: itemSize,
                child: ColorPickerSlider(
                  TrackType.alpha,
                  color,
                  logic.updateColor,
                ),
              ),
              const Text('A', style: labelTextStyle),
            ],
          ),
        ),
      ],
    );
  }
}

/*
* 颜色选择器弹窗-逻辑
* @author wuxubaiyang
* @Time 2022/11/8 11:25
*/
class _ColorPickerDialogLogic extends BaseLogic {
  // 初始化颜色
  final ValueChangeNotifier<HSVColor?> colorController;

  _ColorPickerDialogLogic(Color? color)
      : colorController = ValueChangeNotifier(
            HSVColor.fromColor(color ?? Colors.transparent));

  // 更新色值
  void updateColor(HSVColor color) => colorController.setValue(color);

  @override
  void dispose() {
    colorController.dispose();
    super.dispose();
  }
}
