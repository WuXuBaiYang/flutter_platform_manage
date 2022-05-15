// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Environment extends _Environment with RealmEntity, RealmObject {
  Environment(
    String primaryKey,
    String flutterPath,
    String flutterVersion,
  ) {
    RealmObject.set(this, 'primaryKey', primaryKey);
    RealmObject.set(this, 'flutterPath', flutterPath);
    RealmObject.set(this, 'flutterVersion', flutterVersion);
  }

  Environment._();

  @override
  String get primaryKey =>
      RealmObject.get<String>(this, 'primaryKey') as String;
  @override
  set primaryKey(String value) => throw RealmUnsupportedSetError();

  @override
  String get flutterPath =>
      RealmObject.get<String>(this, 'flutterPath') as String;
  @override
  set flutterPath(String value) => RealmObject.set(this, 'flutterPath', value);

  @override
  String get flutterVersion =>
      RealmObject.get<String>(this, 'flutterVersion') as String;
  @override
  set flutterVersion(String value) =>
      RealmObject.set(this, 'flutterVersion', value);

  @override
  Stream<RealmObjectChanges<Environment>> get changes =>
      RealmObject.getChanges<Environment>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(Environment._);
    return const SchemaObject(Environment, [
      SchemaProperty('primaryKey', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('flutterPath', RealmPropertyType.string),
      SchemaProperty('flutterVersion', RealmPropertyType.string),
    ]);
  }
}
