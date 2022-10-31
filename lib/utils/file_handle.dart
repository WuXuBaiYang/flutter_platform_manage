import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:xml/xml.dart';

// 文件写入事件回调
typedef FileWriteCallback<T extends FileHandle> = Future<void> Function(
    T handle);

/*
* 文件信息处理
* @author wuxubaiyang
* @Time 5/20/2022 11:15 AM
*/
class FileHandle {
  // 当前要处理的文件对象
  final File _file;

  // 文件内容编码
  final Encoding encoding;

  // 从文件路径创建文件处理对象
  FileHandle.from(
    String filePath, {
    this.encoding = utf8,
  }) : _file = File(filePath);

  // 判断文件是否存在
  bool get existAsync => _file.existsSync();

  // 缓存文件的字符串内容
  String? _fileContent;

  // 获取文件的字符串内容
  Future<String> get fileContent async =>
      _fileContent ??= await _file.readAsString(encoding: encoding);

  // 使用正则匹配字符串
  Future<String> stringMatch(RegExp reg, {RegExp? re}) async {
    final v = reg.stringMatch(await fileContent) ?? '';
    return null != re ? v.replaceAll(re, '') : v;
  }

  // 使用正则匹配字符串集合
  Future<List<String>> stringListMatch(RegExp reg,
      {int group = 0, RegExp? re}) async {
    return reg.allMatches(await fileContent).map((e) {
      final v = e.group(group) ?? '';
      return null != re ? v.replaceAll(re, '') : v;
    }).toList();
  }

  // 使用正则替换目标参数并返回文件内容
  Future<void> replace(RegExp reg, String value) async {
    final content = await fileContent;
    if (reg.hasMatch(content)) {
      _fileContent = content.replaceAll(reg, value);
    }
  }

  // 文件写入事件
  Future<bool> fileWrite(FileWriteCallback callback) async {
    await callback(this);
    return commit();
  }

  // 提交附件
  Future<bool> commit() async {
    try {
      _file.writeAsStringSync(
        await fileContent,
        encoding: encoding,
      );
    } catch (e) {
      return false;
    }
    return true;
  }
}

/*
* 作为xml文件处理
* @author wuxubaiyang
* @Time 2022-08-08 14:44:11
*/
class FileHandleXML extends FileHandle {
  FileHandleXML.from(super.filePath, {Encoding encoding = utf8})
      : super.from(encoding: encoding);

  // 缓存文件的解析对象
  XmlDocument? _xmlDocument;

  // 获取xml文件的解析对象
  Future<XmlDocument> get xmlDocument async =>
      _xmlDocument ??= XmlDocument.parse(await fileContent);

  // 根据标签名获取对应标签集合
  Future<List<XmlElement>> _xmlFindAll(String elName,
      {String? namespace}) async {
    return (await xmlDocument)
        .findAllElements(elName, namespace: namespace)
        .toList();
  }

  // 获取xml文件首个目标标签的属性值
  Future<String> singleAtt(String elName,
      {required String attName, String? namespace}) async {
    try {
      return (await attList(
        elName,
        attName: attName,
        namespace: namespace,
      ))
          .first;
    } catch (e) {
      // 文件选择异常
    }
    return '';
  }

  // 获取xml文件所有目标标签的属性值集合
  Future<List<String>> attList(String elName,
      {required String attName, String? namespace}) async {
    return (await _xmlFindAll(elName, namespace: namespace))
        .map((e) => e.getAttribute(attName) ?? '')
        .toList();
  }

  // 获取xml文件标签文本匹配的标签对象
  Future<XmlElement?> matchTextEl(String elName,
      {required String target, String? namespace}) async {
    try {
      return (await _xmlFindAll(elName, namespace: namespace))
          .firstWhere((e) => e.text.contains(target));
    } catch (e) {
      // 未找到标签
    }
    return null;
  }

  // 获取xml文件标签的文本值
  Future<List<String>> elTextList(String elName, {String? namespace}) async {
    return (await _xmlFindAll(elName, namespace: namespace))
        .map((e) => e.text)
        .toList();
  }

  // 修改xml文件标签属性值
  Future<void> setElAtt(String elName,
      {required String attName,
      required String value,
      String? namespace}) async {
    for (final it in await _xmlFindAll(elName, namespace: namespace)) {
      it.setAttribute(attName, value);
    }
  }

  // 修改xml文件标签的文本值
  Future<void> setElText(String elName,
      {required String value, String? namespace}) async {
    for (final it in await _xmlFindAll(elName, namespace: namespace)) {
      it.innerText = value;
    }
  }

  // 插入xml文件目标标签下元素
  Future<void> insertEl(
    String elName, {
    required List<XmlNode> nodes,
    int index = 0,
    String? namespace,
  }) async {
    try {
      final el = (await xmlDocument).getElement(elName);
      el?.children.insertAll(index, nodes);
    } catch (e) {
      // 插入失败
    }
  }

