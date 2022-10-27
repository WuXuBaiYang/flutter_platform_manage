import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/model/platform/base_platform.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/widgets/important_option_dialog.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/*
* 平台页面基类
* @author wuxubaiyang
* @Time 2022-07-29 16:09:36
*/
abstract class BasePlatformPage<T extends BasePlatform,
    L extends BasePlatformPageLogic> extends StatefulWidget {
  // 平台对象
  final T platformInfo;

  // 逻辑管理
  final L logic;

  const BasePlatformPage({
    Key? key,
    required this.platformInfo,
    required this.logic,
  }) : super(key: key);
}

/*
* 平台状态基类
* @author wuxubaiyang
* @Time 2022-07-26 17:54:08
*/
abstract class BasePlatformPageState<T extends BasePlatformPage>
    extends State<T> {
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
          '${widget.platformInfo.type.name}平台',
        ),
      ),
      commandBar: CommandBarCard(
        child: CommandBar(
          overflowBehavior: CommandBarOverflowBehavior.noWrap,
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.save),
              label: const Text('保存'),
              onPressed: () =>
                  widget.logic.submit(widget.platformInfo).then((v) {
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
      key: widget.logic.formKey,
      onWillPop: () async {
        if (widget.logic.hasChange(widget.platformInfo.hashCode)) {
          ImportantOptionDialog.show(
            context,
            title: '${widget.platformInfo.type.name.toUpperCase()}平台未保存',
            message: '继续退出将丢失已编辑的信息',
            middle: Button(
              child: const Text('保存'),
              onPressed: () =>
                  widget.logic.submit(widget.platformInfo).then((v) {
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

  @override
  void dispose() {
    widget.logic.dispose();
    super.dispose();
  }
}

/*
* 平台基类-逻辑
* @author wuxubaiyang
* @Time 2022/10/27 15:35
*/
abstract class BasePlatformPageLogic extends BaseLogic {
  // 表单key
  final formKey = GlobalKey<FormState>();

  // 记录最初的hashCode
  late int _hashCode;

  BasePlatformPageLogic(this._hashCode);

  // 比对hashCode
  bool hasChange(int hashCode) => _hashCode != hashCode;

  // 执行提交操作
  Future<bool> submit<T extends BasePlatform>(T platformInfo) async {
    try {
      final state = formKey.currentState;
      if (null != state && state.validate()) {
        state.save();
        if (await platformInfo.commit()) {
          _hashCode = platformInfo.hashCode;
        }
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
