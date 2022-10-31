import 'dart:async';

import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/model/db/project.dart';
import 'package:flutter_platform_manage/model/project.dart';

import '../common/manage.dart';

/*
* 项目管理
* @author wuxubaiyang
* @Time 5/12/2022 16:39
*/
class ProjectManage extends BaseManage {
  static final ProjectManage _instance = ProjectManage._internal();

  factory ProjectManage() => _instance;

  ProjectManage._internal();

  // 判断是否存在相同项目
  bool has(String path) =>
      dbManage.all<Project>().query(r'path == $0', [path]).isNotEmpty;

  // 添加项目信息
  void add(Project project) {
    return dbManage.write((realm) {
      if (!project.isManaged) {
        project.order = realm.all<Project>().length + 1;
      }
      realm.add<Project>(project);
    });
  }

  // 加载所有项目信息
  Future<List<ProjectModel>> loadAll({bool simple = false}) async {
    final temp = <ProjectModel>[];
    for (final it in dbManage.all<Project>().toList()
      ..sort((l, r) => l.order.compareTo(r.order))) {
      final p = ProjectModel(project: it);
      await p.update(simple);
      // await p.updateSimple();
      temp.add(p);
    }
    return temp;
  }

  // 根据项目key获取项目完整信息
  Future<ProjectModel?> getProjectInfo(String key,
      {bool simple = false}) async {
    final t = dbManage.find<Project>(key);
    if (null == t) return null;
    final p = ProjectModel(project: t);
    await p.update(simple);
    return p;
  }
}

//单例调用
final projectManage = ProjectManage();