  // 删除xml文件指定标签
  Future<void> removeEl(String elName,
      {required String target, String? namespace}) async {
    for (final it in await _xmlFindAll(target, namespace: namespace)) {
      it.children.removeWhere((e) {
        if (e.nodeType == XmlNodeType.ELEMENT) {
          final el = e as XmlElement;
          return el.name.toString() == elName;
        }
        return false;
      });
    }
  }

  // 文件写入事件
  @override
  Future<bool> fileWrite(FileWriteCallback<FileHandleXML> callback) async {
    await callback(this);
    return commit();
  }

  // 文件提交操作
  @override
  Future<bool> commit({bool indentAtt = false}) async {
    if (null != _xmlDocument) {
      _fileContent = _xmlDocument?.toXmlString(
        pretty: true,
        indent: '\t',
        newLine: '\n',
        indentAttribute: (v) => indentAtt,
      );
    }
    return super.commit();
  }
}

/*
* 作为PList文件处理
* @author wuxubaiyang
* @Time 2022-08-08 14:44:11
*/
class FileHandlePList extends FileHandleXML {
  FileHandlePList.from(super.filePath, {Encoding encoding = utf8})
      : super.from(encoding: encoding);

  // 缓存pList转化后的map
  Map<String, dynamic>? _plistMap;

  // 获取plist map
  Future<Map<String, dynamic>> get plistMap async =>
      _plistMap ??= _convertDictXml2Map(await _dictXml);

  // 获取xml结构中的dict节点
  Future<XmlElement?> get _dictXml async =>
      (await xmlDocument).getElement('plist')?.getElement('dict');

  // 获取值
  Future<dynamic> getValue(String key, {dynamic def}) async =>
      (await plistMap)[key] ?? def;

  // 根据key模糊搜索key列表
  Future<List<String>> getKeyList({required String includeKey}) async {
    final map = await plistMap;
    var list = <String>[];
    for (final k in map.keys) {
      if (!k.contains(includeKey)) continue;
      list.add(k);
    }
    return list;
  }

  // 根据key模糊搜索值列表
  Future<List<T>> getValueList<T>({required String includeKey}) async {
    final map = await plistMap;
    var list = <T>[];
    for (var k in map.keys) {
      if (!k.contains(includeKey)) continue;
      list.add(map[k]);
    }
    return list;
  }

  // 设置值
  Future<void> setValue(String key, dynamic value) async =>
      (await plistMap)[key] = value;

  // 添加值集合
  Future<void> insertValueMap({required Map<String, dynamic> valueMap}) async =>
      (await plistMap).addAll(valueMap);

  // 删除包含key的所有字段
  Future<void> removeValueList({required String includeKey}) async =>
      (await plistMap).removeWhere((key, value) => key.contains(includeKey));

  // 文件写入事件
  @override
  Future<bool> fileWrite(FileWriteCallback<FileHandlePList> callback) async {
    await callback(this);
    return commit();
  }

  // 文件提交操作
  @override
  Future<bool> commit({bool indentAtt = false}) async {
    (await _dictXml)?.replace(_convertMap2DictXml(await plistMap));
    return super.commit(indentAtt: indentAtt);
  }

  // 从xml转换为
  Map<String, dynamic> _convertDictXml2Map(XmlElement? element) {
    if (null == element) return {};
    var temp = <String, dynamic>{};
    for (var child in element.findElements('key')) {
      var next = child.nextElementSibling;
      var key = child.text;
      if (next?.name == XmlName('string')) {
        // 解析字符串值
        temp[key] = next?.text ?? '';
      } else if (next?.name == XmlName('array')) {
        // 解析集合值
        temp[key] = next?.childElements.map((e) {
          if (e.name == XmlName('string')) {
            // 集合中的字符串值
            return e.text;
          }
          return '';
        }).toList();
      } else if (next?.name == XmlName('true')) {
        // 解析布尔值true
        temp[key] = true;
      } else if (next?.name == XmlName('false')) {
        // 解析布尔值false
        temp[key] = false;
      }
    }
    return temp;
  }

  // 将pList的map结构转换为xml结构
  XmlElement _convertMap2DictXml(Map<String, dynamic> map) {
    var children = <XmlNode>[];
    for (var k in map.keys) {
      var v = map[k];
      children.add(XmlElement(XmlName('key'), [], [XmlText(k)]));
      if (v is String) {
        // 封装字符串值
        children.add(XmlElement(XmlName('string'), [], [XmlText(v)]));
      } else if (v is bool) {
        // 封装布尔值
        children.add(XmlElement(XmlName('$v')));
      } else if (v is List) {
        // 封装集合值
        children.add(XmlElement(
          XmlName('array'),
          [],
          List.generate(v.length, (i) {
            var it = v[i];
            if (it is String) {
              // 封装集合中的字符串值
              return XmlElement(XmlName('string'), [], [XmlText(it)]);
            }
            return XmlElement(XmlName('unknown'));
          }),
        ));
      }
    }
    return XmlElement(XmlName('dict'), [], children);
  }
}
