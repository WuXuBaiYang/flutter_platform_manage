import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_manage/common/logic.dart';
import 'package:flutter_platform_manage/model/android_key.dart';
import 'package:flutter_platform_manage/utils/script_handle.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:flutter_platform_manage/common/logic_state.dart';
import 'package:flutter_platform_manage/widgets/thickness_divider.dart';

/*
* android签名文件生成
* @author wuxubaiyang
* @Time 2022/11/14 15:51
*/
class GenAndroidKeyDialog extends StatefulWidget {
  const GenAndroidKeyDialog({super.key});

  // 显示android签名文件生成弹窗
  static Future<String?> show(
    BuildContext context,
  ) {
    return showDialog<String>(
      context: context,
      builder: (_) => const GenAndroidKeyDialog(),
    );
  }

  @override
  State<StatefulWidget> createState() => _GenAndroidKeyDialogState();
}

/*
* android签名文件生成-状态
* @author wuxubaiyang
* @Time 2022/11/14 15:51
*/
class _GenAndroidKeyDialogState
    extends LogicState<GenAndroidKeyDialog, _GenAndroidKeyDialogLogic> {
  @override
  _GenAndroidKeyDialogLogic initLogic() => _GenAndroidKeyDialogLogic();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('生成Android签名文件'),
      content: _buildGenKeyForm(context),
      actions: _getActions(context),
    );
  }

  // 别名/密码输入校验正则
  final _inputRegExp = RegExp(r'[a-zA-Z0-9]');

  // 构建签名生成表单
  Widget _buildGenKeyForm(BuildContext context) {
    return Form(
      key: logic.formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSpaceRow(
            InfoLabel(
              label: '别名',
              child: TextFormBox(
                maxLength: 8,
                placeholder: '仅允许字母数字大小写',
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(_inputRegExp),
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return '别名不能为空';
                  return null;
                },
                onSaved: (v) {
                  if (null == v || v.isEmpty) return;
                  logic.params.alias = v;
                },
              ),
            ),
            InfoLabel(
              label: '有效期',
              child: FormField<int>(
                initialValue: 10,
                onSaved: (v) {
                  if (v == null || v < 0) return;
                  logic.params.validity = v * 365;
                },
                builder: (f) {
                  return ComboBox<int>(
                    value: f.value,
                    isExpanded: true,
                    items: List.generate(99, (i) {
                      i += 1;
                      return ComboBoxItem(
                        value: i,
                        child: Text('$i年'),
                      );
                    }),
                    onChanged: (v) => f.didChange(v),
                  );
                },
              ),
            ),
          ),
          _buildSpaceRow(
            InfoLabel(
              label: '签名密码',
              child: TextFormBox(
                maxLength: 8,
                placeholder: '最大8位',
                controller: logic.keyPassController,
                keyboardType: TextInputType.visiblePassword,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(_inputRegExp),
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return '签名密码不能为空';
                  return null;
                },
                onSaved: (v) {
                  if (null == v || v.isEmpty) return;
                  logic.params.keyPass = v;
                },
              ),
            ),
            InfoLabel(
              label: '签名文件密码',
              child: TextFormBox(
                maxLength: 8,
                placeholder: '最大8位',
                controller: logic.storePassController,
                suffix: Button(
                  child: const Text('同左'),
                  onPressed: () => logic.sameOnKeyPass(),
                ),
                keyboardType: TextInputType.visiblePassword,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(_inputRegExp),
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return '签名文件密码不能为空';
                  return null;
                },
                onSaved: (v) {
                  if (null == v || v.isEmpty) return;
                  logic.params.storePass = v;
                },
              ),
            ),
          ),
          InfoLabel(
            label: '签名文件存储路径',
            child: TextFormBox(
              readOnly: true,
              controller: logic.keyStoreController,
              placeholder: '请选择安全的位置存储',
              suffix: Button(
                onPressed: () => FilePicker.platform
                    .saveFile(
                        dialogTitle: '请选择签名文件保存目录', fileName: 'key.keystore')
                    .then((v) {
                  if (null != v) logic.keyStoreController.text = v;
                }),
                child: const Text('选择'),
              ),
              keyboardType: TextInputType.visiblePassword,
              inputFormatters: [
                FilteringTextInputFormatter.allow(_inputRegExp),
              ],
              validator: (v) {
                if (v == null || v.isEmpty) return '签名存储路径不能为空';
                return null;
              },
              onSaved: (v) {
                if (null == v || v.isEmpty) return;
                logic.params.keystore = v;
              },
            ),
          ),
          const SizedBox(height: 14),
          const ThicknessDivider(),
          const SizedBox(height: 14),
          _buildFoldDName(context),
        ],
      ),
    );
  }

  // 构建折叠的企业信息
  Widget _buildFoldDName(BuildContext context) {
    final dName = logic.params.dName;
    return Expander(
      header: const Text('企业信息'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSpaceRow(
            InfoLabel(
              label: '名称',
              child: TextFormBox(
                maxLength: 20,
                onSaved: (v) => dName.cn = v ?? '',
              ),
            ),
            InfoLabel(
              label: '组织单位',
              child: TextFormBox(
                maxLength: 20,
                onSaved: (v) => dName.ou = v ?? '',
              ),
            ),
            rowHeight: 65,
          ),
          _buildSpaceRow(
            InfoLabel(
              label: '组织',
              child: TextFormBox(
                maxLength: 20,
                onSaved: (v) => dName.o = v ?? '',
              ),
            ),
            InfoLabel(
              label: '所在城市',
              child: TextFormBox(
                maxLength: 20,
                onSaved: (v) => dName.l = v ?? '',
              ),
            ),
            rowHeight: 65,
          ),
          _buildSpaceRow(
            InfoLabel(
              label: '所在省份',
              child: TextFormBox(
                maxLength: 20,
                onSaved: (v) => dName.s = v ?? '',
              ),
            ),
            InfoLabel(
              label: '所在国家/地区',
              child: TextFormBox(
                maxLength: 20,
                onSaved: (v) => dName.c = v ?? '',
              ),
            ),
            rowHeight: 65,
          ),
        ],
      ),
    );
  }

  // 构建信息展示行
  Widget _buildSpaceRow(
    Widget first,
    Widget second, {
    double rowHeight = 85,
  }) {
    return SizedBox(
      height: rowHeight,
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(child: first),
          const SizedBox(width: 14),
          Flexible(child: second),
        ],
      ),
    );
  }

  // 动态加载操作按钮集合
  List<Widget> _getActions(BuildContext context) => [
        Button(
          child: const Text('取消'),
          onPressed: () => Navigator.maybePop(context),
        ),
        FilledButton(
          onPressed: () => Utils.showLoading<String>(
            context,
            loadFuture: logic.genAndroidKey(),
          ).then((v) {
            if (v == null || v.isEmpty) {
              return Utils.showSnack(context, '签名生成失败');
            }
            Navigator.maybePop(context, v);
          }),
          child: const Text('生成签名'),
        ),
      ];
}

/*
* android签名文件生成-逻辑
* @author wuxubaiyang
* @Time 2022/11/14 15:51
*/
class _GenAndroidKeyDialogLogic extends BaseLogic {
  // 签名密码控制器
  final keyPassController = TextEditingController();

  // 签名文件密码
  final storePassController = TextEditingController();

  // 签名文件存储路径
  final keyStoreController = TextEditingController();

  // 表单key
  final formKey = GlobalKey<FormState>();

  // 表单数据采集
  final params = AndroidKeyParams();

  // 生成android签名
  Future<String?> genAndroidKey() async {
    final state = formKey.currentState;
    if (state != null && state.validate()) {
      state.save();
      if (await ScriptHandle.genAndroidKey(params)) {
        return params.keystore;
      }
    }
    return null;
  }

  // 与签名密码一致
  void sameOnKeyPass() => storePassController.value = keyPassController.value;

  @override
  void dispose() {
    keyPassController.dispose();
    storePassController.dispose();
    keyStoreController.dispose();
    super.dispose();
  }
}
