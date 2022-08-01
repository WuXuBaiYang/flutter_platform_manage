import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/model/permission.dart';
import 'package:flutter_platform_manage/model/project.dart';

import 'base_manage.dart';

/*
* 权限管理
* @author JTech JH
* @Time 2022-08-01 11:35:07
*/
class PermissionManage extends BaseManage {
  static final PermissionManage _instance = PermissionManage._internal();

  factory PermissionManage() => _instance;

  PermissionManage._internal();

  // 缓存android权限对象
  late PermissionModel _androidPermissionModel;

  @override
  Future<void> init() async {
    // 加载android权限对象
    _androidPermissionModel = await _loadPermission(
      Common.androidPermissionAssets,
      PlatformType.android,
    );
  }

  // 获取所有android权限对象
  List<PermissionItemModel> get androidPermissions =>
      _androidPermissionModel.items;

  // 根据权限的值匹配出对应的android权限对象
  Future<List<PermissionItemModel>> findAllAndroidPermissions(
    List<String> values,
  ) async {
    List<PermissionItemModel> t = [];
    for (var v in values) {
      var it = _androidPermissionModel.itemsMap[v];
      if (null != it) t.add(it);
    }
    return t;
  }

  // 获取所有android权限
  static Future<PermissionModel> _loadPermission(
    String assetsPath,
    PlatformType type,
  ) async {
    var json = await rootBundle.loadString(assetsPath);
    return PermissionModel.fromJson(
      jsonDecode(json),
      platform: type,
    );
  }
}

//单例调用
final permissionManage = PermissionManage();
