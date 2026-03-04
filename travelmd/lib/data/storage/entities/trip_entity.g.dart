// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTripEntityCollection on Isar {
  IsarCollection<TripEntity> get tripEntitys => this.collection();
}

const TripEntitySchema = CollectionSchema(
  name: r'TripEntity',
  id: -5096576547797122041,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'departDate': PropertySchema(
      id: 1,
      name: r'departDate',
      type: IsarType.dateTime,
    ),
    r'destinationCountry': PropertySchema(
      id: 2,
      name: r'destinationCountry',
      type: IsarType.string,
    ),
    r'originCountry': PropertySchema(
      id: 3,
      name: r'originCountry',
      type: IsarType.string,
    ),
    r'returnDate': PropertySchema(
      id: 4,
      name: r'returnDate',
      type: IsarType.dateTime,
    ),
    r'transitCountries': PropertySchema(
      id: 5,
      name: r'transitCountries',
      type: IsarType.stringList,
    )
  },
  estimateSize: _tripEntityEstimateSize,
  serialize: _tripEntitySerialize,
  deserialize: _tripEntityDeserialize,
  deserializeProp: _tripEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _tripEntityGetId,
  getLinks: _tripEntityGetLinks,
  attach: _tripEntityAttach,
  version: '3.1.0+1',
);

int _tripEntityEstimateSize(
  TripEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.destinationCountry.length * 3;
  bytesCount += 3 + object.originCountry.length * 3;
  bytesCount += 3 + object.transitCountries.length * 3;
  {
    for (var i = 0; i < object.transitCountries.length; i++) {
      final value = object.transitCountries[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _tripEntitySerialize(
  TripEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDateTime(offsets[1], object.departDate);
  writer.writeString(offsets[2], object.destinationCountry);
  writer.writeString(offsets[3], object.originCountry);
  writer.writeDateTime(offsets[4], object.returnDate);
  writer.writeStringList(offsets[5], object.transitCountries);
}

TripEntity _tripEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TripEntity();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.departDate = reader.readDateTime(offsets[1]);
  object.destinationCountry = reader.readString(offsets[2]);
  object.id = id;
  object.originCountry = reader.readString(offsets[3]);
  object.returnDate = reader.readDateTime(offsets[4]);
  object.transitCountries = reader.readStringList(offsets[5]) ?? [];
  return object;
}

P _tripEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tripEntityGetId(TripEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tripEntityGetLinks(TripEntity object) {
  return [];
}

void _tripEntityAttach(IsarCollection<dynamic> col, Id id, TripEntity object) {
  object.id = id;
}

extension TripEntityQueryWhereSort
    on QueryBuilder<TripEntity, TripEntity, QWhere> {
  QueryBuilder<TripEntity, TripEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TripEntityQueryWhere
    on QueryBuilder<TripEntity, TripEntity, QWhereClause> {
  QueryBuilder<TripEntity, TripEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<TripEntity, TripEntity, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterWhereClause> idBetween(
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

extension TripEntityQueryFilter
    on QueryBuilder<TripEntity, TripEntity, QFilterCondition> {
  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
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

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition> departDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'departDate',
        value: value,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      departDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'departDate',
        value: value,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      departDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'departDate',
        value: value,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition> departDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'departDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      destinationCountryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'destinationCountry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      destinationCountryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'destinationCountry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      destinationCountryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'destinationCountry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      destinationCountryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'destinationCountry',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      destinationCountryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'destinationCountry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      destinationCountryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'destinationCountry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      destinationCountryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'destinationCountry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      destinationCountryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'destinationCountry',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      destinationCountryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'destinationCountry',
        value: '',
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      destinationCountryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'destinationCountry',
        value: '',
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      originCountryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originCountry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      originCountryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originCountry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      originCountryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originCountry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      originCountryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originCountry',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      originCountryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originCountry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      originCountryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originCountry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      originCountryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originCountry',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      originCountryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originCountry',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      originCountryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originCountry',
        value: '',
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      originCountryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originCountry',
        value: '',
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition> returnDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'returnDate',
        value: value,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      returnDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'returnDate',
        value: value,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      returnDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'returnDate',
        value: value,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition> returnDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'returnDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      transitCountriesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transitCountries',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      transitCountriesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transitCountries',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      transitCountriesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transitCountries',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      transitCountriesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transitCountries',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      transitCountriesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'transitCountries',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      transitCountriesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'transitCountries',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      transitCountriesElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'transitCountries',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      transitCountriesElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'transitCountries',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      transitCountriesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transitCountries',
        value: '',
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      transitCountriesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'transitCountries',
        value: '',
      ));
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      transitCountriesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'transitCountries',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      transitCountriesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'transitCountries',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      transitCountriesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'transitCountries',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      transitCountriesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'transitCountries',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      transitCountriesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'transitCountries',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterFilterCondition>
      transitCountriesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'transitCountries',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension TripEntityQueryObject
    on QueryBuilder<TripEntity, TripEntity, QFilterCondition> {}

extension TripEntityQueryLinks
    on QueryBuilder<TripEntity, TripEntity, QFilterCondition> {}

extension TripEntityQuerySortBy
    on QueryBuilder<TripEntity, TripEntity, QSortBy> {
  QueryBuilder<TripEntity, TripEntity, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy> sortByDepartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'departDate', Sort.asc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy> sortByDepartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'departDate', Sort.desc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy>
      sortByDestinationCountry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinationCountry', Sort.asc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy>
      sortByDestinationCountryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinationCountry', Sort.desc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy> sortByOriginCountry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originCountry', Sort.asc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy> sortByOriginCountryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originCountry', Sort.desc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy> sortByReturnDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnDate', Sort.asc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy> sortByReturnDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnDate', Sort.desc);
    });
  }
}

extension TripEntityQuerySortThenBy
    on QueryBuilder<TripEntity, TripEntity, QSortThenBy> {
  QueryBuilder<TripEntity, TripEntity, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy> thenByDepartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'departDate', Sort.asc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy> thenByDepartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'departDate', Sort.desc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy>
      thenByDestinationCountry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinationCountry', Sort.asc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy>
      thenByDestinationCountryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinationCountry', Sort.desc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy> thenByOriginCountry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originCountry', Sort.asc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy> thenByOriginCountryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originCountry', Sort.desc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy> thenByReturnDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnDate', Sort.asc);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QAfterSortBy> thenByReturnDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnDate', Sort.desc);
    });
  }
}

