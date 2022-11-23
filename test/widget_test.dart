import 'dart:io';
import 'package:flutter_platform_manage/model/android_key.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/utils/file.dart';
import 'package:flutter_platform_manage/utils/script_handle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('测试android文件遍历', () {
    const path =
        r'C:\Users\wuxubaiyang\Documents\Workspace\jtech_demo\android\app\src\main\res';
    for (var it in Directory(path).listSync()) {
      if (it.path.contains('mipmap')) {
        for (var iti in Directory(it.path).listSync()) {
          if (iti.path.contains('ic_launcher')) {
            print(iti.path);
            break;
          }
        }
      }
    }
  });
  test('测试路径替换', () {
    var a = '/volaaa/ssxxx/User/xxx/qqq/flutter';
    a = a.substring(a.indexOf(r'/User'));
    print(a);
  });
  test('测试除法', () {
    print((7 / 3).ceil());
  });

  test('生成android签名文件', () async {
    final result = await ScriptHandle.genAndroidKey(AndroidKeyParams()
      ..alias = 'testKey'
      ..validity = 3650
      ..dName.cn = '中文打包测试'
      ..dName.ou = '中文'
      ..keyPass = '123456'
      ..storePass = '123456'
      ..keystore = r'C:\Users\wuxubaiyang\Desktop\test.keystore');
    print('android签名生成 ${result ? '成功' : '失败'}');
  });

  test('获取android签名文件信息', () async {
    try {
      final result =
          await ScriptHandle.loadAndroidKeyInfo(AndroidKeyParams.info(
        storePass: '123456',
        keystore: r'C:\Users\wuxubaiyang\Desktop\test.keystore',
      ));
      print(result);
    } catch (e) {
      print(e.toString());
    }
  });

  test('测试集合下标', () {
    final a = ['1', '2', '3', '4'];
    print(a.sublist(0, a.length));
  });

  test('集合相等对比', () {
    final a = [1, 2, 3, 4];
    final b = [1, 2, 3, 4];
    for (var it in b.sublist(0, 2)) {
      b.remove(it);
    }
    print(a.every((e) => b.contains(e)));
  });

  test('测试打包输出和中断等操作', () async {
    const envPath = r'C:\Users\wuxubaiyang\Documents\Workspace\flutter';
    const projectPath = r'C:\Users\wuxubaiyang\Documents\Workspace\jtech_demo1';
    final c = ShellController();
    c.addErrOutListener((e) {
      print('异常输出：$e');
    });
    c.addOutListener((text) {
      print('打包输出：$text');
    });
    Future.delayed(Duration(seconds: 2)).then((value) {
      c.kill().then((value) {
        print('撤销打包 ${value ? '成功' : '失败'}');
      });
    });
    await ScriptHandle.buildApp(
      envPath,
      projectPath,
      platform: PlatformType.android,
      controller: c,
    ).then((v) {
      print('打包${v ? '成功' : '失败'}');
    }).catchError((e) {
      print(e);
    });
  });

  test('获取输出目录', () async {
    print(
        File(r'C:\Users\wuxubaiyang\Documents\Workspace\flutter\.github').name);
  });
}
