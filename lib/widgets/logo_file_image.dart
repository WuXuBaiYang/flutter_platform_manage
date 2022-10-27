import 'dart:async';
import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/manager/event_manage.dart';
import 'package:flutter_platform_manage/model/event/project_logo_change_event.dart';

/*
* 图标图片文件
* @author wuxubaiyang
* @Time 2022-07-30 15:37:02
*/
class LogoFileImage extends StatefulWidget {
  // 图片文件
  final File file;

  // 缩放比例
  final double scale;

  // 图标尺寸
  final double? size;

  const LogoFileImage(
    this.file, {
    Key? key,
    this.size,
    this.scale = 1.0,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LogoFileImageState();
}

/*
* 图标图片文件-状态
* @author wuxubaiyang
* @Time 2022-07-30 15:37:26
*/
class _LogoFileImageState extends State<LogoFileImage> {
  // 持有消息监听回调
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    // 监听项目图标变化消息
    subscription = eventManage.on<ProjectLogoChangeEvent>().listen((event) {
      if (event.filePaths.contains(widget.file.path)) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Image(
      width: widget.size,
      height: widget.size,
      image: _LogoFileImageProvider(
        widget.file,
        scale: widget.scale,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // 销毁消息监听
    subscription?.cancel();
    subscription = null;
  }
}

/*
* 图标图片文件代理
* @author wuxubaiyang
* @Time 2022-07-30 15:31:59
*/
class _LogoFileImageProvider extends FileImage {
  // 图片尺寸
  final int fileSize;

  _LogoFileImageProvider(File file, {double scale = 1.0})
      : fileSize = file.lengthSync(),
        super(file, scale: scale);

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final _LogoFileImageProvider typedOther = other;
    return file.path == typedOther.file.path &&
        scale == typedOther.scale &&
        fileSize == typedOther.fileSize;
  }

  @override
  int get hashCode => Object.hash(file.path, scale);
}
