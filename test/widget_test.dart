import 'dart:io';

import 'package:flutter_platform_manage/model/android_key.dart';
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
}
