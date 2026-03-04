// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_selection_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlanSelectionEntityCollection on Isar {
  IsarCollection<PlanSelectionEntity> get planSelectionEntitys =>
      this.collection();
}

const PlanSelectionEntitySchema = CollectionSchema(
  name: r'PlanSelectionEntity',
  id: 9085328889054166499,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'selectedCardIds': PropertySchema(
      id: 1,
      name: r'selectedCardIds',
      type: IsarType.stringList,
    ),
    r'travelerId': PropertySchema(
      id: 2,
      name: r'travelerId',
      type: IsarType.long,
    ),
    r'tripId': PropertySchema(
      id: 3,
      name: r'tripId',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 4,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _planSelectionEntityEstimateSize,
  serialize: _planSelectionEntitySerialize,
  deserialize: _planSelectionEntityDeserialize,
  deserializeProp: _planSelectionEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _planSelectionEntityGetId,
  getLinks: _planSelectionEntityGetLinks,
  attach: _planSelectionEntityAttach,
  version: '3.1.0+1',
);

int _planSelectionEntityEstimateSize(
  PlanSelectionEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.selectedCardIds.length * 3;
  {
    for (var i = 0; i < object.selectedCardIds.length; i++) {
      final value = object.selectedCardIds[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _planSelectionEntitySerialize(
  PlanSelectionEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeStringList(offsets[1], object.selectedCardIds);
  writer.writeLong(offsets[2], object.travelerId);
  writer.writeLong(offsets[3], object.tripId);
  writer.writeDateTime(offsets[4], object.updatedAt);
}

PlanSelectionEntity _planSelectionEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlanSelectionEntity();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.selectedCardIds = reader.readStringList(offsets[1]) ?? [];
  object.travelerId = reader.readLong(offsets[2]);
  object.tripId = reader.readLong(offsets[3]);
  object.updatedAt = reader.readDateTime(offsets[4]);
  return object;
}

P _planSelectionEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _planSelectionEntityGetId(PlanSelectionEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _planSelectionEntityGetLinks(
    PlanSelectionEntity object) {
  return [];
}

void _planSelectionEntityAttach(
    IsarCollection<dynamic> col, Id id, PlanSelectionEntity object) {
  object.id = id;
}

extension PlanSelectionEntityQueryWhereSort
    on QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QWhere> {
  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlanSelectionEntityQueryWhere
    on QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QWhereClause> {
  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterWhereClause>
      idBetween(
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

extension PlanSelectionEntityQueryFilter on QueryBuilder<PlanSelectionEntity,
    PlanSelectionEntity, QFilterCondition> {
  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
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

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
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

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
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

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
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

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
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

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      selectedCardIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedCardIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      selectedCardIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedCardIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      selectedCardIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedCardIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      selectedCardIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedCardIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      selectedCardIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedCardIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      selectedCardIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedCardIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      selectedCardIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedCardIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      selectedCardIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedCardIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      selectedCardIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedCardIds',
        value: '',
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      selectedCardIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedCardIds',
        value: '',
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      selectedCardIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedCardIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      selectedCardIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedCardIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      selectedCardIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedCardIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      selectedCardIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedCardIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      selectedCardIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedCardIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      selectedCardIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedCardIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      travelerIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'travelerId',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      travelerIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'travelerId',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      travelerIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'travelerId',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      travelerIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'travelerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      tripIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tripId',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      tripIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tripId',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      tripIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tripId',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      tripIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tripId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PlanSelectionEntityQueryObject on QueryBuilder<PlanSelectionEntity,
    PlanSelectionEntity, QFilterCondition> {}

extension PlanSelectionEntityQueryLinks on QueryBuilder<PlanSelectionEntity,
    PlanSelectionEntity, QFilterCondition> {}

extension PlanSelectionEntityQuerySortBy
    on QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QSortBy> {
  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterSortBy>
      sortByTravelerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'travelerId', Sort.asc);
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterSortBy>
      sortByTravelerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'travelerId', Sort.desc);
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterSortBy>
      sortByTripId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tripId', Sort.asc);
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterSortBy>
      sortByTripIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tripId', Sort.desc);
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PlanSelectionEntityQuerySortThenBy
    on QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QSortThenBy> {
  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterSortBy>
      thenByTravelerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'travelerId', Sort.asc);
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterSortBy>
      thenByTravelerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'travelerId', Sort.desc);
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterSortBy>
      thenByTripId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tripId', Sort.asc);
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterSortBy>
      thenByTripIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tripId', Sort.desc);
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PlanSelectionEntityQueryWhereDistinct
    on QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QDistinct> {
  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QDistinct>
      distinctBySelectedCardIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedCardIds');
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QDistinct>
      distinctByTravelerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'travelerId');
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QDistinct>
      distinctByTripId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tripId');
    });
  }

  QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension PlanSelectionEntityQueryProperty
    on QueryBuilder<PlanSelectionEntity, PlanSelectionEntity, QQueryProperty> {
  QueryBuilder<PlanSelectionEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlanSelectionEntity, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PlanSelectionEntity, List<String>, QQueryOperations>
      selectedCardIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedCardIds');
    });
  }

  QueryBuilder<PlanSelectionEntity, int, QQueryOperations>
      travelerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'travelerId');
    });
  }

  QueryBuilder<PlanSelectionEntity, int, QQueryOperations> tripIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tripId');
    });
  }

  QueryBuilder<PlanSelectionEntity, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
