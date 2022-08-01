import 'package:flutter_platform_manage/model/project.dart';

/*
* 平台权限
* @author JTech JH
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
      obj["total"],
      obj["items"]
          .map<PermissionItemModel>((e) => PermissionItemModel.fromJson(e))
          .toList(),
      platform,
    );
  }
}

/*
* 平台权限子项
* @author JTech JH
* @Time 2022-08-01 10:15:12
*/
class PermissionItemModel {
  // 名称
  final String name;

  // 描述
  final String describe;

  // 值
  final String value;

  PermissionItemModel(this.name, this.describe, this.value);

  // 从json中解析对象
  static PermissionItemModel fromJson(obj) {
    return PermissionItemModel(
      obj["name"],
      obj["describe"],
      obj["value"],
    );
  }
}
