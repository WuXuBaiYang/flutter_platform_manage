import 'dart:convert';
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
    var v = reg.stringMatch(await fileContent) ?? "";
    return null != re ? v.replaceAll(re, "") : v;
  }

  // 使用正则匹配字符串集合
  Future<List<String>> stringListMatch(RegExp reg,
      {int group = 0, RegExp? re}) async {
    return reg.allMatches(await fileContent).map((e) {
      var v = e.group(group) ?? "";
      return null != re ? v.replaceAll(re, "") : v;
    }).toList();
  }

  // 使用正则替换目标参数并返回文件内容
  Future<void> replace(RegExp reg, String value) async {
    var content = await fileContent;
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
* @author JTech JH
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
    return "";
  }

  // 获取xml文件所有目标标签的属性值集合
  Future<List<String>> attList(String elName,
      {required String attName, String? namespace}) async {
    return (await _xmlFindAll(elName, namespace: namespace))
        .map((e) => e.getAttribute(attName) ?? "")
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
    for (var it in await _xmlFindAll(elName, namespace: namespace)) {
      it.setAttribute(attName, value);
    }
  }

  // 修改xml文件标签的文本值
  Future<void> setElText(String elName,
      {required String value, String? namespace}) async {
    for (var it in await _xmlFindAll(elName, namespace: namespace)) {
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
      var el = (await xmlDocument).getElement(elName);
      el?.children.insertAll(index, nodes);
    } catch (e) {
      // 插入失败
    }
  }

  // 删除xml文件指定标签
  Future<void> removeEl(String elName,
      {required String target, String? namespace}) async {
    for (var it in await _xmlFindAll(target, namespace: namespace)) {
      it.children.removeWhere((e) {
        if (e.nodeType == XmlNodeType.ELEMENT) {
          var el = e as XmlElement;
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
* @author JTech JH
* @Time 2022-08-08 14:44:11
*/
class FileHandlePList extends FileHandle {
  FileHandlePList.from(super.filePath, {Encoding encoding = utf8})
      : super.from(encoding: encoding);

  // 缓存pList转化后的map
  Map<String, dynamic>? _plistMap;

  // 获取plist map
  Future<Map<String, dynamic>> get plistMap async {
    if (null == _plistMap) {
      var doc = XmlDocument.parse(await fileContent);
      var el = doc.findAllElements("dict").first;
      _plistMap = {};
      for (var child in el.childElements) {
        if (child.name != XmlName("key")) continue;
        var next = child.nextElementSibling;
        _plistMap![child.text] = _getDictValue(next);
      }
    }
    return _plistMap!;
  }

  // 加载pList的dict下的值
  dynamic _getDictValue(XmlElement? element) {
    if (null == element) return null;
    var name = element.name;
    if (name == XmlName("string")) {
      return element.text;
    } else if (name == XmlName("array")) {
      return element.childElements.map((e) {
        if (e.name == XmlName("string")) {
          return e.text;
        }
      });
    } else if (name == XmlName("true")) {
      return true;
    } else if (name == XmlName("false")) {
      return false;
    }
  }

  // 获取值
  Future<dynamic> getValue(String key, {dynamic def}) async =>
      (await plistMap)[key] ?? def;

  // 根据key模糊搜索值列表
  Future<List<T>> getValueList<T>({required String includeKey}) async {
    var map = await plistMap;
    var list = <T>[];
    for (var k in map.keys) {
      if (!k.contains(includeKey)) continue;
      list.add(map[k]);
    }
    return list;
  }

  // 文件写入事件
  @override
  Future<bool> fileWrite(FileWriteCallback<FileHandlePList> callback) async {
    await callback(this);
    return commit();
  }

  // 文件提交操作
  @override
  Future<bool> commit() async {
    ///
    return super.commit();
  }
}
