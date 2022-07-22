import 'dart:async';

import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/model/db/project.dart';
import 'package:flutter_platform_manage/model/project.dart';

import 'base_manage.dart';

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
      project.order = realm.all<Project>().length + 1;
      realm.add<Project>(project);
    });
  }

  // 加载所有项目信息
  Future<List<ProjectModel>> loadAll() async {
    var temp = <ProjectModel>[];
    for (var it in dbManage.all<Project>().toList()
      ..sort((l, r) => l.order.compareTo(r.order))) {
      var p = ProjectModel(project: it);
      await p.update();
      // await p.updateSimple();
      temp.add(p);
    }
    return temp;
  }

  // 根据项目key获取项目完整信息
  Future<ProjectModel?> getProjectInfo(String key) async {
    var t = dbManage.find<Project>(key);
    if (null == t) return null;
    var p = ProjectModel(project: t);
    await p.update();
    return p;
  }

  // 监听项目数量变化
  Stream<List<ProjectModel>> watchCount() {
    var count = dbManage.all<Project>().length;
    var c = StreamController<List<ProjectModel>>();
    dbManage.changes<Project>().listen((e) {
      if (count != e.results.length) {
        count = e.results.length;
        loadAll().then((v) => c.sink.add(v));
      }
    });
    return c.stream;
  }
}

//单例调用
final projectManage = ProjectManage();
