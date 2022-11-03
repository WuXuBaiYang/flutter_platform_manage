import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:crypto/crypto.dart' as crypto;
import 'package:file_picker/file_picker.dart';
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
    final time = DateTime.now().millisecondsSinceEpoch;
    return md5('${time}_${Random(seed ?? time).nextDouble()}');
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
    filePath = filePath.replaceAll('/', '\\');
    var hasClip = false;
    return Utils.showSnack(
      context,
      '文件路径：\n$filePath',
      action: StatefulBuilder(
        builder: (_, setState) {
          return TextButton(
            onPressed: hasClip
                ? null
                : () => setState(() {
                      Clipboard.setData(ClipboardData(text: filePath));
                      hasClip = true;
                    }),
            child: Text(hasClip ? '已复制到剪切板' : '复制'),
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
    final navigator = Navigator.of(context);
    try {
      if (null != _loadingDialog) navigator.maybePop();
      _loadingDialog = showDialog<void>(
        context: context,
        builder: (_) => const Center(
          child: Card(
            child: ProgressRing(),
          ),
        ),
      )..whenComplete(() => _loadingDialog = null);
      final result = await loadFuture;
      if (null != _loadingDialog) navigator.maybePop();
      return result;
    } catch (e) {
      if (null != _loadingDialog) navigator.maybePop();
      rethrow;
    }
  }

  // 英文首字母大写
  static String toBeginningOfSentenceCase(String input, [String? locale]) {
    if (input.isEmpty) return input;
    return '${_upperCaseLetter(input[0], locale)}${input.substring(1)}';
  }

  // 大写
  static String _upperCaseLetter(String input, String? locale) {
    // Hard-code the important edge case of i->İ
    if (locale != null) {
      if (input == 'i' && locale.startsWith('tr') || locale.startsWith('az')) {
        return '\u0130';
      }
    }
    return input.toUpperCase();
  }

  // 获取图片参数信息
  static Future<ImageInfo> loadImageInfo(File file) {
    final c = Completer<ImageInfo>();
    Image.file(file)
        .image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener(
          (info, _) => c.complete(info),
          onError: (exception, stackTrace) =>
              c.completeError(exception, stackTrace),
        ));
    return c.future;
  }

  // 获取图片尺寸
  static Future<Size> loadImageSize(File file) async {
    final img = (await loadImageInfo(file)).image;
    return Size(img.width.toDouble(), img.height.toDouble());
  }

  // 选择项目图标(正方形，并且有最小尺寸限制)
  static Future<File?> pickProjectLogo(
      {Size minSize = const Size.square(1024)}) async {
    // 选择图标文件
    final result = await pickFiles(
      dialogTitle: '请选择 ${minSize.width}*${minSize.height}px 以上的png图片',
      allowCompression: false,
      lockParentWindow: true,
      allowedExtensions: ['png'],
    );
    if (result.isNotEmpty) {
      final f = File(result.first ?? '');
      final imgSize = await Utils.loadImageSize(f);
      if (imgSize < minSize) {
        throw Exception('图标必须是大于等于 ${minSize.width}*${minSize.height}px 的图片');
      }
      return f;
    }
    return null;
  }

  // 选择目录路径
  static Future<String?> pickPath({
    String? dialogTitle,
    bool lockParentWindow = false,
    String? initialDirectory,
  }) async {
    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: dialogTitle,
      lockParentWindow: lockParentWindow,
      initialDirectory: initialDirectory,
    );
    return _handleFilePath(result);
  }

  // 选择文件路径
  static Future<List<String?>> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    List<String>? allowedExtensions,
    bool allowCompression = true,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      allowedExtensions: allowedExtensions,
      allowCompression: allowCompression,
      allowMultiple: allowMultiple,
      withData: withData,
      withReadStream: withReadStream,
      lockParentWindow: lockParentWindow,
      type: allowedExtensions != null ? FileType.custom : FileType.any,
    );
    final paths = <String?>[];
    if (result != null && result.count != 0) {
      for (var it in result.paths) {
        paths.add(_handleFilePath(it));
      }
    }
    return paths;
  }

  // 处理所选文件路径
  static String? _handleFilePath(String? path) {
    if (path == null || path.isEmpty) return path;
    // 处理macos环境下的特殊情况
    if (Platform.isMacOS) {
      final i = path.indexOf(r'/User');
      if (i != -1) return path.substring(i);
    }
    return path;
  }
}
