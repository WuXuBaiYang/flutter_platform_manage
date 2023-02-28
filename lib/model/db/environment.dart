import 'package:isar/isar.dart';

part 'environment.g.dart';

/*
* 项目环境对象
* @author wuxubaiyang
* @Time 5/12/2022 14:58
*/
@collection
class Environment {
  // 主键id
  Id id = Isar.autoIncrement;

  // 根路径
  String path = '';

  // flutter版本号
  String flutter = '';

  // 通道
  String channel = '';

  // dart版本号
  String dart = '';

  @override
  bool operator ==(dynamic other) {
    if (other is! Environment) return false;
    return id == other.id &&
        path == other.path &&
        flutter == other.flutter &&
        channel == other.channel &&
        dart == other.dart;
  }

  @override
  int get hashCode => Object.hash(id, path, flutter, channel, dart);
}
