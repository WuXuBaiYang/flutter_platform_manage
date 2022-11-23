import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/model/db/environment.dart';
import 'package:flutter_platform_manage/model/android_key.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/utils/log.dart';
import 'package:process_run/shell.dart';

/*
* 脚本处理
* @author wuxubaiyang
* @Time 5/21/2022 7:52 AM
*/
class ScriptHandle {
  // 查看flutter版本号信息
  static Future<Environment> loadFlutterEnv(String path,
      {Environment? oldEnv}) async {
    final script = '$path/${ProjectFilePath.flutter} --version';
    final outText = await _runShell(script);
    var version = 'Flutter', channel = 'channel', dart = 'Dart';
    for (var it in outText.split(r'•')) {
      it = it.trim();
      if (it.startsWith(version)) {
        version = it.replaceAll(version, '').trim();
      } else if (it.startsWith(channel)) {
        channel = it.replaceAll(channel, '').trim();
      } else if (it.startsWith(dart)) {
        dart = it.replaceAll(dart, '').trim();
      }
    }
    return (oldEnv ??= Environment())
      ..path = path
      ..flutter = version
      ..channel = channel
      ..dart = dart;
  }

  // 创建平台信息
  static Future<bool> createPlatforms(
      String envPath, List<PlatformType> platforms) async {
    final script = '$envPath/${ProjectFilePath.flutter} create '
        '--platforms=${platforms.map((e) => e.name).join(',')} .';
    final outText = await _runShell(script);
    return outText.contains(r'All done');
  }

  // 项目平台打包
  static Future<bool> buildApp(String envPath, String projectPath,
      {required PlatformType platform, ShellController? controller}) async {
    final t = const {
      PlatformType.android: 'apk',
      PlatformType.ios: '',
      PlatformType.web: 'web',
      PlatformType.windows: 'windows',
      PlatformType.macos: '',
      PlatformType.linux: '',
    }[platform];
    if (t == null || t.isEmpty) return false;
    final script = '$envPath/${ProjectFilePath.flutter} build $t';
    final outText = await _runShell(
      script,
      path: projectPath,
      controller: controller,
    );
    return outText.contains(r'√  Built');
  }

  // 查看android签名文件信息
  static Future<String> loadAndroidKeyInfo(AndroidKeyParams params) {
    if (!params.checkCanGetInfo()) throw Exception('参数不完整');
    final script = 'keytool -v -list '
        '-storepass ${params.storePass} -keystore ${params.keystore}';
    return _runShell(script);
  }

  // 生成android签名文件
  static Future<bool> genAndroidKey(AndroidKeyParams params) async {
    try {
      if (!params.checkCanGenKey()) throw Exception('参数不完整');
      final script = 'keytool -genkey '
          '-alias ${params.alias} -keyalg ${params.keyAlg} '
          '-keysize ${params.keySize} -validity ${params.validity} '
          '-dname "${params.getDNameInfo()}" -storetype PKCS12 '
          '-keypass ${params.keyPass} -storepass ${params.storePass} '
          '-keystore ${params.keystore}';
      await _runShell(script);
      return File(params.keystore).exists();
    } catch (e) {
      LogTool.e('android签名生成失败', error: e);
      return false;
    }
  }

  // 脚本执行方法
  static Future<String> _runShell(String script,
      {String? path, ShellController? controller}) async {
    final shell = Shell(
      throwOnError: true,
      workingDirectory: path,
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
      stdin: controller?._inController.stream,
      stdout: controller?._outController,
      stderr: controller?._errOutController,
    );
    // 监听kill命令并返回结果
    controller?._killInController.stream.listen((e) {
      controller._killOutController.add(shell.kill(e));
    });
    final list = await shell.run(script);
    controller?.dispose();
    final errText = list.map((e) => e.errText).join('');
    if (errText.isNotEmpty) throw Exception(errText);
    return list.map((e) => e.outText).join('');
  }
}

// 控制器输出回调
typedef OnShellOutListener = void Function(String text);

/*
* 脚本控制器
* @author wuxubaiyang
* @Time 2022/11/18 13:39
*/
class ShellController {
  // shell输入控制器
  final _inController = StreamController<List<int>>();

  // shell输出控制器
  final _outController = StreamController<List<int>>();

  // shell异常输出控制器
  final _errOutController = StreamController<List<int>>();

  // 杀死进程输入控制器
  final _killInController = StreamController<ProcessSignal>();

  // 杀死进程输出控制器
  final _killOutController = StreamController<bool>();

  // 输出回调集合
  final List<OnShellOutListener> _outListeners = [];

  // 记录输出日志
  final List<String> _logs = [];

  // 异常输出回调
  final List<OnShellOutListener> _errOutListeners = [];

  // 记录异常日志
  final List<String> _errors = [];

  ShellController() {
    // 监听内容输出
    _outController.stream.listen((e) {
      final result = String.fromCharCodes(
        Uint8List.fromList(e),
      );
      _logs.add(result);
      LogTool.i('打包记录输出：$result');
      if (_outListeners.isEmpty) return;
      for (var li in _outListeners) {
        li.call(result);
      }
    });
    // 监听异常内容输出
    _errOutController.stream.listen((e) {
      final result = String.fromCharCodes(
        Uint8List.fromList(e),
      );
      _errors.add(result);
      LogTool.i('打包异常输出：$result');
      if (_errOutListeners.isEmpty) return;
      for (var li in _errOutListeners) {
        li.call(result);
      }
    });
  }

  // 向shell输入
  void addInput(String text) => _inController.add(text.codeUnits);

  // 监听shell输出
  void addOutListener(OnShellOutListener listener) =>
      _outListeners.add(listener);

  // 监听shell异常输出
  void addErrOutListener(OnShellOutListener listener) =>
      _errOutListeners.add(listener);

  // 判断是否存在输出
  bool get hasOutput => _logs.isNotEmpty;

  // 获取全部的输入
  String get output => _logs.join('\n');

  // 判断是否存在异常输出
  bool get hasOutputErr => _errors.isNotEmpty;

  // 获取全部的异常输出
  String get outputErr => _errors.join('\n');

  // 杀死控制台
  Future<bool> kill({
    ProcessSignal signal = ProcessSignal.sigkill,
  }) async {
    final c = Completer<bool>();
    _killOutController.stream.listen(c.complete);
    _killInController.add(signal);
    _isKilled = true;
    return await c.future;
  }

  // 记录是否已杀死shell
  var _isKilled = false;

  // 判断是否杀死shell
  bool get isKilled => _isKilled;

  // 销毁控制器
  void dispose() {
    _inController.close();
    _outController.close();
    _errOutController.close();
    _killInController.close();
    _killOutController.close();
    _errOutListeners.clear();
    _outListeners.clear();
  }
}
