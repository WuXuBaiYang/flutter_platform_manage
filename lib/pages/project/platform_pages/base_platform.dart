import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/model/platform/base_platform.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/important_option_dialog.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/*
* 平台页面基类
* @author JTech JH
* @Time 2022-07-29 16:09:36
*/
abstract class BasePlatformPage<T extends BasePlatform> extends StatefulWidget {
  // 平台对象
  final T platformInfo;

  const BasePlatformPage({
    Key? key,
    required this.platformInfo,
  }) : super(key: key);
}

/*
* 平台状态基类
* @author JTech JH
* @Time 2022-07-26 17:54:08
*/
abstract class BasePlatformPageState<T extends BasePlatformPage>
    extends State<T> {
  // 表单key
  final _formKey = GlobalKey<FormState>();

  // 记录最初的hashCode
  late int _hashCode;

  @override
  void initState() {
    super.initState();
    // 基础默认hashCode
    _hashCode = widget.platformInfo.hashCode;
  }

  @override
  Widget build(BuildContext context) {
    final itemList = loadItemList(context);
    if (itemList.isEmpty) return const Center(child: Text("功能开发中"));
    return PrimaryScrollController(
      controller: ScrollController(),
      child: ScaffoldPage(
        padding: EdgeInsets.zero,
        header: PageHeader(
          padding: 0,
          title: Text(
            Utils.toBeginningOfSentenceCase(
              "${widget.platformInfo.type.name}平台",
            ),
          ),
          commandBar: CommandBarCard(
            elevation: 0,
            child: CommandBar(
              overflowBehavior: CommandBarOverflowBehavior.noWrap,
              primaryItems: [
                CommandBarButton(
                  icon: const Icon(FluentIcons.save),
                  label: const Text("保存"),
                  onPressed: () => submit(),
                )
              ],
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: _formKey,
              onWillPop: () async {
                if (_hashCode != widget.platformInfo.hashCode) {
                  ImportantOptionDialog.show(
                    context,
                    title:
                        "${widget.platformInfo.type.name.toUpperCase()}平台未保存",
                    message: "继续退出将丢失已编辑的信息",
                    middle: Button(
                      child: const Text("保存"),
                      onPressed: () => submit().then((v) {
                        Navigator.pop(context);
                        if (v) Navigator.pop(context);
                      }),
                    ),
                    confirm: "不保存",
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
            ),
          ),
        ),
      ),
    );
  }

  // 构建平台子项菜单
  List<Widget> loadItemList(BuildContext context);

  // 执行提交操作
  Future<bool> submit() {
    final state = _formKey.currentState;
    if (null != state && state.validate()) {
      state.save();
      return widget.platformInfo.commit().whenComplete(() {
        _hashCode = widget.platformInfo.hashCode;
        Utils.showSnack(context, "保存成功");
      });
    }
    return Future.value(false).whenComplete(() {
      Utils.showSnack(context, "保存失败");
    });
  }

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
}
