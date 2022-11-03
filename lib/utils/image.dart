import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_platform_manage/utils/log.dart';
import 'package:image/image.dart';

/*
* 图片处理
* @author wuxubaiyang
* @Time 2022/11/3 19:51
*/
class ImageHandle {
  // 图片处理方法
  void _decodeIsolate(_DecodeParam param) {
    var image = decodeImage(param.source.readAsBytesSync());
    if (image != null) {
      final size = param.size;
      final w = size.width.toInt(), h = size.height.toInt();
      image = copyResize(image, width: w, height: h);
    }
    param.sendPort.send(image);
  }

  // 修改图片尺寸并保存
  Future<bool> resizeImageAndSave(
    File source, {
    required String target,
    required Size size,
    ImageEncodeType encodeType = ImageEncodeType.png,
  }) async {
    try {
      final receivePort = ReceivePort();
      // 发送线程请求
      await Isolate.spawn(
          _decodeIsolate,
          _DecodeParam(
            source: source,
            size: size,
            sendPort: receivePort.sendPort,
          ));
      final image = await receivePort.first;
      if (image == null) return false;
      final f = File(target);
      if (!f.existsSync()) {
        f.createSync(recursive: true);
      }
      await f.writeAsBytes(encodeType.encode(image as Image));
    } catch (e) {
      LogTool.e('图片尺寸修改失败', error: e);
      return false;
    }
    return true;
  }
}

/*
* 图片处理参数
* @author wuxubaiyang
* @Time 2022/11/3 19:53
*/
class _DecodeParam {
  // 源文件
  final File source;

  // 目标尺寸
  final Size size;

  // 通信接口
  final SendPort sendPort;

  _DecodeParam({
    required this.source,
    required this.size,
    required this.sendPort,
  });
}

// 图片处理支持的格式枚举
enum ImageEncodeType {
  jpg,
  png,
  ico,
}

// 图片处理支持扩展
extension ImageEncodeTypeExtension on ImageEncodeType {
  // 编码
  List<int> encode(Image image) => {
        ImageEncodeType.jpg: encodeJpg,
        ImageEncodeType.png: encodePng,
        ImageEncodeType.ico: encodeIco,
      }[this]!(image);
}
