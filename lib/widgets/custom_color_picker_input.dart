import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// Provide hex input wiget for 3/6/8 digits.
class CustomColorPickerInput extends StatefulWidget {
  const CustomColorPickerInput(
    this.color,
    this.onColorChanged, {
    Key? key,
    this.enableAlpha = true,
    this.embeddedText = false,
    this.disable = false,
  }) : super(key: key);

  final Color color;
  final ValueChanged<Color> onColorChanged;
  final bool enableAlpha;
  final bool embeddedText;
  final bool disable;

  @override
  State<StatefulWidget> createState() => _CustomColorPickerInputState();
}

class _CustomColorPickerInputState extends State<CustomColorPickerInput> {
  TextEditingController textEditingController = TextEditingController();
  int inputColor = 0;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (inputColor != widget.color.value) {
      textEditingController.text =
          '#${widget.enableAlpha ? widget.color.alpha.toRadixString(16).toUpperCase().padLeft(2, '0') : ''}${widget.color.red.toRadixString(16).toUpperCase().padLeft(2, '0')}${widget.color.green.toRadixString(16).toUpperCase().padLeft(2, '0')}${widget.color.blue.toRadixString(16).toUpperCase().padLeft(2, '0')}';
    }
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (!widget.embeddedText)
          Text('Hex', style: Theme.of(context).textTheme.bodyText1),
        const SizedBox(width: 10),
        SizedBox(
          width: (Theme.of(context).textTheme.bodyText2?.fontSize ?? 14) * 10,
          child: TextField(
            enabled: !widget.disable,
            controller: textEditingController,
            inputFormatters: [
              UpperCaseTextFormatter(),
              FilteringTextInputFormatter.allow(RegExp(kValidHexPattern)),
            ],
            decoration: InputDecoration(
              isDense: true,
              label: widget.embeddedText ? const Text('Hex') : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
            ),
            onChanged: (String value) {
              String input = value;
              if (value.length == 9) {
                input = value.split('').getRange(7, 9).join() +
                    value.split('').getRange(1, 7).join();
              }
              final Color? color = colorFromHex(input);
              if (color != null) {
                widget.onColorChanged(color);
                inputColor = color.value;
              }
            },
          ),
        ),
      ]),
    );
  }
}
