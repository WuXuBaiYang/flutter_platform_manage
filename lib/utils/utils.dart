import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';
import 'dart:math';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';

/*
* 通用工具方法
* @author wuxubaiyang
* @Time 5/18/2022 10:58 AM
*/
class Utils {
  // 生成id
  static String genID({int? seed}) {
    var time = DateTime.now().millisecondsSinceEpoch;
    return md5("${time}_${Random(seed ?? time).nextDouble()}");
  }

  // 计算md5
  static String md5(String value) =>
      crypto.md5.convert(utf8.encode(value)).toString();

  // 显示snackBar
  static OverlayEntry showSnack(
    BuildContext context,
    String text, {
    Widget? action,
  }) {
    return showSnackbar(
      context,
      Snackbar(
        content: Text(text),
        action: action,
        extended: true,
      ),
      duration: const Duration(milliseconds: 2500),
    );
  }

  // 展示文件路径以及复制按钮
  static OverlayEntry showSnackWithFilePath(
    BuildContext context,
    String filePath,
  ) {
    filePath = filePath.replaceAll('/', "\\");
    var hasClip = false;
    return Utils.showSnack(
      context,
      "文件路径：\n$filePath",
      action: StatefulBuilder(
        builder: (_, setState) {
          return TextButton(
            onPressed: hasClip
                ? null
                : () => setState(() {
                      Clipboard.setData(ClipboardData(text: filePath));
                      hasClip = true;
                    }),
            child: Text(hasClip ? "已复制到剪切板" : "复制"),
          );
        },
      ),
    );
  }

  // 加载弹窗dialog缓存
  static Future? _loadingDialog;

  // 展示加载弹窗
  static Future<T?> showLoading<T>(
    BuildContext context, {
    required Future<T?> loadFuture,
  }) async {
    var navigator = Navigator.of(context);
    try {
      if (null != _loadingDialog) navigator.pop();
      _loadingDialog = showDialog<void>(
        context: context,
        builder: (_) => const Center(
          child: Card(
            child: ProgressRing(),
          ),
        ),
      )..whenComplete(() => _loadingDialog = null);
      var result = await loadFuture;
      if (null != _loadingDialog) navigator.pop();
      return result;
    } catch (e) {
      if (null != _loadingDialog) navigator.pop();
      rethrow;
    }
  }
}
