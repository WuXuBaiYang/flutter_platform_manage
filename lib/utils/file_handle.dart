import 'dart:convert';
import 'dart:io';
import 'package:xml/xml.dart';

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

  // 缓存文件的解析对象
  XmlDocument? _xmlDocument;

  // 获取xml文件的解析对象
  Future<XmlDocument> get xmlDocument async =>
      _xmlDocument ??= XmlDocument.parse(await fileContent);

  // 使用正则匹配字符串
  Future<String> regStringMatch(RegExp reg, {RegExp? re}) async {
    var v = reg.stringMatch(await fileContent) ?? "";
    return null != re ? v.replaceAll(re, "") : v;
  }

  // 使用正则匹配字符串集合
  Future<List<String>> regStringListMatch(RegExp reg,
      {int group = 0, RegExp? re}) async {
    return reg.allMatches(await fileContent).map((e) {
      var v = e.group(group) ?? "";
      return null != re ? v.replaceAll(re, "") : v;
    }).toList();
  }

  // 使用正则替换目标参数并返回文件内容
  Future<String> regReplace(RegExp reg, String value) async {
    var content = await fileContent;
    if (reg.hasMatch(content)) {
      content = content.replaceAll(reg, value);
    }
    return content;
  }

  // 根据标签名获取对应标签集合
  Future<List<XmlElement>> _xmlFindAll(String elName,
      {String? namespace}) async {
    return (await xmlDocument)
        .findAllElements(elName, namespace: namespace)
        .toList();
  }

  // 获取xml文件首个目标标签的属性值
  Future<String> xmlSingleTagAttribute(String elName,
      {required String attName, String? namespace}) async {
    try {
      return (await xmlTagAttributes(elName,
              attName: attName, namespace: namespace))
          .single;
    } catch (e) {
      // 文件选择异常
    }
    return "";
  }

  // 获取xml文件所有目标标签的属性值集合
  Future<List<String>> xmlTagAttributes(String elName,
      {required String attName, String? namespace}) async {
    return (await _xmlFindAll(elName, namespace: namespace))
        .map((e) => e.getAttribute(attName) ?? "")
        .toList();
  }

  // 获取xml文件标签文本匹配的标签对象
  Future<XmlElement?> xmlTagMatchTextElement(String elName,
      {required String target, String? namespace}) async {
    try {
      return (await _xmlFindAll(elName, namespace: namespace))
          .firstWhere((e) => e.text == target);
    } catch (e) {
      // 未找到标签
    }
    return null;
  }

  // 获取xml文件标签文本匹配的标签对象的同级下一个
  Future<XmlElement?> xmlTagMatchTextElementNext(String elName,
      {required String target, String? namespace}) async {
    return (await xmlTagMatchTextElement(elName,
            target: target, namespace: namespace))
        ?.nextElementSibling;
  }

  // 获取xml文件标签的文本值
  Future<List<String>> xmlTagTexts(String elName, {String? namespace}) async {
    return (await _xmlFindAll(elName, namespace: namespace))
        .map((e) => e.text)
        .toList();
  }

  // 修改xml文件标签属性值
  Future<void> xmlTagAttributesModify(String elName,
      {required String attName,
      required String value,
      String? namespace}) async {
    for (var it in await _xmlFindAll(elName, namespace: namespace)) {
      it.setAttribute(attName, value);
    }
  }

  // 修改xml文件标签的文本值
  Future<void> xmlTagTextsModify(String elName,
      {required String value, String? namespace}) async {
    for (var it in await _xmlFindAll(elName, namespace: namespace)) {
      it.innerText = value;
    }
  }

  // 插入xml文件目标标签下元素
  Future<void> xmlTagElementInsert(String elName,
      {required List<XmlNode> nodes, int index = 0, String? namespace}) async {
    try {
      var el = (await _xmlFindAll(elName, namespace: namespace)).single;
      el.children.insertAll(index, nodes);
    } catch (e) {
      // 插入失败
    }
  }

  // 删除xml文件指定标签
  Future<void> xmlTagElementsRemove(String elName, {String? namespace}) async {
    for (var it in await _xmlFindAll(elName, namespace: namespace)) {
      var p = it.parentElement;
      if (null == p) {
        _xmlDocument = null;
        _fileContent = "";
        return;
      }
      p.childElements.toList().remove(it);
    }
  }

  // 文件提交操作
  Future<bool> commit() async {
    try {
      if (null != _xmlDocument) {
        _fileContent = _xmlDocument?.toXmlString(
          pretty: true,
          indent: '\t',
        );
      }
      _file.writeAsStringSync(
        await fileContent,
        encoding: encoding,
      );
    } catch (e) {
      // 写入失败
      return false;
    }
    return true;
  }
}
