import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/common/notifier.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/manager/theme.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/pages/package/record.dart';
import 'package:flutter_platform_manage/pages/package/task.dart';
import 'package:flutter_platform_manage/widgets/logic_state.dart';

// 加载项目详情缓存回调
typedef OnProjectCacheLoad = Future<ProjectModel?> Function(int id);

/*
* 打包管理页
* @author wuxubaiyang
* @Time 2022/11/10 10:41
*/
class PackagePage extends StatefulWidget {
  const PackagePage({super.key});

  @override
  State<StatefulWidget> createState() => _PackagePageState();
}

/*
* 打包管理页-状态
* @author wuxubaiyang
* @Time 2022/11/10 10:41
*/
class _PackagePageState extends LogicState<PackagePage, _PackagePageLogic> {
  @override
  _PackagePageLogic initLogic() => _PackagePageLogic();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeManage.currentTheme.navigationPaneTheme.backgroundColor,
      child: ValueListenableBuilder<int>(
        valueListenable: logic.pageIndexController,
        builder: (_, pageIndex, __) {
          return TabView(
            currentIndex: pageIndex,
            closeButtonVisibility: CloseButtonVisibilityMode.never,
            onChanged: (i) => logic.pageIndexController.setValue(i),
            tabs: [
              Tab(
                text: const Text('任务队列'),
                icon: const Icon(FluentIcons.task_list),
                body: PackageTaskPage(
                  onProjectCacheLoad: logic.loadProjectInfo,
                ),
              ),
              Tab(
                text: const Text('历史记录'),
                icon: const Icon(FluentIcons.history),
                body: PackageRecordPage(
                  onProjectCacheLoad: logic.loadProjectInfo,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/*
* 打包管理页-逻辑
* @author wuxubaiyang
* @Time 2022/11/10 10:41
*/
class _PackagePageLogic extends BaseLogic {
  // 分页下标管理
  final pageIndexController = ValueChangeNotifier<int>(0);

  // 缓存加载过的项目表
  final _cacheProjectInfo = <int, ProjectModel?>{};

  // 获取项目信息
  Future<ProjectModel?> loadProjectInfo(int id) async {
    if (_cacheProjectInfo.containsKey(id)) {
      return _cacheProjectInfo[id];
    }
    final t = dbManage.loadProject(id);
    if (t == null) return null;
    final p = ProjectModel(project: t);
    if (await p.update(simple: true)) {
      return _cacheProjectInfo[id] = p;
    }
    return null;
  }

  @override
  void dispose() {
    pageIndexController.dispose();
    super.dispose();
  }
}
