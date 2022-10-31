import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/model/permission.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/common/manage.dart';

/*
* 权限管理
* @author wuxubaiyang
* @Time 2022-08-01 11:35:07
*/
class PermissionManage extends BaseManage {
  static final PermissionManage _instance = PermissionManage._internal();

  factory PermissionManage() => _instance;

  PermissionManage._internal();

  // 缓存android权限对象
  late PermissionModel _androidPermissionModel;

  // 缓存ios权限对象
  late PermissionModel _iosPermissionModel;

  @override
  Future<void> init() async {
    // 加载android权限对象
    _androidPermissionModel = await _loadPermission(
      Common.androidPermissionAssets,
      PlatformType.android,
    );
    _iosPermissionModel = await _loadPermission(
      Common.iosPermissionAssets,
      PlatformType.ios,
    );
  }

  // 根据平台标记获取对应平台的权限集合
  List<PermissionItemModel> getPermissionListByPlatform(PlatformType type) =>
      getPermissionByPlatform(type)?.items ?? [];

  // 根据平台标记获取权限对象
  PermissionModel? getPermissionByPlatform(PlatformType type) {
    switch (type) {
      case PlatformType.android:
        return _androidPermissionModel;
      case PlatformType.ios:
        return _iosPermissionModel;
      case PlatformType.windows:
      case PlatformType.macos:
      case PlatformType.linux:
      case PlatformType.web:
      default:
        return null;
    }
  }

  // 根据权限的值匹配出对应的权限对象
  Future<List<PermissionItemModel>> findAllPermissions(
    List<String> values, {
    required PlatformType platform,
  }) async {
    if (values.isEmpty) return [];
    List<PermissionItemModel> t = [];
    for (final v in values) {
      var it = getPermissionByPlatform(platform)?.itemsMap[v];
      if (null != it) t.add(it);
    }
    return t;
  }

  // 加载权限的json文件
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
