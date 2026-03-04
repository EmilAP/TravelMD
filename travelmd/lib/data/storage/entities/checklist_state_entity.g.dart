// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_state_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetChecklistStateEntityCollection on Isar {
  IsarCollection<ChecklistStateEntity> get checklistStateEntitys =>
      this.collection();
}

const ChecklistStateEntitySchema = CollectionSchema(
  name: r'ChecklistStateEntity',
  id: 7694542571022767261,
  properties: {
    r'checklistItemId': PropertySchema(
      id: 0,
      name: r'checklistItemId',
      type: IsarType.string,
    ),
    r'isDone': PropertySchema(
      id: 1,
      name: r'isDone',
      type: IsarType.bool,
    ),
    r'planSelectionId': PropertySchema(
      id: 2,
      name: r'planSelectionId',
      type: IsarType.long,
    )
  },
  estimateSize: _checklistStateEntityEstimateSize,
  serialize: _checklistStateEntitySerialize,
  deserialize: _checklistStateEntityDeserialize,
  deserializeProp: _checklistStateEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _checklistStateEntityGetId,
  getLinks: _checklistStateEntityGetLinks,
  attach: _checklistStateEntityAttach,
  version: '3.1.0+1',
);

int _checklistStateEntityEstimateSize(
  ChecklistStateEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.checklistItemId.length * 3;
  return bytesCount;
}

void _checklistStateEntitySerialize(
  ChecklistStateEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.checklistItemId);
  writer.writeBool(offsets[1], object.isDone);
  writer.writeLong(offsets[2], object.planSelectionId);
}

ChecklistStateEntity _checklistStateEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChecklistStateEntity();
  object.checklistItemId = reader.readString(offsets[0]);
  object.id = id;
  object.isDone = reader.readBool(offsets[1]);
  object.planSelectionId = reader.readLong(offsets[2]);
  return object;
}

P _checklistStateEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _checklistStateEntityGetId(ChecklistStateEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _checklistStateEntityGetLinks(
    ChecklistStateEntity object) {
  return [];
}

void _checklistStateEntityAttach(
    IsarCollection<dynamic> col, Id id, ChecklistStateEntity object) {
  object.id = id;
}

extension ChecklistStateEntityQueryWhereSort
    on QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QWhere> {
  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ChecklistStateEntityQueryWhere
    on QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QWhereClause> {
  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterWhereClause>
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

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterWhereClause>
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

extension ChecklistStateEntityQueryFilter on QueryBuilder<ChecklistStateEntity,
    ChecklistStateEntity, QFilterCondition> {
  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
      QAfterFilterCondition> checklistItemIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checklistItemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
      QAfterFilterCondition> checklistItemIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checklistItemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
      QAfterFilterCondition> checklistItemIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checklistItemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
      QAfterFilterCondition> checklistItemIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checklistItemId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
      QAfterFilterCondition> checklistItemIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'checklistItemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
      QAfterFilterCondition> checklistItemIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'checklistItemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
          QAfterFilterCondition>
      checklistItemIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'checklistItemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
          QAfterFilterCondition>
      checklistItemIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'checklistItemId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
      QAfterFilterCondition> checklistItemIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checklistItemId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
      QAfterFilterCondition> checklistItemIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'checklistItemId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
      QAfterFilterCondition> isDoneEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDone',
        value: value,
      ));
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
      QAfterFilterCondition> planSelectionIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planSelectionId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
      QAfterFilterCondition> planSelectionIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'planSelectionId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
      QAfterFilterCondition> planSelectionIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'planSelectionId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity,
      QAfterFilterCondition> planSelectionIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'planSelectionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChecklistStateEntityQueryObject on QueryBuilder<ChecklistStateEntity,
    ChecklistStateEntity, QFilterCondition> {}

extension ChecklistStateEntityQueryLinks on QueryBuilder<ChecklistStateEntity,
    ChecklistStateEntity, QFilterCondition> {}

extension ChecklistStateEntityQuerySortBy
    on QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QSortBy> {
  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterSortBy>
      sortByChecklistItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checklistItemId', Sort.asc);
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterSortBy>
      sortByChecklistItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checklistItemId', Sort.desc);
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterSortBy>
      sortByIsDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDone', Sort.asc);
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterSortBy>
      sortByIsDoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDone', Sort.desc);
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterSortBy>
      sortByPlanSelectionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planSelectionId', Sort.asc);
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterSortBy>
      sortByPlanSelectionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planSelectionId', Sort.desc);
    });
  }
}

extension ChecklistStateEntityQuerySortThenBy
    on QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QSortThenBy> {
  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterSortBy>
      thenByChecklistItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checklistItemId', Sort.asc);
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterSortBy>
      thenByChecklistItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checklistItemId', Sort.desc);
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterSortBy>
      thenByIsDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDone', Sort.asc);
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterSortBy>
      thenByIsDoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDone', Sort.desc);
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterSortBy>
      thenByPlanSelectionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planSelectionId', Sort.asc);
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QAfterSortBy>
      thenByPlanSelectionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planSelectionId', Sort.desc);
    });
  }
}

extension ChecklistStateEntityQueryWhereDistinct
    on QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QDistinct> {
  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QDistinct>
      distinctByChecklistItemId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checklistItemId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QDistinct>
      distinctByIsDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDone');
    });
  }

  QueryBuilder<ChecklistStateEntity, ChecklistStateEntity, QDistinct>
      distinctByPlanSelectionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planSelectionId');
    });
  }
}

extension ChecklistStateEntityQueryProperty on QueryBuilder<
    ChecklistStateEntity, ChecklistStateEntity, QQueryProperty> {
  QueryBuilder<ChecklistStateEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ChecklistStateEntity, String, QQueryOperations>
      checklistItemIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checklistItemId');
    });
  }

  QueryBuilder<ChecklistStateEntity, bool, QQueryOperations> isDoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDone');
    });
  }

  QueryBuilder<ChecklistStateEntity, int, QQueryOperations>
      planSelectionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planSelectionId');
    });
  }
}