extension TripEntityQueryWhereDistinct
    on QueryBuilder<TripEntity, TripEntity, QDistinct> {
  QueryBuilder<TripEntity, TripEntity, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<TripEntity, TripEntity, QDistinct> distinctByDepartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'departDate');
    });
  }

  QueryBuilder<TripEntity, TripEntity, QDistinct> distinctByDestinationCountry(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'destinationCountry',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QDistinct> distinctByOriginCountry(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originCountry',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TripEntity, TripEntity, QDistinct> distinctByReturnDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'returnDate');
    });
  }

  QueryBuilder<TripEntity, TripEntity, QDistinct> distinctByTransitCountries() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transitCountries');
    });
  }
}

extension TripEntityQueryProperty
    on QueryBuilder<TripEntity, TripEntity, QQueryProperty> {
  QueryBuilder<TripEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TripEntity, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<TripEntity, DateTime, QQueryOperations> departDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'departDate');
    });
  }

  QueryBuilder<TripEntity, String, QQueryOperations>
      destinationCountryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'destinationCountry');
    });
  }

  QueryBuilder<TripEntity, String, QQueryOperations> originCountryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originCountry');
    });
  }

  QueryBuilder<TripEntity, DateTime, QQueryOperations> returnDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'returnDate');
    });
  }

  QueryBuilder<TripEntity, List<String>, QQueryOperations>
      transitCountriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transitCountries');
    });
  }
}
