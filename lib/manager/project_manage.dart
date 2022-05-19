import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/model/db/project.dart';
import 'package:realm/realm.dart';
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

  // 加载所有项目信息
  RealmResults<Project> loadAll() => dbManage.all<Project>();

  // 加载指定项目信息
  Project? loadByKey(String primaryKey) => dbManage.find<Project>(primaryKey);

  // 更新项目信息
  Future<void> updateInfo(List<Project> projectList) async {
    for (var it in projectList) {
      // 更新基本信息
      it.name = "";
    }
  }
}

//单例调用
final projectManage = ProjectManage();
