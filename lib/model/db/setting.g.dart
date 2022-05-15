// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Setting extends _Setting with RealmEntity, RealmObject {
  Setting(
    String primaryKey,
    String gitRepositoryCachePath,
  ) {
    RealmObject.set(this, 'primaryKey', primaryKey);
    RealmObject.set(this, 'gitRepositoryCachePath', gitRepositoryCachePath);
  }

  Setting._();

  @override
  String get primaryKey =>
      RealmObject.get<String>(this, 'primaryKey') as String;
  @override
  set primaryKey(String value) => throw RealmUnsupportedSetError();

  @override
  String get gitRepositoryCachePath =>
      RealmObject.get<String>(this, 'gitRepositoryCachePath') as String;
  @override
  set gitRepositoryCachePath(String value) =>
      RealmObject.set(this, 'gitRepositoryCachePath', value);

  @override
  Stream<RealmObjectChanges<Setting>> get changes =>
      RealmObject.getChanges<Setting>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(Setting._);
    return const SchemaObject(Setting, [
      SchemaProperty('primaryKey', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('gitRepositoryCachePath', RealmPropertyType.string),
    ]);
  }
}
