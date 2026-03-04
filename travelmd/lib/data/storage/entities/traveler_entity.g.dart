// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'traveler_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTravelerEntityCollection on Isar {
  IsarCollection<TravelerEntity> get travelerEntitys => this.collection();
}

const TravelerEntitySchema = CollectionSchema(
  name: r'TravelerEntity',
  id: -3979561495661166313,
  properties: {
    r'ageYears': PropertySchema(
      id: 0,
      name: r'ageYears',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'isImmunocompromised': PropertySchema(
      id: 2,
      name: r'isImmunocompromised',
      type: IsarType.bool,
    ),
    r'isPregnant': PropertySchema(
      id: 3,
      name: r'isPregnant',
      type: IsarType.bool,
    ),
    r'isVFR': PropertySchema(
      id: 4,
      name: r'isVFR',
      type: IsarType.bool,
    ),
    r'nickname': PropertySchema(
      id: 5,
      name: r'nickname',
      type: IsarType.string,
    ),
    r'purpose': PropertySchema(
      id: 6,
      name: r'purpose',
      type: IsarType.string,
    )
  },
  estimateSize: _travelerEntityEstimateSize,
  serialize: _travelerEntitySerialize,
  deserialize: _travelerEntityDeserialize,
  deserializeProp: _travelerEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _travelerEntityGetId,
  getLinks: _travelerEntityGetLinks,
  attach: _travelerEntityAttach,
  version: '3.1.0+1',
);

int _travelerEntityEstimateSize(
  TravelerEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.nickname;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.purpose.length * 3;
  return bytesCount;
}

void _travelerEntitySerialize(
  TravelerEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.ageYears);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeBool(offsets[2], object.isImmunocompromised);
  writer.writeBool(offsets[3], object.isPregnant);
  writer.writeBool(offsets[4], object.isVFR);
  writer.writeString(offsets[5], object.nickname);
  writer.writeString(offsets[6], object.purpose);
}

TravelerEntity _travelerEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TravelerEntity();
  object.ageYears = reader.readLong(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.isImmunocompromised = reader.readBool(offsets[2]);
  object.isPregnant = reader.readBool(offsets[3]);
  object.isVFR = reader.readBool(offsets[4]);
  object.nickname = reader.readStringOrNull(offsets[5]);
  object.purpose = reader.readString(offsets[6]);
  return object;
}

P _travelerEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _travelerEntityGetId(TravelerEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _travelerEntityGetLinks(TravelerEntity object) {
  return [];
}

void _travelerEntityAttach(
    IsarCollection<dynamic> col, Id id, TravelerEntity object) {
  object.id = id;
}

extension TravelerEntityQueryWhereSort
    on QueryBuilder<TravelerEntity, TravelerEntity, QWhere> {
  QueryBuilder<TravelerEntity, TravelerEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TravelerEntityQueryWhere
    on QueryBuilder<TravelerEntity, TravelerEntity, QWhereClause> {
  QueryBuilder<TravelerEntity, TravelerEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterWhereClause> idBetween(
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

extension TravelerEntityQueryFilter
    on QueryBuilder<TravelerEntity, TravelerEntity, QFilterCondition> {
  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      ageYearsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ageYears',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      ageYearsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ageYears',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      ageYearsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ageYears',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      ageYearsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ageYears',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      isImmunocompromisedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isImmunocompromised',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      isPregnantEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPregnant',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      isVFREqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isVFR',
        value: value,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      nicknameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nickname',
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      nicknameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nickname',
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      nicknameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nickname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      nicknameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nickname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      nicknameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nickname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      nicknameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nickname',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      nicknameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nickname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      nicknameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nickname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      nicknameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nickname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      nicknameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nickname',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      nicknameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nickname',
        value: '',
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      nicknameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nickname',
        value: '',
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      purposeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purpose',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      purposeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purpose',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      purposeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purpose',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      purposeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purpose',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      purposeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'purpose',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      purposeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'purpose',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      purposeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'purpose',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      purposeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'purpose',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      purposeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purpose',
        value: '',
      ));
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterFilterCondition>
      purposeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'purpose',
        value: '',
      ));
    });
  }
}

