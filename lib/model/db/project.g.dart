// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Project extends _Project with RealmEntity, RealmObject {
  Project(
    String primaryKey,
    String alias,
    String path,
    String environmentKey,
    int order,
  ) {
    RealmObject.set(this, 'primaryKey', primaryKey);
    RealmObject.set(this, 'alias', alias);
    RealmObject.set(this, 'path', path);
    RealmObject.set(this, 'environmentKey', environmentKey);
    RealmObject.set(this, 'order', order);
  }

  Project._();

  @override
  String get primaryKey =>
      RealmObject.get<String>(this, 'primaryKey') as String;
  @override
  set primaryKey(String value) => throw RealmUnsupportedSetError();

  @override
  String get alias => RealmObject.get<String>(this, 'alias') as String;
  @override
  set alias(String value) => RealmObject.set(this, 'alias', value);

  @override
  String get path => RealmObject.get<String>(this, 'path') as String;
  @override
  set path(String value) => RealmObject.set(this, 'path', value);

  @override
  String get environmentKey =>
      RealmObject.get<String>(this, 'environmentKey') as String;
  @override
  set environmentKey(String value) =>
      RealmObject.set(this, 'environmentKey', value);

  @override
  int get order => RealmObject.get<int>(this, 'order') as int;
  @override
  set order(int value) => RealmObject.set(this, 'order', value);

  @override
  Stream<RealmObjectChanges<Project>> get changes =>
      RealmObject.getChanges<Project>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(Project._);
    return const SchemaObject(Project, [
      SchemaProperty('primaryKey', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('alias', RealmPropertyType.string),
      SchemaProperty('path', RealmPropertyType.string),
      SchemaProperty('environmentKey', RealmPropertyType.string),
      SchemaProperty('order', RealmPropertyType.int),
    ]);
  }
}
