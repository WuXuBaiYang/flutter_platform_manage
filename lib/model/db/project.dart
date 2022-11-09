import 'package:isar/isar.dart';

part 'project.g.dart';

/*
* 项目对象
* @author wuxubaiyang
* @Time 5/12/2022 14:58
*/
@collection
class Project {
  // 主键key
  Id id = Isar.autoIncrement;

  // 项目的本地存储路径
  String path = '';

  // 项目别名
  String alias = '';

  // 项目环境key
  int envId = 0;

  // 排序
  int order = 0;

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final Project typedOther = other;
    return id == typedOther.id &&
        path == typedOther.path &&
        alias == typedOther.alias &&
        envId == typedOther.envId &&
        order == typedOther.order;
  }

  @override
  int get hashCode => Object.hash(id, path, alias, envId, order);
}