extension TravelerEntityQueryObject
    on QueryBuilder<TravelerEntity, TravelerEntity, QFilterCondition> {}

extension TravelerEntityQueryLinks
    on QueryBuilder<TravelerEntity, TravelerEntity, QFilterCondition> {}

extension TravelerEntityQuerySortBy
    on QueryBuilder<TravelerEntity, TravelerEntity, QSortBy> {
  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy> sortByAgeYears() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ageYears', Sort.asc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy>
      sortByAgeYearsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ageYears', Sort.desc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy>
      sortByIsImmunocompromised() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isImmunocompromised', Sort.asc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy>
      sortByIsImmunocompromisedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isImmunocompromised', Sort.desc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy>
      sortByIsPregnant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPregnant', Sort.asc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy>
      sortByIsPregnantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPregnant', Sort.desc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy> sortByIsVFR() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVFR', Sort.asc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy> sortByIsVFRDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVFR', Sort.desc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy> sortByNickname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.asc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy>
      sortByNicknameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.desc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy> sortByPurpose() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purpose', Sort.asc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy>
      sortByPurposeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purpose', Sort.desc);
    });
  }
}

extension TravelerEntityQuerySortThenBy
    on QueryBuilder<TravelerEntity, TravelerEntity, QSortThenBy> {
  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy> thenByAgeYears() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ageYears', Sort.asc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy>
      thenByAgeYearsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ageYears', Sort.desc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy>
      thenByIsImmunocompromised() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isImmunocompromised', Sort.asc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy>
      thenByIsImmunocompromisedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isImmunocompromised', Sort.desc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy>
      thenByIsPregnant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPregnant', Sort.asc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy>
      thenByIsPregnantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPregnant', Sort.desc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy> thenByIsVFR() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVFR', Sort.asc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy> thenByIsVFRDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVFR', Sort.desc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy> thenByNickname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.asc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy>
      thenByNicknameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.desc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy> thenByPurpose() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purpose', Sort.asc);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QAfterSortBy>
      thenByPurposeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purpose', Sort.desc);
    });
  }
}

extension TravelerEntityQueryWhereDistinct
    on QueryBuilder<TravelerEntity, TravelerEntity, QDistinct> {
  QueryBuilder<TravelerEntity, TravelerEntity, QDistinct> distinctByAgeYears() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ageYears');
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QDistinct>
      distinctByIsImmunocompromised() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isImmunocompromised');
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QDistinct>
      distinctByIsPregnant() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPregnant');
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QDistinct> distinctByIsVFR() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isVFR');
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QDistinct> distinctByNickname(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nickname', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TravelerEntity, TravelerEntity, QDistinct> distinctByPurpose(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purpose', caseSensitive: caseSensitive);
    });
  }
}

extension TravelerEntityQueryProperty
    on QueryBuilder<TravelerEntity, TravelerEntity, QQueryProperty> {
  QueryBuilder<TravelerEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TravelerEntity, int, QQueryOperations> ageYearsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ageYears');
    });
  }

  QueryBuilder<TravelerEntity, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<TravelerEntity, bool, QQueryOperations>
      isImmunocompromisedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isImmunocompromised');
    });
  }

  QueryBuilder<TravelerEntity, bool, QQueryOperations> isPregnantProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPregnant');
    });
  }

  QueryBuilder<TravelerEntity, bool, QQueryOperations> isVFRProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isVFR');
    });
  }

  QueryBuilder<TravelerEntity, String?, QQueryOperations> nicknameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nickname');
    });
  }

  QueryBuilder<TravelerEntity, String, QQueryOperations> purposeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purpose');
    });
  }
}
