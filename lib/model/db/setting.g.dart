// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Setting extends _Setting with RealmEntity, RealmObjectBase, RealmObject {
  Setting(
    String primaryKey,
  ) {
    RealmObjectBase.set(this, 'primaryKey', primaryKey);
  }

  Setting._();

  @override
  String get primaryKey =>
      RealmObjectBase.get<String>(this, 'primaryKey') as String;
  @override
  set primaryKey(String value) =>
      RealmObjectBase.set(this, 'primaryKey', value);

  @override
  Stream<RealmObjectChanges<Setting>> get changes =>
      RealmObjectBase.getChanges<Setting>(this);

  @override
  Setting freeze() => RealmObjectBase.freezeObject<Setting>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Setting._);
    return const SchemaObject(ObjectType.realmObject, Setting, 'Setting', [
      SchemaProperty('primaryKey', RealmPropertyType.string, primaryKey: true),
    ]);
  }
}
