import 'dart:io';

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
}
