import 'dart:async';
import 'dart:convert';
import 'package:flutter_platform_manage/manager/base_manage.dart';
import 'package:flutter_platform_manage/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
* 缓存管理
* @author JTech JH
* @Time 2022/3/29 10:29
*/
class JCacheManage extends BaseManage {
  // 时效字段后缀
  final String _expirationSuffix = "expiration";

  static final JCacheManage _instance = JCacheManage._internal();

  factory JCacheManage() => _instance;

  JCacheManage._internal();

  // sp存储方法
  late SharedPreferences _sp;

  @override
  Future<void> init() async {
    // 创建sp单例
    _sp = await SharedPreferences.getInstance();
  }

  // 获取int类型
  int? getInt(String key, {int? def}) {
    if (!_checkExpiration(key)) return def;
    return _sp.getInt(key) ?? def;
  }

  // 获取bool类型
  bool? getBool(String key, {bool? def}) {
    if (!_checkExpiration(key)) return def;
    return _sp.getBool(key) ?? def;
  }

  // 获取double类型
  double? getDouble(String key, {double? def}) {
    if (!_checkExpiration(key)) return def;
    return _sp.getDouble(key) ?? def;
  }

  // 获取String类型
  String? getString(String key, {String? def}) {
    if (!_checkExpiration(key)) return def;
    return _sp.getString(key) ?? def;
  }

  // 获取StringList类型
  List<String>? getStringList(String key, {List<String>? def}) {
    if (!_checkExpiration(key)) return def;
    return _sp.getStringList(key) ?? def;
  }

  // 获取json类型
  dynamic getJson(String key, {dynamic def}) {
    if (!_checkExpiration(key)) return def;
    var value = _sp.getString(key);
    if (null == value) return def;
    return jsonDecode(value) ?? def;
  }

  // 设置int类型
  Future<bool> setInt(
    String key,
    int value, {
    Duration? expiration,
  }) async {
    if (!await _setupExpiration(key, expiration: expiration)) return false;
    return _sp.setInt(key, value);
  }

  // 设置double类型
  Future<bool> setDouble(
    String key,
    double value, {
    Duration? expiration,
  }) async {
    if (!await _setupExpiration(key, expiration: expiration)) return false;
    return _sp.setDouble(key, value);
  }

  // 设置bool类型
  Future<bool> setBool(
    String key,
    bool value, {
    Duration? expiration,
  }) async {
    if (!await _setupExpiration(key, expiration: expiration)) return false;
    return _sp.setBool(key, value);
  }

  // 设置string类型
  Future<bool> setString(
    String key,
    String value, {
    Duration? expiration,
  }) async {
    if (!await _setupExpiration(key, expiration: expiration)) return false;
    return _sp.setString(key, value);
  }

  // 设置List<string>类型
  Future<bool> setStringList(
    String key,
    List<String> value, {
    Duration? expiration,
  }) async {
    if (!await _setupExpiration(key, expiration: expiration)) return false;
    return _sp.setStringList(key, value);
  }

  // 设置JsonMap类型
  Future<bool> setJsonMap<K, V>(
    String key,
    Map<K, V> value, {
    Duration? expiration,
  }) async {
    if (!await _setupExpiration(key, expiration: expiration)) return false;
    return _sp.setString(key, jsonEncode(value));
  }

  // 设置JsonList类型
  Future<bool> setJsonList<V>(
    String key,
    List<V> value, {
    Duration? expiration,
  }) async {
    if (!await _setupExpiration(key, expiration: expiration)) return false;
    return _sp.setString(key, jsonEncode(value));
  }

  // 移除字段
  Future<bool> remove(String key) {
    return _sp.remove(key);
  }

  // 清空缓存的所有字段
  Future<bool> removeAll() {
    return _sp.clear();
  }

  // 检查有效期
  bool _checkExpiration(String key) {
    var expirationKey = _getExpirationKey(key);
    if (_sp.containsKey(expirationKey)) {
      var expirationTime =
          DateTime.fromMillisecondsSinceEpoch(_sp.getInt(expirationKey) ?? 0);
      if (expirationTime.isBefore(DateTime.now())) {
        remove(expirationKey);
        remove(key);
        return false;
      }
    }
    return true;
  }

  // 设置有效期
  Future<bool> _setupExpiration(String key, {Duration? expiration}) async {
    if (null == expiration) return true;
    var expirationKey = _getExpirationKey(key);
    var inTime = DateTime.now().add(expiration).millisecondsSinceEpoch;
    return _sp.setInt(expirationKey, inTime);
  }

  // 获取有效期的存储字段
  String _getExpirationKey(String key) {
    key = "${key}_$_expirationSuffix";
    return "${key}_${Utils.md5(key)}";
  }
}

// 单例调用
final jCache = JCacheManage();
