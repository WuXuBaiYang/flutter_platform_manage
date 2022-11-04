import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/model/platform/platform.dart';
import 'package:flutter_platform_manage/utils/log.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/card_item.dart';
import 'package:flutter_platform_manage/widgets/important_option_dialog.dart';
import 'package:flutter_platform_manage/widgets/logic_state.dart';
import 'package:flutter_platform_manage/widgets/project_logo.dart';
import 'package:flutter_platform_manage/widgets/project_logo_dialog.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/*
* 平台页面基类
* @author wuxubaiyang
* @Time 2022-07-29 16:09:36
*/
abstract class BasePlatformPage<T extends BasePlatform> extends StatefulWidget {
  final T platformInfo;

  const BasePlatformPage({
    Key? key,
    required this.platformInfo,
  }) : super(key: key);
}

/*
* 平台状态基类
* @author wuxubaiyang
* @Time 2022-07-26 17:54:08
*/
abstract class BasePlatformPageState<T extends BasePlatformPage,
    C extends BasePlatformPageLogic> extends LogicState<T, C> {
  @override
  Widget build(BuildContext context) {
    final itemList = loadItemList(context);
    if (itemList.isEmpty) return const Center(child: Text('功能开发中'));
    return PrimaryScrollController(
      controller: ScrollController(),
      child: ScaffoldPage(
        padding: EdgeInsets.zero,
        header: _buildPageHeader(),
        content: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: _buildForm(itemList),
          ),
        ),
      ),
    );
  }

  // 构建页面头部
  Widget _buildPageHeader() {
    return PageHeader(
      padding: 0,
      title: Text(
        Utils.toBeginningOfSentenceCase(
          '${logic.platformName}平台',
        ),
      ),
      commandBar: CommandBarCard(
        child: CommandBar(
          overflowBehavior: CommandBarOverflowBehavior.noWrap,
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.save),
              label: const Text('保存'),
              onPressed: () => logic.submit().then((v) {
                Utils.showSnack(context, v ? '保存成功' : '保存失败');
              }),
            )
          ],
        ),
      ),
    );
  }

  // 构建表单
  Widget _buildForm(List<Widget> itemList) {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: logic.formKey,
      onWillPop: () async {
        if (logic.hasChange()) {
          ImportantOptionDialog.show(
            context,
            title: '${logic.platformName}平台未保存',
            message: '继续退出将丢失已编辑的信息',
            middle: Button(
              child: const Text('保存'),
              onPressed: () => logic.submit().then((v) {
                Navigator.pop(context);
                if (v) Navigator.pop(context);
              }),
            ),
            confirm: '不保存',
            onConfirmTap: () => Navigator.pop(context),
          );
          return false;
        }
        return true;
      },
      child: StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 14,
        children: itemList,
      ),
    );
  }

  // 构建平台子项菜单
  List<Widget> loadItemList(BuildContext context);

  // 元素高度的基本高度
  final _itemSize = 70.0;

  // 构建平台参数设置项基础结构
  Widget buildItem({required Widget child, int times = 1}) {
    return StaggeredGridTile.extent(
      crossAxisCellCount: 1,
      mainAxisExtent: _itemSize * times,
      child: Container(
        child: child,
      ),
    );
  }

  // 图标所需最小文件尺寸对照表
  final _minFileSizeMap = <PlatformType, Size>{
    PlatformType.android: const Size.square(192),
    PlatformType.ios: const Size.square(1024),
    PlatformType.web: const Size.square(512),
    PlatformType.linux: const Size.square(1024),
    PlatformType.macos: const Size.square(1024),
    PlatformType.windows: const Size.square(256),
  };

  // 构建应用图标编辑项
  Widget buildAppLogo() {
    final info = logic.platformInfo;
    final icon = info.singleIcon;
    return buildItem(
      child: CardItem(
        child: ListTile(
          leading: ProjectLogo(
            projectIcon: icon,
            logoSize: ProjectLogoSize.small,
          ),
          title: const Text('图标管理'),
          subtitle: Text('x${info.projectIcons.length}'),
          trailing: const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Icon(FluentIcons.settings),
          ),
          onPressed: () {
            final info = logic.platformInfo;
            ProjectLogoDialog.show(
              context,
              initialPlatforms: [info],
              minFileSize: _minFileSizeMap[info.type]!,
            ).then((v) {
              if (v ?? false) {
                Utils.showSnack(context, '图标修改成功');
              }
            });
          },
        ),
      ),
    );
  }
}

/*
* 平台基类-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 15:35
*/
abstract class BasePlatformPageLogic<T extends BasePlatform> extends BaseLogic {
  // 表单key
  final formKey = GlobalKey<FormState>();

  // 平台信息
  final T platformInfo;

  // 记录最初的hashCode
  late int _hashCode;

  BasePlatformPageLogic(
    this.platformInfo,
  ) : _hashCode = platformInfo.hashCode;

  // 获取平台名称并首字母大写
  String get platformName =>
      Utils.toBeginningOfSentenceCase(platformInfo.type.name);

  // 比对hashCode
  bool hasChange() => _hashCode != platformInfo.hashCode;

  // 执行提交操作
  Future<bool> submit() async {
    try {
      final state = formKey.currentState;
      if (null != state && state.validate()) {
        state.save();
        final result = await platformInfo.commit();
        if (result) _hashCode = platformInfo.hashCode;
        return result;
      }
    } catch (e) {
      LogTool.e('${platformInfo.type.name}平台提交失败：', error: e);
    }
    return false;
  }
}
