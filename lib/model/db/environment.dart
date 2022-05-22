import 'package:realm/realm.dart';

part 'environment.g.dart';

/*
* 项目环境对象
* @author wuxubaiyang
* @Time 5/12/2022 14:58
*/
@RealmModel()
class _Environment {
  // 主键key
  @PrimaryKey()
  late String primaryKey;

  // 根路径
  late String path;

  // flutter版本号
  late String flutter;

  // 通道
  late String channel;

  // dart版本号
  late String dart;
}