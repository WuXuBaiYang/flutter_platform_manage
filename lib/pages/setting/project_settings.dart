import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_platform_manage/manager/db_manage.dart';
import 'package:flutter_platform_manage/model/db/environment.dart';
import 'package:flutter_platform_manage/pages/setting/setting.dart';
import 'package:flutter_platform_manage/widgets/env_import_dialog.dart';

/*
* 项目相关设置
* @author JTech JH
* @Time 2022-07-25 17:22:18
*/
class ProjectSettings extends StatefulWidget {
  const ProjectSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProjectSettingsState();
}

/*
* 项目相关设置-状态
* @author JTech JH
* @Time 2022-07-25 17:22:43
*/
class _ProjectSettingsState extends BaseSettingsState<ProjectSettings> {
  @override
  List<Widget> get loadSettingList => [
        buildEnvironmentList(),
        buildAppSourceInfo(),
      ];

  // 构建环境列表设置项
  Widget buildEnvironmentList() {
    return FutureBuilder<List<Environment>>(
      future: Future.value(dbManage.loadAllEnvironments().toList()),
      builder: (_, snap) {
        if (snap.hasData) {
          return buildItem(
            Expander(
              trailing: IconButton(
                icon: const Icon(FluentIcons.add),
                onPressed: () {
                  EnvImportDialog.show(context).then((value) {
                    if (null != value) {
                      setState(() {});
                    }
                  });
                },
              ),
              header: const Text('Flutter环境列表'),
              content: ListView.separated(
                shrinkWrap: true,
                itemCount: snap.data!.length,
                separatorBuilder: (_, i) => const Divider(),
                itemBuilder: (_, i) {
                  final item = snap.data![i];
                  return ListTile(
                    title: Text('Flutter · ${item.flutter} · ${item.channel}'),
                    subtitle: Text('Dart · ${item.dart}'),
                    trailing: IconButton(
                      icon: const Icon(FluentIcons.info),
                      onPressed: () {
                        showDialog(
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
                      },
                    ),
                  );
                },
              ),
            ),
          );
        }
        return const Center(
          child: ProgressRing(),
        );
      },
    );
  }

  // 构建应用源码说明文档
  Widget buildAppSourceInfo() {
    return buildItem(
      Button(
        style: ButtonStyle(
          padding: ButtonState.all(
            const EdgeInsets.all(14),
          ),
        ),
        child: const Text(
          '查看本项目源码以及说明文档',
          textAlign: TextAlign.start,
        ),
        onPressed: () async {
          final uri = Uri.parse(Common.appSourceUrl);
          if (!await launchUrl(uri)) {
            Utils.showSnack(context, '网址打开失败');
          }
        },
      ),
    );
  }
}
