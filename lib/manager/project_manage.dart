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

  // 添加项目信息
  void add(Project project) {
    return dbManage.write((realm) {
      realm.add<Project>(project);
    });
  }

  // 加载所有项目信息
  Future<List<ProjectModel>> loadAll() async {
    var temp = <ProjectModel>[];
    for (var it in dbManage.all<Project>()) {
      var p = ProjectModel(project: it);
      await p.updateSimple();
      temp.add(p);
    }
    return temp;
  }
}

//单例调用
final projectManage = ProjectManage();
