import 'package:flutter/foundation.dart';

/*
* 数据变化监听
* @author wuxubaiyang
* @Time 2022/3/31 15:27
*/
class ValueChangeNotifier<V> extends ChangeNotifier
    implements ValueListenable<V> {
  // 参数数据
  V _value;

  ValueChangeNotifier(this._value);

  @override
  V get value => _value;

  // 赋值并刷新
  bool setValue(V newValue, {bool update = false}) {
    if (!update && newValue == _value) return false;
    _value = newValue;
    notifyListeners();
    return true;
  }

  @override
  String toString() => '${describeIdentity(this)}($_value)';
}

/*
* 集合数据变化监听
* @author wuxubaiyang
* @Time 2022/3/31 15:27
*/
class ListValueChangeNotifier<V> extends ValueChangeNotifier<List<V>> {
  // 是否允许值重复
  final bool deduplication;

  ListValueChangeNotifier(
    List<V> value, {
    this.deduplication = false,
  }) : super(value);

  ListValueChangeNotifier.empty({
    this.deduplication = false,
  }) : super([]);

  // 获取数据长度
  int get length => value.length;

  // 判断是否为空
  bool get isEmpty => value.isEmpty;

  // 判断是否非空
  bool get isNotEmpty => value.isNotEmpty;

  // 清除数据
  void clear() {
    value.clear();
    notifyListeners();
  }

  // 获取子项
  V? getItem(int index) {
    if (index >= 0 && value.length > index) {
      return value[index];
    }
    return null;
  }

  // 判断数据是否存在
  bool contains(V item) => value.contains(item);

  // 添加数据
  void addValue(V newValue, {bool notify = true}) {
    if (_checkDeduplication(newValue)) {
      value.add(newValue);
    }
    if (notify) notifyListeners();
  }

  // 添加多条数据
  void addValues(List<V> newValue, {bool notify = true}) {
    if (deduplication) newValue.removeWhere((e) => value.contains(e));
    value.addAll(newValue);
    if (notify) notifyListeners();
  }

  // 插入数据
  void insertValue(int index, V newValue, {bool notify = true}) {
    if (_checkDeduplication(newValue)) {
      value.insert(index, newValue);
    }
    if (notify) notifyListeners();
  }

  // 插入多条数据
  void insertValues(int index, List<V> newValue, {bool notify = true}) {
    if (deduplication) newValue.removeWhere((e) => value.contains(e));
    value.insertAll(index, newValue);
    if (notify) notifyListeners();
  }

  // 更新/添加数据
  void putValue(int index, V item, {bool notify = true}) {
    if (_checkDeduplication(item)) {
      value[index] = item;
    }
    if (notify) notifyListeners();
  }

  // 移除数据
  bool removeValue(V item, {bool notify = true}) {
    final result = value.remove(item);
    if (notify) notifyListeners();
    return result;
  }

  // 移除多条数据
  void removeValues(List<V> items, {bool notify = true}) {
    value.removeWhere((e) => items.contains(e));
    if (notify) notifyListeners();
  }

  // 移除下标数据
  V? removeValueAt(int index, {bool notify = true}) {
    final result = value.removeAt(index);
    if (notify) notifyListeners();
    return result;
  }

  // 检查去重状态
  bool _checkDeduplication(V v) =>
      !deduplication || (deduplication && !value.contains(v));

  @override
  String toString() => '${describeIdentity(this)}($value)';

  @override
  void dispose() {
    value.clear();
    super.dispose();
  }
}

/*
* 表数据变化监听
* @author wuxubaiyang
* @Time 2022/3/31 15:27
*/
class MapValueChangeNotifier<K, V> extends ValueChangeNotifier<Map<K, V>> {
  MapValueChangeNotifier(Map<K, V> value) : super(value);

  MapValueChangeNotifier.empty() : this({});

  // 清除数据
  void clear() {
    value.clear();
    notifyListeners();
  }

  // 添加数据
  void putValue(K k, V v, {bool notify = true}) {
    value.addAll({k: v});
    if (notify) notifyListeners();
  }

  // 移除数据
  V? removeValue(K key, {bool notify = true}) {
    final result = value.remove(key);
    if (notify) notifyListeners();
    return result;
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';

  @override
  void dispose() {
    value.clear();
    super.dispose();
  }
}
