import 'package:flutter_platform_manage/model/platform/base_platform.dart';

/*
* 平台权限
* @author wuxubaiyang
* @Time 2022-08-01 09:59:55
*/
class PermissionModel {
  // 权限总数
  final int total;

  // 权限集合
  final List<PermissionItemModel> items;

  // 权限对照表
  final Map<String, PermissionItemModel> itemsMap;

  // 平台
  final PlatformType platform;

  PermissionModel(this.total, this.items, this.platform)
      : itemsMap = items.asMap().map((k, v) => MapEntry(v.value, v));

  // 从json中解析对象
  static PermissionModel fromJson(obj, {required PlatformType platform}) {
    return PermissionModel(
      obj['total'],
      obj['items']
          .map<PermissionItemModel>((e) => PermissionItemModel.fromJson(e))
          .toList(),
      platform,
    );
  }
}

/*
* 平台权限子项
* @author wuxubaiyang
* @Time 2022-08-01 10:15:12
*/
class PermissionItemModel {
  // 名称
  final String name;

  // 描述
  String? describe;

  // 提示
  final String? hint;

  // 值
  final String value;

  PermissionItemModel(this.name, this.describe, this.hint, this.value);

  // 从json中解析对象
  static PermissionItemModel fromJson(obj) {
    return PermissionItemModel(
      obj['name'],
      obj['describe'],
      obj['hint'],
      obj['value'],
    );
  }

  // 搜索所有字段(包含匹配)
  bool searchContains(String v) =>
      name.contains(v) ||
      (describe?.contains(v) ?? false) ||
      (hint?.contains(v) ?? false) ||
      value.contains(v);

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final PermissionItemModel typedOther = other;
    return name == typedOther.name &&
        describe == typedOther.describe &&
        hint == typedOther.hint &&
        value == typedOther.value;
  }

  @override
  int get hashCode => Object.hash(name, describe, hint, value);
}
