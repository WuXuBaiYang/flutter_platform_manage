import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/common/common.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/model/project.dart';
import 'package:flutter_platform_manage/widgets/important_option_dialog.dart';

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
    var settingList = loadSettingList;
    if (settingList.isEmpty) return const Center(child: Text("平台开发中"));
    return ScaffoldPage(
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
                  message: "当前页面有未保存的内容，继续退出将丢失已编辑的信息",
                  onConfirmTap: () => Navigator.pop(context),
                );
                return false;
              }
              return true;
            },
            child: Wrap(
              spacing: 14,
              runSpacing: 14,
              children: settingList,
            ),
          ),
        ),
      ),
    );
  }

  // 加载设置项集合
  List<Widget> get loadSettingList;

  // 执行提交操作
  Future<bool> submit() {
    var state = _formKey.currentState;
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

  // 设置项宽度
  final _itemSize = Common.windowMinimumSize.width / 2 - 40;

  // 构建平台参数设置项基础结构
  Widget buildItem(Widget child) {
    return SizedBox(
      width: _itemSize,
      child: child,
    );
  }
}
