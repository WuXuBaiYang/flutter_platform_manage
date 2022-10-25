import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:crypto/crypto.dart' as crypto;
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:math';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/manager/event_manage.dart';
import 'package:flutter_platform_manage/model/event/project_logo_change_event.dart';

/*
* 通用工具方法
* @author wuxubaiyang
* @Time 5/18/2022 10:58 AM
*/
class Utils {
  // 生成id
  static String genID({int? seed}) {
    final time = DateTime.now().millisecondsSinceEpoch;
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

  // 修改图片尺寸并返回
  static Future<ByteData?> resizeImage(Uint8List rawImage,
      {int? width, int? height}) async {
    final codec = await ui.instantiateImageCodec(rawImage,
        targetWidth: width, targetHeight: height);
    final resizedImage = (await codec.getNextFrame()).image;
    return resizedImage.toByteData(format: ui.ImageByteFormat.png);
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
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: "请选择 ${minSize.width}*${minSize.height}px 以上的正方形png图片",
      allowCompression: false,
      lockParentWindow: true,
      type: FileType.image,
    );
    if (null != result && result.count > 0) {
      final f = File(result.paths.first ?? "");
      final imgSize = await Utils.loadImageSize(f);
      if (imgSize.aspectRatio != 1.0 || imgSize < minSize) {
        throw Exception("图标必须是大于等于 ${minSize.width}*${minSize.height}px 的正方形");
      }
      return f;
    }
    return null;
  }

  // 将一张图片的尺寸压缩为不同尺寸并写入本地
  static Future<List<String>> compressImageSize(
      File sourceImage, Map<Size, String> targetMap) async {
    var t = <String>[];
    final rawImage = await sourceImage.readAsBytes();
    for (var size in targetMap.keys) {
      var bytes = await Utils.resizeImage(rawImage,
          height: size.width.toInt(), width: size.height.toInt());
      if (null == bytes) continue;
      var path = targetMap[size] ?? "";
      if (path.isEmpty) continue;
      await File(path).writeAsBytes(bytes.buffer.asInt8List());
      t.add(path);
    }
    return t;
  }

  // 修改平台图标
  static Future<List<String>> compressIcons(
      File sourceImage, Map<Size, String> targetMap) {
    return compressImageSize(sourceImage, targetMap).then((v) {
      if (v.isNotEmpty) {
        // 发送图片源变动的地址集合
        eventManage.fire(ProjectLogoChangeEvent(v));
      }
      return v;
    });
  }
}
