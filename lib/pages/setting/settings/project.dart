import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/manager/db.dart';
import 'package:flutter_platform_manage/utils/script_handle.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:isar/isar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_platform_manage/model/db/environment.dart';
import 'package:flutter_platform_manage/pages/setting/index.dart';
import 'package:flutter_platform_manage/widgets/dialog/env_import.dart';

/*
* 项目相关设置
* @author wuxubaiyang
* @Time 2022-07-25 17:22:18
*/
class ProjectSettings extends StatefulWidget {
  const ProjectSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProjectSettingsState();
}

/*
* 项目相关设置-状态
* @author wuxubaiyang
* @Time 2022-07-25 17:22:43
*/
class _ProjectSettingsState
    extends BaseSettingsState<ProjectSettings, _ProjectSettingsLogic> {
  @override
  _ProjectSettingsLogic initLogic() => _ProjectSettingsLogic();

  @override
  List<Widget> get loadSettingList => [
        _buildEnvironmentInfo(),
        _buildAppSourceInfo(),
      ];

  // 构建环境列表设置项
  Widget _buildEnvironmentInfo() {
    return buildItem(
      child: Expander(
        trailing: IconButton(
          icon: const Icon(FluentIcons.add),
          onPressed: () => EnvImportDialog.show(context),
        ),
        header: const Text('Flutter环境列表'),
        content: _buildEnvironmentList(),
      ),
    );
  }

  // 构建环境列表
  Widget _buildEnvironmentList() {
    return StreamBuilder<List<Environment>>(
      stream: dbManage.watchEnvironmentList(
        fireImmediately: true,
      ),
      builder: (_, snap) {
        if (snap.hasData) {
          final envList = snap.data ?? [];
          return ListView.separated(
            shrinkWrap: true,
            itemCount: envList.length,
            separatorBuilder: (_, i) => const Divider(),
            itemBuilder: (_, i) {
              final item = envList[i];
              return _buildEnvironmentListItem(item);
            },
          );
        }
        return const Center(
          child: ProgressRing(),
        );
      },
    );
  }

  // 构建环境列表子项
  Widget _buildEnvironmentListItem(Environment item) {
    return ListTile(
      title: Text('Flutter · ${item.flutter} · ${item.channel}'),
      subtitle: Text('Dart · ${item.dart}'),
      trailing: Row(
        children: [
          IconButton(
            icon: const Icon(FluentIcons.refresh),
            onPressed: () => Utils.showLoading<Environment>(
              context,
              loadFuture: ScriptHandle.loadFlutterEnv(item.path, oldEnv: item),
            ).then(logic.updateEnv),
          ),
          IconButton(
            icon: const Icon(FluentIcons.info),
            onPressed: () => _showEnvironmentItemInfo(item),
          ),
        ],
      ),
    );
  }

  // 展示环境配置详情
  Future<void> _showEnvironmentItemInfo(Environment item) {
    return showDialog(
      context: context,
      builder: (_) {
        return ContentDialog(
          content: Text(
            'Flutter · ${item.flutter} · ${item.channel}\n'
            'Dart · ${item.dart}\n'
            '${item.path}',
          ),
          actions: [
            TextButton(
              child: const Text('确定'),
              onPressed: () => Navigator.maybePop(context),
            ),
          ],
        );
      },
    );
  }

  // 构建应用源码说明文档
  Widget _buildAppSourceInfo() {
    return buildItem(
      child: Button(
        style: ButtonStyle(
          padding: ButtonState.all(
            const EdgeInsets.all(14),
          ),
        ),
        child: const Text(
          '查看本项目源码以及说明文档',
          textAlign: TextAlign.start,
        ),
        onPressed: () => logic.openAppSource(context).then((v) {
          if (!v) Utils.showSnack(context, '网址打开失败');
        }),
      ),
    );
  }
}

/*
* 项目相关设置-逻辑
* @author wuxubaiyang
* @Time 2022/11/9 12:55
*/
class _ProjectSettingsLogic extends BaseSettingsLogic {
  // 更新环境信息
  Future<Id?> updateEnv(Environment? env) async {
    if (env == null) return null;
    return dbManage.updateEnvironment(env);
  }

  // 打开项目源码
  Future<bool> openAppSource(BuildContext context) {
    final uri = Uri.parse(Common.appSourceUrl);
    return launchUrl(uri);
  }
}
