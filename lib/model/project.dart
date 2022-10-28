import 'dart:io';
import 'package:flutter_platform_manage/common/file_path.dart';
import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/model/db/project.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/utils/file_handle.dart';
import 'db/environment.dart';

/*
*
* @author wuxubaiyang
* @Time 5/20/2022 10:37 AM
*/
class ProjectModel {
  // 项目基本信息
  final Project project;

  // 项目本地存储路径项目是否存在(项目根目录下是否有pubspec.yaml)
  bool exist;

  // 项目名称（pubspec中不可为中文）
  String name;

  // 项目版本号
  String version;

  // 平台表
  Map<PlatformType, BasePlatform> platformMap;

  ProjectModel({
    required this.project,
    this.exist = true,
    this.name = '',
    this.version = '',
    this.platformMap = const {},
  });

  // 获取平台集合
  List<BasePlatform> get platformList => platformMap.values.toList();

  // 获取展示标题
  String get showTitle {
    final t = project.alias;
    return t.isEmpty ? name : '$t($name)';
  }

  // 获取唯一应用图标
  ProjectIcon? get projectIcon {
    for (final it in platformMap.values) {
      final icon = it.singleIcon;
      if (icon != null) return icon;
    }
    return null;
  }

  // 缓存环境信息
  Environment? _environment;

  // 获取当前项目对应的环境对象
  Environment? get environment =>
      _environment ??= dbManage.find<Environment>(project.environmentKey);

  // 项目名称正则
  final _nameReg = RegExp(r'name: .+');
  final _nameRegRe = RegExp(r'name: ');

  // 项目版本号正则
  final _versionReg = RegExp(r'version: .+\+.+');
  final _versionRegRe = RegExp(r'version: ');

  // pubspec文件绝对路径
  String get pubspecFilePath => '${project.path}/${ProjectFilePath.pubspec}';

  // 更新项目信息
  Future<bool> update(bool simple) async {
    final handle = FileHandle.from(pubspecFilePath);
    try {
      // 处理pubspec.yaml文件
      // 判断项目是否存在
      exist = handle.existAsync;
      // 获取项目名称
      name = await handle.stringMatch(_nameReg, re: _nameRegRe);
      // 获取项目版本号
      version = await handle.stringMatch(_versionReg, re: _versionRegRe);
      // 处理平台信息
      // 遍历并创建平台对象
      platformMap = {};
      for (final t in PlatformType.values) {
        final d = Directory('${project.path}/${t.name}');
        if (!d.existsSync()) continue;
        final p = t.create(d.path);
        // 更新平台信息
        if (!await p.update(simple)) return false;
        platformMap[t] = p;
      }
      // 置空环境对象
      _environment = null;
    } catch (e) {
      return false;
    }
    return true;
  }

  // 执行项目信息变动
  Future<bool> commit() async {
    final handle = FileHandle.from(pubspecFilePath);
    try {
      // 处理pubspec.yaml文件
      // 修改项目名称
      await modifyProjectName(name, handle: handle);
      // 修改项目版本号
      await modifyProjectVersion(version, handle: handle);
      // 处理平台信息
      // 遍历平台并执行提交
      for (final p in platformMap.values) {
        if (!await p.commit()) return false;
      }
      // 置空环境对象
      _environment = null;
    } catch (e) {
      return false;
    }
    return true;
  }

  // 修改pubspec中的项目名称
  Future<bool> modifyProjectName(String name,
      {FileHandle? handle, bool autoCommit = false}) async {
    handle ??= FileHandle.from(pubspecFilePath);
    // 修改项目名称
    await handle.replace(_nameReg, 'name: $name');
    return autoCommit ? await handle.commit() : true;
  }

  // 修改pubspec中的应用版本号
  Future<bool> modifyProjectVersion(String version,
      {FileHandle? handle, bool autoCommit = false}) async {
    handle ??= FileHandle.from(pubspecFilePath);
    // 修改项目版本号
    await handle.replace(_versionReg, 'version: $version');
    return autoCommit ? await handle.commit() : true;
  }

  // 修改展示名称
  Future<bool> modifyDisplayName(String name) async {
    ///待实现
    return true;
  }

  // 修改平台图标
  Future<void> modifyProjectIcon(File file) async {
    ///待实现
  }

  // 项目平台打包
  Future<void> projectPackaging(File output) async {
    ///待实现
  }
}
