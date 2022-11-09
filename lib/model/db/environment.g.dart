// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetEnvironmentCollection on Isar {
  IsarCollection<Environment> get environments => this.collection();
}

const EnvironmentSchema = CollectionSchema(
  name: r'Environment',
  id: -7344354649279055731,
  properties: {
    r'channel': PropertySchema(
      id: 0,
      name: r'channel',
      type: IsarType.string,
    ),
    r'dart': PropertySchema(
      id: 1,
      name: r'dart',
      type: IsarType.string,
    ),
    r'flutter': PropertySchema(
      id: 2,
      name: r'flutter',
      type: IsarType.string,
    ),
    r'hashCode': PropertySchema(
      id: 3,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'path': PropertySchema(
      id: 4,
      name: r'path',
      type: IsarType.string,
    )
  },
  estimateSize: _environmentEstimateSize,
  serialize: _environmentSerialize,
  deserialize: _environmentDeserialize,
  deserializeProp: _environmentDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _environmentGetId,
  getLinks: _environmentGetLinks,
  attach: _environmentAttach,
  version: '3.0.2',
);

int _environmentEstimateSize(
  Environment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.channel.length * 3;
  bytesCount += 3 + object.dart.length * 3;
  bytesCount += 3 + object.flutter.length * 3;
  bytesCount += 3 + object.path.length * 3;
  return bytesCount;
}

void _environmentSerialize(
  Environment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.channel);
  writer.writeString(offsets[1], object.dart);
  writer.writeString(offsets[2], object.flutter);
  writer.writeLong(offsets[3], object.hashCode);
  writer.writeString(offsets[4], object.path);
}

Environment _environmentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Environment();
  object.channel = reader.readString(offsets[0]);
  object.dart = reader.readString(offsets[1]);
  object.flutter = reader.readString(offsets[2]);
  object.id = id;
  object.path = reader.readString(offsets[4]);
  return object;
}

P _environmentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _environmentGetId(Environment object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _environmentGetLinks(Environment object) {
  return [];
}

void _environmentAttach(
    IsarCollection<dynamic> col, Id id, Environment object) {
  object.id = id;
}

extension EnvironmentQueryWhereSort
    on QueryBuilder<Environment, Environment, QWhere> {
  QueryBuilder<Environment, Environment, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EnvironmentQueryWhere
    on QueryBuilder<Environment, Environment, QWhereClause> {
  QueryBuilder<Environment, Environment, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<Environment, Environment, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Environment, Environment, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Environment, Environment, QAfterWhereClause> idBetween(
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
}

extension EnvironmentQueryFilter
    on QueryBuilder<Environment, Environment, QFilterCondition> {
  QueryBuilder<Environment, Environment, QAfterFilterCondition> channelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition>
      channelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'channel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> channelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'channel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> channelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'channel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition>
      channelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'channel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> channelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'channel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> channelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'channel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> channelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'channel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition>
      channelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channel',
        value: '',
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition>
      channelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'channel',
        value: '',
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> dartEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> dartGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> dartLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> dartBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dart',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> dartStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> dartEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> dartContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> dartMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dart',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> dartIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dart',
        value: '',
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition>
      dartIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dart',
        value: '',
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> flutterEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'flutter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition>
      flutterGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'flutter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> flutterLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'flutter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> flutterBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'flutter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition>
      flutterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'flutter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> flutterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'flutter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> flutterContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'flutter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> flutterMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'flutter',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition>
      flutterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'flutter',
        value: '',
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition>
      flutterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'flutter',
        value: '',
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition>
      hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition>
      hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Environment, Environment, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Environment, Environment, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Environment, Environment, QAfterFilterCondition> pathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> pathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> pathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> pathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'path',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> pathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> pathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> pathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> pathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'path',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition> pathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<Environment, Environment, QAfterFilterCondition>
      pathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'path',
        value: '',
      ));
    });
  }
}

extension EnvironmentQueryObject
    on QueryBuilder<Environment, Environment, QFilterCondition> {}

extension EnvironmentQueryLinks
    on QueryBuilder<Environment, Environment, QFilterCondition> {}

extension EnvironmentQuerySortBy
    on QueryBuilder<Environment, Environment, QSortBy> {
  QueryBuilder<Environment, Environment, QAfterSortBy> sortByChannel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channel', Sort.asc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> sortByChannelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channel', Sort.desc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> sortByDart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dart', Sort.asc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> sortByDartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dart', Sort.desc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> sortByFlutter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flutter', Sort.asc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> sortByFlutterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flutter', Sort.desc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> sortByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> sortByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }
}

extension EnvironmentQuerySortThenBy
    on QueryBuilder<Environment, Environment, QSortThenBy> {
  QueryBuilder<Environment, Environment, QAfterSortBy> thenByChannel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channel', Sort.asc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> thenByChannelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channel', Sort.desc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> thenByDart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dart', Sort.asc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> thenByDartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dart', Sort.desc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> thenByFlutter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flutter', Sort.asc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> thenByFlutterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flutter', Sort.desc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> thenByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<Environment, Environment, QAfterSortBy> thenByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }
}

extension EnvironmentQueryWhereDistinct
    on QueryBuilder<Environment, Environment, QDistinct> {
  QueryBuilder<Environment, Environment, QDistinct> distinctByChannel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'channel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Environment, Environment, QDistinct> distinctByDart(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dart', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Environment, Environment, QDistinct> distinctByFlutter(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'flutter', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Environment, Environment, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<Environment, Environment, QDistinct> distinctByPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'path', caseSensitive: caseSensitive);
    });
  }
}

extension EnvironmentQueryProperty
    on QueryBuilder<Environment, Environment, QQueryProperty> {
  QueryBuilder<Environment, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Environment, String, QQueryOperations> channelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'channel');
    });
  }

  QueryBuilder<Environment, String, QQueryOperations> dartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dart');
    });
  }

  QueryBuilder<Environment, String, QQueryOperations> flutterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'flutter');
    });
  }

  QueryBuilder<Environment, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<Environment, String, QQueryOperations> pathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'path');
    });
  }
}
