import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';
import 'dart:math';

/*
* 通用工具方法
* @author wuxubaiyang
* @Time 5/18/2022 10:58 AM
*/
class Utils {
  //生成id
  static String genID({int? seed}) {
    var time = DateTime.now().millisecondsSinceEpoch;
    return md5("${time}_${Random(seed ?? time).nextDouble()}");
  }

  //计算md5
  static String md5(String value) =>
      crypto.md5.convert(utf8.encode(value)).toString();
}
