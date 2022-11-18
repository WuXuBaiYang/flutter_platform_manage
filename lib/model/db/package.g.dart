// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetPackageCollection on Isar {
  IsarCollection<Package> get packages => this.collection();
}

const PackageSchema = CollectionSchema(
  name: r'Package',
  id: 6192244575192772594,
  properties: {
    r'completeTime': PropertySchema(
      id: 0,
      name: r'completeTime',
      type: IsarType.dateTime,
    ),
    r'envId': PropertySchema(
      id: 1,
      name: r'envId',
      type: IsarType.long,
    ),
    r'errors': PropertySchema(
      id: 2,
      name: r'errors',
      type: IsarType.stringList,
    ),
    r'logs': PropertySchema(
      id: 3,
      name: r'logs',
      type: IsarType.stringList,
    ),
    r'outputPath': PropertySchema(
      id: 4,
      name: r'outputPath',
      type: IsarType.string,
    ),
    r'packageSize': PropertySchema(
      id: 5,
      name: r'packageSize',
      type: IsarType.long,
    ),
    r'platform': PropertySchema(
      id: 6,
      name: r'platform',
      type: IsarType.byte,
      enumMap: _PackageplatformEnumValueMap,
    ),
    r'projectId': PropertySchema(
      id: 7,
      name: r'projectId',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 8,
      name: r'status',
      type: IsarType.byte,
      enumMap: _PackagestatusEnumValueMap,
    ),
    r'timeSpent': PropertySchema(
      id: 9,
      name: r'timeSpent',
      type: IsarType.long,
    )
  },
  estimateSize: _packageEstimateSize,
  serialize: _packageSerialize,
  deserialize: _packageDeserialize,
  deserializeProp: _packageDeserializeProp,
  idName: r'id',
  indexes: {
    r'completeTime': IndexSchema(
      id: -3126106724588762207,
      name: r'completeTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'completeTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _packageGetId,
  getLinks: _packageGetLinks,
  attach: _packageAttach,
  version: '3.0.2',
);

int _packageEstimateSize(
  Package object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.errors.length * 3;
  {
    for (var i = 0; i < object.errors.length; i++) {
      final value = object.errors[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.logs.length * 3;
  {
    for (var i = 0; i < object.logs.length; i++) {
      final value = object.logs[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.outputPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _packageSerialize(
  Package object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completeTime);
  writer.writeLong(offsets[1], object.envId);
  writer.writeStringList(offsets[2], object.errors);
  writer.writeStringList(offsets[3], object.logs);
  writer.writeString(offsets[4], object.outputPath);
  writer.writeLong(offsets[5], object.packageSize);
  writer.writeByte(offsets[6], object.platform.index);
  writer.writeLong(offsets[7], object.projectId);
  writer.writeByte(offsets[8], object.status.index);
  writer.writeLong(offsets[9], object.timeSpent);
}

Package _packageDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Package();
  object.completeTime = reader.readDateTimeOrNull(offsets[0]);
  object.envId = reader.readLong(offsets[1]);
  object.errors = reader.readStringList(offsets[2]) ?? [];
  object.id = id;
  object.logs = reader.readStringList(offsets[3]) ?? [];
  object.outputPath = reader.readStringOrNull(offsets[4]);
  object.packageSize = reader.readLongOrNull(offsets[5]);
  object.platform =
      _PackageplatformValueEnumMap[reader.readByteOrNull(offsets[6])] ??
          PlatformType.android;
  object.projectId = reader.readLong(offsets[7]);
  object.status =
      _PackagestatusValueEnumMap[reader.readByteOrNull(offsets[8])] ??
          PackageStatus.prepare;
  object.timeSpent = reader.readLongOrNull(offsets[9]);
  return object;
}

P _packageDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (_PackageplatformValueEnumMap[reader.readByteOrNull(offset)] ??
          PlatformType.android) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (_PackagestatusValueEnumMap[reader.readByteOrNull(offset)] ??
          PackageStatus.prepare) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PackageplatformEnumValueMap = {
  'android': 0,
  'ios': 1,
  'web': 2,
  'macos': 3,
  'windows': 4,
  'linux': 5,
};
const _PackageplatformValueEnumMap = {
  0: PlatformType.android,
  1: PlatformType.ios,
  2: PlatformType.web,
  3: PlatformType.macos,
  4: PlatformType.windows,
  5: PlatformType.linux,
};
const _PackagestatusEnumValueMap = {
  'prepare': 0,
  'packing': 1,
  'stopping': 2,
  'stopped': 3,
  'fail': 4,
  'completed': 5,
};
const _PackagestatusValueEnumMap = {
  0: PackageStatus.prepare,
  1: PackageStatus.packing,
  2: PackageStatus.stopping,
  3: PackageStatus.stopped,
  4: PackageStatus.fail,
  5: PackageStatus.completed,
};

Id _packageGetId(Package object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _packageGetLinks(Package object) {
  return [];
}

void _packageAttach(IsarCollection<dynamic> col, Id id, Package object) {
  object.id = id;
}

extension PackageQueryWhereSort on QueryBuilder<Package, Package, QWhere> {
  QueryBuilder<Package, Package, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Package, Package, QAfterWhere> anyCompleteTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'completeTime'),
      );
    });
  }
}

extension PackageQueryWhere on QueryBuilder<Package, Package, QWhereClause> {
  QueryBuilder<Package, Package, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Package, Package, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Package, Package, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Package, Package, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterWhereClause> completeTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'completeTime',
        value: [null],
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterWhereClause> completeTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completeTime',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterWhereClause> completeTimeEqualTo(
      DateTime? completeTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'completeTime',
        value: [completeTime],
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterWhereClause> completeTimeNotEqualTo(
      DateTime? completeTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completeTime',
              lower: [],
              upper: [completeTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completeTime',
              lower: [completeTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completeTime',
              lower: [completeTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completeTime',
              lower: [],
              upper: [completeTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Package, Package, QAfterWhereClause> completeTimeGreaterThan(
    DateTime? completeTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completeTime',
        lower: [completeTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterWhereClause> completeTimeLessThan(
    DateTime? completeTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completeTime',
        lower: [],
        upper: [completeTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterWhereClause> completeTimeBetween(
    DateTime? lowerCompleteTime,
    DateTime? upperCompleteTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completeTime',
        lower: [lowerCompleteTime],
        includeLower: includeLower,
        upper: [upperCompleteTime],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PackageQueryFilter
    on QueryBuilder<Package, Package, QFilterCondition> {
  QueryBuilder<Package, Package, QAfterFilterCondition> completeTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completeTime',
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition>
      completeTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completeTime',
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> completeTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completeTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> completeTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completeTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> completeTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completeTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> completeTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completeTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> envIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'envId',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> envIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'envId',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> envIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'envId',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> envIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'envId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> errorsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'errors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition>
      errorsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'errors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> errorsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'errors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> errorsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'errors',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> errorsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'errors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> errorsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'errors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> errorsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'errors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> errorsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'errors',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> errorsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'errors',
        value: '',
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition>
      errorsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'errors',
        value: '',
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> errorsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'errors',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> errorsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'errors',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> errorsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'errors',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> errorsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'errors',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> errorsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'errors',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> errorsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'errors',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> logsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> logsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'logs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> logsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'logs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> logsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'logs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> logsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'logs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> logsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'logs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> logsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'logs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> logsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'logs',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> logsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logs',
        value: '',
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition>
      logsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'logs',
        value: '',
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> logsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'logs',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> logsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'logs',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> logsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'logs',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> logsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'logs',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> logsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'logs',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> logsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'logs',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> outputPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'outputPath',
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> outputPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'outputPath',
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> outputPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'outputPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> outputPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'outputPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> outputPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'outputPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> outputPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'outputPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> outputPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'outputPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> outputPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'outputPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> outputPathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'outputPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> outputPathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'outputPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> outputPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'outputPath',
        value: '',
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> outputPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'outputPath',
        value: '',
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> packageSizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'packageSize',
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> packageSizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'packageSize',
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> packageSizeEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageSize',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> packageSizeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'packageSize',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> packageSizeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'packageSize',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> packageSizeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'packageSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> platformEqualTo(
      PlatformType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'platform',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> platformGreaterThan(
    PlatformType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'platform',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> platformLessThan(
    PlatformType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'platform',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> platformBetween(
    PlatformType lower,
    PlatformType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'platform',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> projectIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'projectId',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> projectIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'projectId',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> projectIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'projectId',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> projectIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'projectId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> statusEqualTo(
      PackageStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> statusGreaterThan(
    PackageStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> statusLessThan(
    PackageStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> statusBetween(
    PackageStatus lower,
    PackageStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> timeSpentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timeSpent',
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> timeSpentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timeSpent',
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> timeSpentEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeSpent',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> timeSpentGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeSpent',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> timeSpentLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeSpent',
        value: value,
      ));
    });
  }

  QueryBuilder<Package, Package, QAfterFilterCondition> timeSpentBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeSpent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PackageQueryObject
    on QueryBuilder<Package, Package, QFilterCondition> {}

extension PackageQueryLinks
    on QueryBuilder<Package, Package, QFilterCondition> {}

extension PackageQuerySortBy on QueryBuilder<Package, Package, QSortBy> {
  QueryBuilder<Package, Package, QAfterSortBy> sortByCompleteTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completeTime', Sort.asc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> sortByCompleteTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completeTime', Sort.desc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> sortByEnvId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'envId', Sort.asc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> sortByEnvIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'envId', Sort.desc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> sortByOutputPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outputPath', Sort.asc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> sortByOutputPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outputPath', Sort.desc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> sortByPackageSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageSize', Sort.asc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> sortByPackageSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageSize', Sort.desc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> sortByPlatform() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platform', Sort.asc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> sortByPlatformDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platform', Sort.desc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> sortByProjectId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectId', Sort.asc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> sortByProjectIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectId', Sort.desc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> sortByTimeSpent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSpent', Sort.asc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> sortByTimeSpentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSpent', Sort.desc);
    });
  }
}

extension PackageQuerySortThenBy
    on QueryBuilder<Package, Package, QSortThenBy> {
  QueryBuilder<Package, Package, QAfterSortBy> thenByCompleteTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completeTime', Sort.asc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> thenByCompleteTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completeTime', Sort.desc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> thenByEnvId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'envId', Sort.asc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> thenByEnvIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'envId', Sort.desc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> thenByOutputPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outputPath', Sort.asc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> thenByOutputPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outputPath', Sort.desc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> thenByPackageSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageSize', Sort.asc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> thenByPackageSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageSize', Sort.desc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> thenByPlatform() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platform', Sort.asc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> thenByPlatformDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platform', Sort.desc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> thenByProjectId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectId', Sort.asc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> thenByProjectIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectId', Sort.desc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> thenByTimeSpent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSpent', Sort.asc);
    });
  }

  QueryBuilder<Package, Package, QAfterSortBy> thenByTimeSpentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSpent', Sort.desc);
    });
  }
}

extension PackageQueryWhereDistinct
    on QueryBuilder<Package, Package, QDistinct> {
  QueryBuilder<Package, Package, QDistinct> distinctByCompleteTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completeTime');
    });
  }

  QueryBuilder<Package, Package, QDistinct> distinctByEnvId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'envId');
    });
  }

  QueryBuilder<Package, Package, QDistinct> distinctByErrors() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'errors');
    });
  }

  QueryBuilder<Package, Package, QDistinct> distinctByLogs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'logs');
    });
  }

  QueryBuilder<Package, Package, QDistinct> distinctByOutputPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'outputPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Package, Package, QDistinct> distinctByPackageSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'packageSize');
    });
  }

  QueryBuilder<Package, Package, QDistinct> distinctByPlatform() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'platform');
    });
  }

  QueryBuilder<Package, Package, QDistinct> distinctByProjectId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'projectId');
    });
  }

  QueryBuilder<Package, Package, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<Package, Package, QDistinct> distinctByTimeSpent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeSpent');
    });
  }
}

extension PackageQueryProperty
    on QueryBuilder<Package, Package, QQueryProperty> {
  QueryBuilder<Package, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Package, DateTime?, QQueryOperations> completeTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completeTime');
    });
  }

  QueryBuilder<Package, int, QQueryOperations> envIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'envId');
    });
  }

  QueryBuilder<Package, List<String>, QQueryOperations> errorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'errors');
    });
  }

  QueryBuilder<Package, List<String>, QQueryOperations> logsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'logs');
    });
  }

  QueryBuilder<Package, String?, QQueryOperations> outputPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'outputPath');
    });
  }

  QueryBuilder<Package, int?, QQueryOperations> packageSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'packageSize');
    });
  }

  QueryBuilder<Package, PlatformType, QQueryOperations> platformProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'platform');
    });
  }

  QueryBuilder<Package, int, QQueryOperations> projectIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projectId');
    });
  }

  QueryBuilder<Package, PackageStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<Package, int?, QQueryOperations> timeSpentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeSpent');
    });
  }
}
