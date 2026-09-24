// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DayCheckInsTable extends DayCheckIns
    with TableInfo<$DayCheckInsTable, DayCheckIn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayCheckInsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('confirmed_quiet'),
  );
  static const VerificationMeta _confirmedAtMeta = const VerificationMeta(
    'confirmedAt',
  );
  @override
  late final GeneratedColumn<String> confirmedAt = GeneratedColumn<String>(
    'confirmed_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [localDate, status, confirmedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_check_ins';
  @override
  VerificationContext validateIntegrity(
    Insertable<DayCheckIn> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('confirmed_at')) {
      context.handle(
        _confirmedAtMeta,
        confirmedAt.isAcceptableOrUnknown(
          data['confirmed_at']!,
          _confirmedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_confirmedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localDate};
  @override
  DayCheckIn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayCheckIn(
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      confirmedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confirmed_at'],
      )!,
    );
  }

  @override
  $DayCheckInsTable createAlias(String alias) {
    return $DayCheckInsTable(attachedDatabase, alias);
  }
}

class DayCheckIn extends DataClass implements Insertable<DayCheckIn> {
  final String localDate;
  final String status;
  final String confirmedAt;
  const DayCheckIn({
    required this.localDate,
    required this.status,
    required this.confirmedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_date'] = Variable<String>(localDate);
    map['status'] = Variable<String>(status);
    map['confirmed_at'] = Variable<String>(confirmedAt);
    return map;
  }

  DayCheckInsCompanion toCompanion(bool nullToAbsent) {
    return DayCheckInsCompanion(
      localDate: Value(localDate),
      status: Value(status),
      confirmedAt: Value(confirmedAt),
    );
  }

  factory DayCheckIn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayCheckIn(
      localDate: serializer.fromJson<String>(json['localDate']),
      status: serializer.fromJson<String>(json['status']),
      confirmedAt: serializer.fromJson<String>(json['confirmedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localDate': serializer.toJson<String>(localDate),
      'status': serializer.toJson<String>(status),
      'confirmedAt': serializer.toJson<String>(confirmedAt),
    };
  }

  DayCheckIn copyWith({
    String? localDate,
    String? status,
    String? confirmedAt,
  }) => DayCheckIn(
    localDate: localDate ?? this.localDate,
    status: status ?? this.status,
    confirmedAt: confirmedAt ?? this.confirmedAt,
  );
  DayCheckIn copyWithCompanion(DayCheckInsCompanion data) {
    return DayCheckIn(
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      status: data.status.present ? data.status.value : this.status,
      confirmedAt: data.confirmedAt.present
          ? data.confirmedAt.value
          : this.confirmedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayCheckIn(')
          ..write('localDate: $localDate, ')
          ..write('status: $status, ')
          ..write('confirmedAt: $confirmedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(localDate, status, confirmedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayCheckIn &&
          other.localDate == this.localDate &&
          other.status == this.status &&
          other.confirmedAt == this.confirmedAt);
}

class DayCheckInsCompanion extends UpdateCompanion<DayCheckIn> {
  final Value<String> localDate;
  final Value<String> status;
  final Value<String> confirmedAt;
  final Value<int> rowid;
  const DayCheckInsCompanion({
    this.localDate = const Value.absent(),
    this.status = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DayCheckInsCompanion.insert({
    required String localDate,
    this.status = const Value.absent(),
    required String confirmedAt,
    this.rowid = const Value.absent(),
  }) : localDate = Value(localDate),
       confirmedAt = Value(confirmedAt);
  static Insertable<DayCheckIn> custom({
    Expression<String>? localDate,
    Expression<String>? status,
    Expression<String>? confirmedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localDate != null) 'local_date': localDate,
      if (status != null) 'status': status,
      if (confirmedAt != null) 'confirmed_at': confirmedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DayCheckInsCompanion copyWith({
    Value<String>? localDate,
    Value<String>? status,
    Value<String>? confirmedAt,
    Value<int>? rowid,
  }) {
    return DayCheckInsCompanion(
      localDate: localDate ?? this.localDate,
      status: status ?? this.status,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (confirmedAt.present) {
      map['confirmed_at'] = Variable<String>(confirmedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayCheckInsCompanion(')
          ..write('localDate: $localDate, ')
          ..write('status: $status, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyNotesTable extends DailyNotes
    with TableInfo<$DailyNotesTable, DailyNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _text_Meta = const VerificationMeta('text_');
  @override
  late final GeneratedColumn<String> text_ = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [localDate, text_, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _text_Meta,
        text_.isAcceptableOrUnknown(data['text']!, _text_Meta),
      );
    } else if (isInserting) {
      context.missing(_text_Meta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localDate};
  @override
  DailyNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyNote(
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      text_: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyNotesTable createAlias(String alias) {
    return $DailyNotesTable(attachedDatabase, alias);
  }
}

class DailyNote extends DataClass implements Insertable<DailyNote> {
  final String localDate;
  final String text_;
  final String updatedAt;
  const DailyNote({
    required this.localDate,
    required this.text_,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_date'] = Variable<String>(localDate);
    map['text'] = Variable<String>(text_);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  DailyNotesCompanion toCompanion(bool nullToAbsent) {
    return DailyNotesCompanion(
      localDate: Value(localDate),
      text_: Value(text_),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyNote(
      localDate: serializer.fromJson<String>(json['localDate']),
      text_: serializer.fromJson<String>(json['text_']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localDate': serializer.toJson<String>(localDate),
      'text_': serializer.toJson<String>(text_),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  DailyNote copyWith({String? localDate, String? text_, String? updatedAt}) =>
      DailyNote(
        localDate: localDate ?? this.localDate,
        text_: text_ ?? this.text_,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DailyNote copyWithCompanion(DailyNotesCompanion data) {
    return DailyNote(
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      text_: data.text_.present ? data.text_.value : this.text_,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyNote(')
          ..write('localDate: $localDate, ')
          ..write('text_: $text_, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(localDate, text_, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyNote &&
          other.localDate == this.localDate &&
          other.text_ == this.text_ &&
          other.updatedAt == this.updatedAt);
}

class DailyNotesCompanion extends UpdateCompanion<DailyNote> {
  final Value<String> localDate;
  final Value<String> text_;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const DailyNotesCompanion({
    this.localDate = const Value.absent(),
    this.text_ = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyNotesCompanion.insert({
    required String localDate,
    required String text_,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : localDate = Value(localDate),
       text_ = Value(text_),
       updatedAt = Value(updatedAt);
  static Insertable<DailyNote> custom({
    Expression<String>? localDate,
    Expression<String>? text_,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localDate != null) 'local_date': localDate,
      if (text_ != null) 'text': text_,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyNotesCompanion copyWith({
    Value<String>? localDate,
    Value<String>? text_,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return DailyNotesCompanion(
      localDate: localDate ?? this.localDate,
      text_: text_ ?? this.text_,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (text_.present) {
      map['text'] = Variable<String>(text_.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyNotesCompanion(')
          ..write('localDate: $localDate, ')
          ..write('text_: $text_, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FluidObservationsTable extends FluidObservations
    with TableInfo<$FluidObservationsTable, FluidObservation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FluidObservationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localTimeMeta = const VerificationMeta(
    'localTime',
  );
  @override
  late final GeneratedColumn<String> localTime = GeneratedColumn<String>(
    'local_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('realtime'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  materialTypes =
      GeneratedColumn<String>(
        'material_types',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>(
        $FluidObservationsTable.$convertermaterialTypes,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> colours =
      GeneratedColumn<String>(
        'colours',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($FluidObservationsTable.$convertercolours);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<String> amount = GeneratedColumn<String>(
    'amount',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> textures =
      GeneratedColumn<String>(
        'textures',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($FluidObservationsTable.$convertertextures);
  static const VerificationMeta _bloodPresenceMeta = const VerificationMeta(
    'bloodPresence',
  );
  @override
  late final GeneratedColumn<String> bloodPresence = GeneratedColumn<String>(
    'blood_presence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unknown'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  visibilityContexts =
      GeneratedColumn<String>(
        'visibility_contexts',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>(
        $FluidObservationsTable.$convertervisibilityContexts,
      );
  @override
  late final GeneratedColumnWithTypeConverter<ClotObservation?, String> clot =
      GeneratedColumn<String>(
        'clot',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<ClotObservation?>(
        $FluidObservationsTable.$converterclotn,
      );
  static const VerificationMeta _odourChangeMeta = const VerificationMeta(
    'odourChange',
  );
  @override
  late final GeneratedColumn<String> odourChange = GeneratedColumn<String>(
    'odour_change',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localDate,
    localTime,
    source,
    notes,
    createdAt,
    updatedAt,
    materialTypes,
    colours,
    amount,
    textures,
    bloodPresence,
    visibilityContexts,
    clot,
    odourChange,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fluid_observations';
  @override
  VerificationContext validateIntegrity(
    Insertable<FluidObservation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('local_time')) {
      context.handle(
        _localTimeMeta,
        localTime.isAcceptableOrUnknown(data['local_time']!, _localTimeMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('blood_presence')) {
      context.handle(
        _bloodPresenceMeta,
        bloodPresence.isAcceptableOrUnknown(
          data['blood_presence']!,
          _bloodPresenceMeta,
        ),
      );
    }
    if (data.containsKey('odour_change')) {
      context.handle(
        _odourChangeMeta,
        odourChange.isAcceptableOrUnknown(
          data['odour_change']!,
          _odourChangeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FluidObservation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FluidObservation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      localTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_time'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      materialTypes: $FluidObservationsTable.$convertermaterialTypes.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}material_types'],
        )!,
      ),
      colours: $FluidObservationsTable.$convertercolours.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}colours'],
        )!,
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}amount'],
      ),
      textures: $FluidObservationsTable.$convertertextures.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}textures'],
        )!,
      ),
      bloodPresence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}blood_presence'],
      )!,
      visibilityContexts: $FluidObservationsTable.$convertervisibilityContexts
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}visibility_contexts'],
            )!,
          ),
      clot: $FluidObservationsTable.$converterclotn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}clot'],
        ),
      ),
      odourChange: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}odour_change'],
      ),
    );
  }

  @override
  $FluidObservationsTable createAlias(String alias) {
    return $FluidObservationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $convertermaterialTypes = const StringListConverter();
  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $convertercolours = const StringListConverter();
  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $convertertextures = const StringListConverter();
  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $convertervisibilityContexts = const StringListConverter();
  static JsonTypeConverter2<ClotObservation, String, Map<String, Object?>>
  $converterclot = const ClotConverter();
  static JsonTypeConverter2<ClotObservation?, String?, Map<String, Object?>?>
  $converterclotn = JsonTypeConverter2.asNullable($converterclot);
}

class FluidObservation extends DataClass
    implements Insertable<FluidObservation> {
  final String id;
  final String localDate;
  final String? localTime;
  final String source;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final List<String> materialTypes;
  final List<String> colours;
  final String? amount;
  final List<String> textures;
  final String bloodPresence;
  final List<String> visibilityContexts;
  final ClotObservation? clot;
  final String? odourChange;
  const FluidObservation({
    required this.id,
    required this.localDate,
    this.localTime,
    required this.source,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.materialTypes,
    required this.colours,
    this.amount,
    required this.textures,
    required this.bloodPresence,
    required this.visibilityContexts,
    this.clot,
    this.odourChange,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['local_date'] = Variable<String>(localDate);
    if (!nullToAbsent || localTime != null) {
      map['local_time'] = Variable<String>(localTime);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    {
      map['material_types'] = Variable<String>(
        $FluidObservationsTable.$convertermaterialTypes.toSql(materialTypes),
      );
    }
    {
      map['colours'] = Variable<String>(
        $FluidObservationsTable.$convertercolours.toSql(colours),
      );
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<String>(amount);
    }
    {
      map['textures'] = Variable<String>(
        $FluidObservationsTable.$convertertextures.toSql(textures),
      );
    }
    map['blood_presence'] = Variable<String>(bloodPresence);
    {
      map['visibility_contexts'] = Variable<String>(
        $FluidObservationsTable.$convertervisibilityContexts.toSql(
          visibilityContexts,
        ),
      );
    }
    if (!nullToAbsent || clot != null) {
      map['clot'] = Variable<String>(
        $FluidObservationsTable.$converterclotn.toSql(clot),
      );
    }
    if (!nullToAbsent || odourChange != null) {
      map['odour_change'] = Variable<String>(odourChange);
    }
    return map;
  }

  FluidObservationsCompanion toCompanion(bool nullToAbsent) {
    return FluidObservationsCompanion(
      id: Value(id),
      localDate: Value(localDate),
      localTime: localTime == null && nullToAbsent
          ? const Value.absent()
          : Value(localTime),
      source: Value(source),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      materialTypes: Value(materialTypes),
      colours: Value(colours),
      amount: amount == null && nullToAbsent
          ? const Value.absent()
          : Value(amount),
      textures: Value(textures),
      bloodPresence: Value(bloodPresence),
      visibilityContexts: Value(visibilityContexts),
      clot: clot == null && nullToAbsent ? const Value.absent() : Value(clot),
      odourChange: odourChange == null && nullToAbsent
          ? const Value.absent()
          : Value(odourChange),
    );
  }

  factory FluidObservation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FluidObservation(
      id: serializer.fromJson<String>(json['id']),
      localDate: serializer.fromJson<String>(json['localDate']),
      localTime: serializer.fromJson<String?>(json['localTime']),
      source: serializer.fromJson<String>(json['source']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      materialTypes: $FluidObservationsTable.$convertermaterialTypes.fromJson(
        serializer.fromJson<List<dynamic>>(json['materialTypes']),
      ),
      colours: $FluidObservationsTable.$convertercolours.fromJson(
        serializer.fromJson<List<dynamic>>(json['colours']),
      ),
      amount: serializer.fromJson<String?>(json['amount']),
      textures: $FluidObservationsTable.$convertertextures.fromJson(
        serializer.fromJson<List<dynamic>>(json['textures']),
      ),
      bloodPresence: serializer.fromJson<String>(json['bloodPresence']),
      visibilityContexts: $FluidObservationsTable.$convertervisibilityContexts
          .fromJson(
            serializer.fromJson<List<dynamic>>(json['visibilityContexts']),
          ),
      clot: $FluidObservationsTable.$converterclotn.fromJson(
        serializer.fromJson<Map<String, Object?>?>(json['clot']),
      ),
      odourChange: serializer.fromJson<String?>(json['odourChange']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'localDate': serializer.toJson<String>(localDate),
      'localTime': serializer.toJson<String?>(localTime),
      'source': serializer.toJson<String>(source),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'materialTypes': serializer.toJson<List<dynamic>>(
        $FluidObservationsTable.$convertermaterialTypes.toJson(materialTypes),
      ),
      'colours': serializer.toJson<List<dynamic>>(
        $FluidObservationsTable.$convertercolours.toJson(colours),
      ),
      'amount': serializer.toJson<String?>(amount),
      'textures': serializer.toJson<List<dynamic>>(
        $FluidObservationsTable.$convertertextures.toJson(textures),
      ),
      'bloodPresence': serializer.toJson<String>(bloodPresence),
      'visibilityContexts': serializer.toJson<List<dynamic>>(
        $FluidObservationsTable.$convertervisibilityContexts.toJson(
          visibilityContexts,
        ),
      ),
      'clot': serializer.toJson<Map<String, Object?>?>(
        $FluidObservationsTable.$converterclotn.toJson(clot),
      ),
      'odourChange': serializer.toJson<String?>(odourChange),
    };
  }

  FluidObservation copyWith({
    String? id,
    String? localDate,
    Value<String?> localTime = const Value.absent(),
    String? source,
    Value<String?> notes = const Value.absent(),
    String? createdAt,
    String? updatedAt,
    List<String>? materialTypes,
    List<String>? colours,
    Value<String?> amount = const Value.absent(),
    List<String>? textures,
    String? bloodPresence,
    List<String>? visibilityContexts,
    Value<ClotObservation?> clot = const Value.absent(),
    Value<String?> odourChange = const Value.absent(),
  }) => FluidObservation(
    id: id ?? this.id,
    localDate: localDate ?? this.localDate,
    localTime: localTime.present ? localTime.value : this.localTime,
    source: source ?? this.source,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    materialTypes: materialTypes ?? this.materialTypes,
    colours: colours ?? this.colours,
    amount: amount.present ? amount.value : this.amount,
    textures: textures ?? this.textures,
    bloodPresence: bloodPresence ?? this.bloodPresence,
    visibilityContexts: visibilityContexts ?? this.visibilityContexts,
    clot: clot.present ? clot.value : this.clot,
    odourChange: odourChange.present ? odourChange.value : this.odourChange,
  );
  FluidObservation copyWithCompanion(FluidObservationsCompanion data) {
    return FluidObservation(
      id: data.id.present ? data.id.value : this.id,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      localTime: data.localTime.present ? data.localTime.value : this.localTime,
      source: data.source.present ? data.source.value : this.source,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      materialTypes: data.materialTypes.present
          ? data.materialTypes.value
          : this.materialTypes,
      colours: data.colours.present ? data.colours.value : this.colours,
      amount: data.amount.present ? data.amount.value : this.amount,
      textures: data.textures.present ? data.textures.value : this.textures,
      bloodPresence: data.bloodPresence.present
          ? data.bloodPresence.value
          : this.bloodPresence,
      visibilityContexts: data.visibilityContexts.present
          ? data.visibilityContexts.value
          : this.visibilityContexts,
      clot: data.clot.present ? data.clot.value : this.clot,
      odourChange: data.odourChange.present
          ? data.odourChange.value
          : this.odourChange,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FluidObservation(')
          ..write('id: $id, ')
          ..write('localDate: $localDate, ')
          ..write('localTime: $localTime, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('materialTypes: $materialTypes, ')
          ..write('colours: $colours, ')
          ..write('amount: $amount, ')
          ..write('textures: $textures, ')
          ..write('bloodPresence: $bloodPresence, ')
          ..write('visibilityContexts: $visibilityContexts, ')
          ..write('clot: $clot, ')
          ..write('odourChange: $odourChange')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localDate,
    localTime,
    source,
    notes,
    createdAt,
    updatedAt,
    materialTypes,
    colours,
    amount,
    textures,
    bloodPresence,
    visibilityContexts,
    clot,
    odourChange,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FluidObservation &&
          other.id == this.id &&
          other.localDate == this.localDate &&
          other.localTime == this.localTime &&
          other.source == this.source &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.materialTypes == this.materialTypes &&
          other.colours == this.colours &&
          other.amount == this.amount &&
          other.textures == this.textures &&
          other.bloodPresence == this.bloodPresence &&
          other.visibilityContexts == this.visibilityContexts &&
          other.clot == this.clot &&
          other.odourChange == this.odourChange);
}

class FluidObservationsCompanion extends UpdateCompanion<FluidObservation> {
  final Value<String> id;
  final Value<String> localDate;
  final Value<String?> localTime;
  final Value<String> source;
  final Value<String?> notes;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<List<String>> materialTypes;
  final Value<List<String>> colours;
  final Value<String?> amount;
  final Value<List<String>> textures;
  final Value<String> bloodPresence;
  final Value<List<String>> visibilityContexts;
  final Value<ClotObservation?> clot;
  final Value<String?> odourChange;
  final Value<int> rowid;
  const FluidObservationsCompanion({
    this.id = const Value.absent(),
    this.localDate = const Value.absent(),
    this.localTime = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.materialTypes = const Value.absent(),
    this.colours = const Value.absent(),
    this.amount = const Value.absent(),
    this.textures = const Value.absent(),
    this.bloodPresence = const Value.absent(),
    this.visibilityContexts = const Value.absent(),
    this.clot = const Value.absent(),
    this.odourChange = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FluidObservationsCompanion.insert({
    required String id,
    required String localDate,
    this.localTime = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.materialTypes = const Value.absent(),
    this.colours = const Value.absent(),
    this.amount = const Value.absent(),
    this.textures = const Value.absent(),
    this.bloodPresence = const Value.absent(),
    this.visibilityContexts = const Value.absent(),
    this.clot = const Value.absent(),
    this.odourChange = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       localDate = Value(localDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FluidObservation> custom({
    Expression<String>? id,
    Expression<String>? localDate,
    Expression<String>? localTime,
    Expression<String>? source,
    Expression<String>? notes,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? materialTypes,
    Expression<String>? colours,
    Expression<String>? amount,
    Expression<String>? textures,
    Expression<String>? bloodPresence,
    Expression<String>? visibilityContexts,
    Expression<String>? clot,
    Expression<String>? odourChange,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localDate != null) 'local_date': localDate,
      if (localTime != null) 'local_time': localTime,
      if (source != null) 'source': source,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (materialTypes != null) 'material_types': materialTypes,
      if (colours != null) 'colours': colours,
      if (amount != null) 'amount': amount,
      if (textures != null) 'textures': textures,
      if (bloodPresence != null) 'blood_presence': bloodPresence,
      if (visibilityContexts != null) 'visibility_contexts': visibilityContexts,
      if (clot != null) 'clot': clot,
      if (odourChange != null) 'odour_change': odourChange,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FluidObservationsCompanion copyWith({
    Value<String>? id,
    Value<String>? localDate,
    Value<String?>? localTime,
    Value<String>? source,
    Value<String?>? notes,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<List<String>>? materialTypes,
    Value<List<String>>? colours,
    Value<String?>? amount,
    Value<List<String>>? textures,
    Value<String>? bloodPresence,
    Value<List<String>>? visibilityContexts,
    Value<ClotObservation?>? clot,
    Value<String?>? odourChange,
    Value<int>? rowid,
  }) {
    return FluidObservationsCompanion(
      id: id ?? this.id,
      localDate: localDate ?? this.localDate,
      localTime: localTime ?? this.localTime,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      materialTypes: materialTypes ?? this.materialTypes,
      colours: colours ?? this.colours,
      amount: amount ?? this.amount,
      textures: textures ?? this.textures,
      bloodPresence: bloodPresence ?? this.bloodPresence,
      visibilityContexts: visibilityContexts ?? this.visibilityContexts,
      clot: clot ?? this.clot,
      odourChange: odourChange ?? this.odourChange,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (localTime.present) {
      map['local_time'] = Variable<String>(localTime.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (materialTypes.present) {
      map['material_types'] = Variable<String>(
        $FluidObservationsTable.$convertermaterialTypes.toSql(
          materialTypes.value,
        ),
      );
    }
    if (colours.present) {
      map['colours'] = Variable<String>(
        $FluidObservationsTable.$convertercolours.toSql(colours.value),
      );
    }
    if (amount.present) {
      map['amount'] = Variable<String>(amount.value);
    }
    if (textures.present) {
      map['textures'] = Variable<String>(
        $FluidObservationsTable.$convertertextures.toSql(textures.value),
      );
    }
    if (bloodPresence.present) {
      map['blood_presence'] = Variable<String>(bloodPresence.value);
    }
    if (visibilityContexts.present) {
      map['visibility_contexts'] = Variable<String>(
        $FluidObservationsTable.$convertervisibilityContexts.toSql(
          visibilityContexts.value,
        ),
      );
    }
    if (clot.present) {
      map['clot'] = Variable<String>(
        $FluidObservationsTable.$converterclotn.toSql(clot.value),
      );
    }
    if (odourChange.present) {
      map['odour_change'] = Variable<String>(odourChange.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FluidObservationsCompanion(')
          ..write('id: $id, ')
          ..write('localDate: $localDate, ')
          ..write('localTime: $localTime, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('materialTypes: $materialTypes, ')
          ..write('colours: $colours, ')
          ..write('amount: $amount, ')
          ..write('textures: $textures, ')
          ..write('bloodPresence: $bloodPresence, ')
          ..write('visibilityContexts: $visibilityContexts, ')
          ..write('clot: $clot, ')
          ..write('odourChange: $odourChange, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LibidoEventsTable extends LibidoEvents
    with TableInfo<$LibidoEventsTable, LibidoEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibidoEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localTimeMeta = const VerificationMeta(
    'localTime',
  );
  @override
  late final GeneratedColumn<String> localTime = GeneratedColumn<String>(
    'local_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('realtime'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localDate,
    localTime,
    source,
    notes,
    createdAt,
    updatedAt,
    direction,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'libido_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibidoEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('local_time')) {
      context.handle(
        _localTimeMeta,
        localTime.isAcceptableOrUnknown(data['local_time']!, _localTimeMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LibidoEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibidoEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      localTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_time'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
    );
  }

  @override
  $LibidoEventsTable createAlias(String alias) {
    return $LibidoEventsTable(attachedDatabase, alias);
  }
}

class LibidoEvent extends DataClass implements Insertable<LibidoEvent> {
  final String id;
  final String localDate;
  final String? localTime;
  final String source;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final String direction;
  const LibidoEvent({
    required this.id,
    required this.localDate,
    this.localTime,
    required this.source,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.direction,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['local_date'] = Variable<String>(localDate);
    if (!nullToAbsent || localTime != null) {
      map['local_time'] = Variable<String>(localTime);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['direction'] = Variable<String>(direction);
    return map;
  }

  LibidoEventsCompanion toCompanion(bool nullToAbsent) {
    return LibidoEventsCompanion(
      id: Value(id),
      localDate: Value(localDate),
      localTime: localTime == null && nullToAbsent
          ? const Value.absent()
          : Value(localTime),
      source: Value(source),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      direction: Value(direction),
    );
  }

  factory LibidoEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibidoEvent(
      id: serializer.fromJson<String>(json['id']),
      localDate: serializer.fromJson<String>(json['localDate']),
      localTime: serializer.fromJson<String?>(json['localTime']),
      source: serializer.fromJson<String>(json['source']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      direction: serializer.fromJson<String>(json['direction']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'localDate': serializer.toJson<String>(localDate),
      'localTime': serializer.toJson<String?>(localTime),
      'source': serializer.toJson<String>(source),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'direction': serializer.toJson<String>(direction),
    };
  }

  LibidoEvent copyWith({
    String? id,
    String? localDate,
    Value<String?> localTime = const Value.absent(),
    String? source,
    Value<String?> notes = const Value.absent(),
    String? createdAt,
    String? updatedAt,
    String? direction,
  }) => LibidoEvent(
    id: id ?? this.id,
    localDate: localDate ?? this.localDate,
    localTime: localTime.present ? localTime.value : this.localTime,
    source: source ?? this.source,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    direction: direction ?? this.direction,
  );
  LibidoEvent copyWithCompanion(LibidoEventsCompanion data) {
    return LibidoEvent(
      id: data.id.present ? data.id.value : this.id,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      localTime: data.localTime.present ? data.localTime.value : this.localTime,
      source: data.source.present ? data.source.value : this.source,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      direction: data.direction.present ? data.direction.value : this.direction,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibidoEvent(')
          ..write('id: $id, ')
          ..write('localDate: $localDate, ')
          ..write('localTime: $localTime, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('direction: $direction')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localDate,
    localTime,
    source,
    notes,
    createdAt,
    updatedAt,
    direction,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibidoEvent &&
          other.id == this.id &&
          other.localDate == this.localDate &&
          other.localTime == this.localTime &&
          other.source == this.source &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.direction == this.direction);
}

class LibidoEventsCompanion extends UpdateCompanion<LibidoEvent> {
  final Value<String> id;
  final Value<String> localDate;
  final Value<String?> localTime;
  final Value<String> source;
  final Value<String?> notes;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> direction;
  final Value<int> rowid;
  const LibidoEventsCompanion({
    this.id = const Value.absent(),
    this.localDate = const Value.absent(),
    this.localTime = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.direction = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LibidoEventsCompanion.insert({
    required String id,
    required String localDate,
    this.localTime = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    required String direction,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       localDate = Value(localDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       direction = Value(direction);
  static Insertable<LibidoEvent> custom({
    Expression<String>? id,
    Expression<String>? localDate,
    Expression<String>? localTime,
    Expression<String>? source,
    Expression<String>? notes,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? direction,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localDate != null) 'local_date': localDate,
      if (localTime != null) 'local_time': localTime,
      if (source != null) 'source': source,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (direction != null) 'direction': direction,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LibidoEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? localDate,
    Value<String?>? localTime,
    Value<String>? source,
    Value<String?>? notes,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String>? direction,
    Value<int>? rowid,
  }) {
    return LibidoEventsCompanion(
      id: id ?? this.id,
      localDate: localDate ?? this.localDate,
      localTime: localTime ?? this.localTime,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      direction: direction ?? this.direction,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (localTime.present) {
      map['local_time'] = Variable<String>(localTime.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibidoEventsCompanion(')
          ..write('id: $id, ')
          ..write('localDate: $localDate, ')
          ..write('localTime: $localTime, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('direction: $direction, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MoodEventsTable extends MoodEvents
    with TableInfo<$MoodEventsTable, MoodEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localTimeMeta = const VerificationMeta(
    'localTime',
  );
  @override
  late final GeneratedColumn<String> localTime = GeneratedColumn<String>(
    'local_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('realtime'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> categories =
      GeneratedColumn<String>(
        'categories',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($MoodEventsTable.$convertercategories);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localDate,
    localTime,
    source,
    notes,
    createdAt,
    updatedAt,
    categories,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('local_time')) {
      context.handle(
        _localTimeMeta,
        localTime.isAcceptableOrUnknown(data['local_time']!, _localTimeMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoodEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      localTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_time'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      categories: $MoodEventsTable.$convertercategories.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}categories'],
        )!,
      ),
    );
  }

  @override
  $MoodEventsTable createAlias(String alias) {
    return $MoodEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $convertercategories = const StringListConverter();
}

class MoodEvent extends DataClass implements Insertable<MoodEvent> {
  final String id;
  final String localDate;
  final String? localTime;
  final String source;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final List<String> categories;
  const MoodEvent({
    required this.id,
    required this.localDate,
    this.localTime,
    required this.source,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.categories,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['local_date'] = Variable<String>(localDate);
    if (!nullToAbsent || localTime != null) {
      map['local_time'] = Variable<String>(localTime);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    {
      map['categories'] = Variable<String>(
        $MoodEventsTable.$convertercategories.toSql(categories),
      );
    }
    return map;
  }

  MoodEventsCompanion toCompanion(bool nullToAbsent) {
    return MoodEventsCompanion(
      id: Value(id),
      localDate: Value(localDate),
      localTime: localTime == null && nullToAbsent
          ? const Value.absent()
          : Value(localTime),
      source: Value(source),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      categories: Value(categories),
    );
  }

  factory MoodEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodEvent(
      id: serializer.fromJson<String>(json['id']),
      localDate: serializer.fromJson<String>(json['localDate']),
      localTime: serializer.fromJson<String?>(json['localTime']),
      source: serializer.fromJson<String>(json['source']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      categories: $MoodEventsTable.$convertercategories.fromJson(
        serializer.fromJson<List<dynamic>>(json['categories']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'localDate': serializer.toJson<String>(localDate),
      'localTime': serializer.toJson<String?>(localTime),
      'source': serializer.toJson<String>(source),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'categories': serializer.toJson<List<dynamic>>(
        $MoodEventsTable.$convertercategories.toJson(categories),
      ),
    };
  }

  MoodEvent copyWith({
    String? id,
    String? localDate,
    Value<String?> localTime = const Value.absent(),
    String? source,
    Value<String?> notes = const Value.absent(),
    String? createdAt,
    String? updatedAt,
    List<String>? categories,
  }) => MoodEvent(
    id: id ?? this.id,
    localDate: localDate ?? this.localDate,
    localTime: localTime.present ? localTime.value : this.localTime,
    source: source ?? this.source,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    categories: categories ?? this.categories,
  );
  MoodEvent copyWithCompanion(MoodEventsCompanion data) {
    return MoodEvent(
      id: data.id.present ? data.id.value : this.id,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      localTime: data.localTime.present ? data.localTime.value : this.localTime,
      source: data.source.present ? data.source.value : this.source,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      categories: data.categories.present
          ? data.categories.value
          : this.categories,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodEvent(')
          ..write('id: $id, ')
          ..write('localDate: $localDate, ')
          ..write('localTime: $localTime, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('categories: $categories')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localDate,
    localTime,
    source,
    notes,
    createdAt,
    updatedAt,
    categories,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodEvent &&
          other.id == this.id &&
          other.localDate == this.localDate &&
          other.localTime == this.localTime &&
          other.source == this.source &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.categories == this.categories);
}

class MoodEventsCompanion extends UpdateCompanion<MoodEvent> {
  final Value<String> id;
  final Value<String> localDate;
  final Value<String?> localTime;
  final Value<String> source;
  final Value<String?> notes;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<List<String>> categories;
  final Value<int> rowid;
  const MoodEventsCompanion({
    this.id = const Value.absent(),
    this.localDate = const Value.absent(),
    this.localTime = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.categories = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MoodEventsCompanion.insert({
    required String id,
    required String localDate,
    this.localTime = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.categories = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       localDate = Value(localDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MoodEvent> custom({
    Expression<String>? id,
    Expression<String>? localDate,
    Expression<String>? localTime,
    Expression<String>? source,
    Expression<String>? notes,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? categories,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localDate != null) 'local_date': localDate,
      if (localTime != null) 'local_time': localTime,
      if (source != null) 'source': source,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (categories != null) 'categories': categories,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MoodEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? localDate,
    Value<String?>? localTime,
    Value<String>? source,
    Value<String?>? notes,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<List<String>>? categories,
    Value<int>? rowid,
  }) {
    return MoodEventsCompanion(
      id: id ?? this.id,
      localDate: localDate ?? this.localDate,
      localTime: localTime ?? this.localTime,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      categories: categories ?? this.categories,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (localTime.present) {
      map['local_time'] = Variable<String>(localTime.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (categories.present) {
      map['categories'] = Variable<String>(
        $MoodEventsTable.$convertercategories.toSql(categories.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodEventsCompanion(')
          ..write('id: $id, ')
          ..write('localDate: $localDate, ')
          ..write('localTime: $localTime, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('categories: $categories, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PhysicalSymptomsTable extends PhysicalSymptoms
    with TableInfo<$PhysicalSymptomsTable, PhysicalSymptom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhysicalSymptomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localTimeMeta = const VerificationMeta(
    'localTime',
  );
  @override
  late final GeneratedColumn<String> localTime = GeneratedColumn<String>(
    'local_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('realtime'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symptomTypeMeta = const VerificationMeta(
    'symptomType',
  );
  @override
  late final GeneratedColumn<String> symptomType = GeneratedColumn<String>(
    'symptom_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<int> severity = GeneratedColumn<int>(
    'severity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> locations =
      GeneratedColumn<String>(
        'locations',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($PhysicalSymptomsTable.$converterlocations);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> qualities =
      GeneratedColumn<String>(
        'qualities',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($PhysicalSymptomsTable.$converterqualities);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localDate,
    localTime,
    source,
    notes,
    createdAt,
    updatedAt,
    symptomType,
    severity,
    locations,
    qualities,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'physical_symptoms';
  @override
  VerificationContext validateIntegrity(
    Insertable<PhysicalSymptom> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('local_time')) {
      context.handle(
        _localTimeMeta,
        localTime.isAcceptableOrUnknown(data['local_time']!, _localTimeMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('symptom_type')) {
      context.handle(
        _symptomTypeMeta,
        symptomType.isAcceptableOrUnknown(
          data['symptom_type']!,
          _symptomTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_symptomTypeMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PhysicalSymptom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhysicalSymptom(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      localTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_time'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      symptomType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptom_type'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}severity'],
      ),
      locations: $PhysicalSymptomsTable.$converterlocations.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}locations'],
        )!,
      ),
      qualities: $PhysicalSymptomsTable.$converterqualities.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}qualities'],
        )!,
      ),
    );
  }

  @override
  $PhysicalSymptomsTable createAlias(String alias) {
    return $PhysicalSymptomsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $converterlocations = const StringListConverter();
  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $converterqualities = const StringListConverter();
}

class PhysicalSymptom extends DataClass implements Insertable<PhysicalSymptom> {
  final String id;
  final String localDate;
  final String? localTime;
  final String source;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final String symptomType;
  final int? severity;
  final List<String> locations;
  final List<String> qualities;
  const PhysicalSymptom({
    required this.id,
    required this.localDate,
    this.localTime,
    required this.source,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.symptomType,
    this.severity,
    required this.locations,
    required this.qualities,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['local_date'] = Variable<String>(localDate);
    if (!nullToAbsent || localTime != null) {
      map['local_time'] = Variable<String>(localTime);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['symptom_type'] = Variable<String>(symptomType);
    if (!nullToAbsent || severity != null) {
      map['severity'] = Variable<int>(severity);
    }
    {
      map['locations'] = Variable<String>(
        $PhysicalSymptomsTable.$converterlocations.toSql(locations),
      );
    }
    {
      map['qualities'] = Variable<String>(
        $PhysicalSymptomsTable.$converterqualities.toSql(qualities),
      );
    }
    return map;
  }

  PhysicalSymptomsCompanion toCompanion(bool nullToAbsent) {
    return PhysicalSymptomsCompanion(
      id: Value(id),
      localDate: Value(localDate),
      localTime: localTime == null && nullToAbsent
          ? const Value.absent()
          : Value(localTime),
      source: Value(source),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      symptomType: Value(symptomType),
      severity: severity == null && nullToAbsent
          ? const Value.absent()
          : Value(severity),
      locations: Value(locations),
      qualities: Value(qualities),
    );
  }

  factory PhysicalSymptom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhysicalSymptom(
      id: serializer.fromJson<String>(json['id']),
      localDate: serializer.fromJson<String>(json['localDate']),
      localTime: serializer.fromJson<String?>(json['localTime']),
      source: serializer.fromJson<String>(json['source']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      symptomType: serializer.fromJson<String>(json['symptomType']),
      severity: serializer.fromJson<int?>(json['severity']),
      locations: $PhysicalSymptomsTable.$converterlocations.fromJson(
        serializer.fromJson<List<dynamic>>(json['locations']),
      ),
      qualities: $PhysicalSymptomsTable.$converterqualities.fromJson(
        serializer.fromJson<List<dynamic>>(json['qualities']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'localDate': serializer.toJson<String>(localDate),
      'localTime': serializer.toJson<String?>(localTime),
      'source': serializer.toJson<String>(source),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'symptomType': serializer.toJson<String>(symptomType),
      'severity': serializer.toJson<int?>(severity),
      'locations': serializer.toJson<List<dynamic>>(
        $PhysicalSymptomsTable.$converterlocations.toJson(locations),
      ),
      'qualities': serializer.toJson<List<dynamic>>(
        $PhysicalSymptomsTable.$converterqualities.toJson(qualities),
      ),
    };
  }

  PhysicalSymptom copyWith({
    String? id,
    String? localDate,
    Value<String?> localTime = const Value.absent(),
    String? source,
    Value<String?> notes = const Value.absent(),
    String? createdAt,
    String? updatedAt,
    String? symptomType,
    Value<int?> severity = const Value.absent(),
    List<String>? locations,
    List<String>? qualities,
  }) => PhysicalSymptom(
    id: id ?? this.id,
    localDate: localDate ?? this.localDate,
    localTime: localTime.present ? localTime.value : this.localTime,
    source: source ?? this.source,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    symptomType: symptomType ?? this.symptomType,
    severity: severity.present ? severity.value : this.severity,
    locations: locations ?? this.locations,
    qualities: qualities ?? this.qualities,
  );
  PhysicalSymptom copyWithCompanion(PhysicalSymptomsCompanion data) {
    return PhysicalSymptom(
      id: data.id.present ? data.id.value : this.id,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      localTime: data.localTime.present ? data.localTime.value : this.localTime,
      source: data.source.present ? data.source.value : this.source,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      symptomType: data.symptomType.present
          ? data.symptomType.value
          : this.symptomType,
      severity: data.severity.present ? data.severity.value : this.severity,
      locations: data.locations.present ? data.locations.value : this.locations,
      qualities: data.qualities.present ? data.qualities.value : this.qualities,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhysicalSymptom(')
          ..write('id: $id, ')
          ..write('localDate: $localDate, ')
          ..write('localTime: $localTime, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('symptomType: $symptomType, ')
          ..write('severity: $severity, ')
          ..write('locations: $locations, ')
          ..write('qualities: $qualities')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localDate,
    localTime,
    source,
    notes,
    createdAt,
    updatedAt,
    symptomType,
    severity,
    locations,
    qualities,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhysicalSymptom &&
          other.id == this.id &&
          other.localDate == this.localDate &&
          other.localTime == this.localTime &&
          other.source == this.source &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.symptomType == this.symptomType &&
          other.severity == this.severity &&
          other.locations == this.locations &&
          other.qualities == this.qualities);
}

class PhysicalSymptomsCompanion extends UpdateCompanion<PhysicalSymptom> {
  final Value<String> id;
  final Value<String> localDate;
  final Value<String?> localTime;
  final Value<String> source;
  final Value<String?> notes;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> symptomType;
  final Value<int?> severity;
  final Value<List<String>> locations;
  final Value<List<String>> qualities;
  final Value<int> rowid;
  const PhysicalSymptomsCompanion({
    this.id = const Value.absent(),
    this.localDate = const Value.absent(),
    this.localTime = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.symptomType = const Value.absent(),
    this.severity = const Value.absent(),
    this.locations = const Value.absent(),
    this.qualities = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhysicalSymptomsCompanion.insert({
    required String id,
    required String localDate,
    this.localTime = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    required String symptomType,
    this.severity = const Value.absent(),
    this.locations = const Value.absent(),
    this.qualities = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       localDate = Value(localDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       symptomType = Value(symptomType);
  static Insertable<PhysicalSymptom> custom({
    Expression<String>? id,
    Expression<String>? localDate,
    Expression<String>? localTime,
    Expression<String>? source,
    Expression<String>? notes,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? symptomType,
    Expression<int>? severity,
    Expression<String>? locations,
    Expression<String>? qualities,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localDate != null) 'local_date': localDate,
      if (localTime != null) 'local_time': localTime,
      if (source != null) 'source': source,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (symptomType != null) 'symptom_type': symptomType,
      if (severity != null) 'severity': severity,
      if (locations != null) 'locations': locations,
      if (qualities != null) 'qualities': qualities,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhysicalSymptomsCompanion copyWith({
    Value<String>? id,
    Value<String>? localDate,
    Value<String?>? localTime,
    Value<String>? source,
    Value<String?>? notes,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String>? symptomType,
    Value<int?>? severity,
    Value<List<String>>? locations,
    Value<List<String>>? qualities,
    Value<int>? rowid,
  }) {
    return PhysicalSymptomsCompanion(
      id: id ?? this.id,
      localDate: localDate ?? this.localDate,
      localTime: localTime ?? this.localTime,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      symptomType: symptomType ?? this.symptomType,
      severity: severity ?? this.severity,
      locations: locations ?? this.locations,
      qualities: qualities ?? this.qualities,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (localTime.present) {
      map['local_time'] = Variable<String>(localTime.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (symptomType.present) {
      map['symptom_type'] = Variable<String>(symptomType.value);
    }
    if (severity.present) {
      map['severity'] = Variable<int>(severity.value);
    }
    if (locations.present) {
      map['locations'] = Variable<String>(
        $PhysicalSymptomsTable.$converterlocations.toSql(locations.value),
      );
    }
    if (qualities.present) {
      map['qualities'] = Variable<String>(
        $PhysicalSymptomsTable.$converterqualities.toSql(qualities.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhysicalSymptomsCompanion(')
          ..write('id: $id, ')
          ..write('localDate: $localDate, ')
          ..write('localTime: $localTime, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('symptomType: $symptomType, ')
          ..write('severity: $severity, ')
          ..write('locations: $locations, ')
          ..write('qualities: $qualities, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContextEventsTable extends ContextEvents
    with TableInfo<$ContextEventsTable, ContextEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContextEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datePrecisionMeta = const VerificationMeta(
    'datePrecision',
  );
  @override
  late final GeneratedColumn<String> datePrecision = GeneratedColumn<String>(
    'date_precision',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('exact'),
  );
  static const VerificationMeta _dateStartMeta = const VerificationMeta(
    'dateStart',
  );
  @override
  late final GeneratedColumn<String> dateStart = GeneratedColumn<String>(
    'date_start',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateEndMeta = const VerificationMeta(
    'dateEnd',
  );
  @override
  late final GeneratedColumn<String> dateEnd = GeneratedColumn<String>(
    'date_end',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    datePrecision,
    dateStart,
    dateEnd,
    type,
    title,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'context_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContextEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date_precision')) {
      context.handle(
        _datePrecisionMeta,
        datePrecision.isAcceptableOrUnknown(
          data['date_precision']!,
          _datePrecisionMeta,
        ),
      );
    }
    if (data.containsKey('date_start')) {
      context.handle(
        _dateStartMeta,
        dateStart.isAcceptableOrUnknown(data['date_start']!, _dateStartMeta),
      );
    } else if (isInserting) {
      context.missing(_dateStartMeta);
    }
    if (data.containsKey('date_end')) {
      context.handle(
        _dateEndMeta,
        dateEnd.isAcceptableOrUnknown(data['date_end']!, _dateEndMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContextEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContextEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      datePrecision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_precision'],
      )!,
      dateStart: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_start'],
      )!,
      dateEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_end'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ContextEventsTable createAlias(String alias) {
    return $ContextEventsTable(attachedDatabase, alias);
  }
}

class ContextEvent extends DataClass implements Insertable<ContextEvent> {
  final String id;
  final String datePrecision;
  final String dateStart;
  final String? dateEnd;
  final String type;
  final String title;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  const ContextEvent({
    required this.id,
    required this.datePrecision,
    required this.dateStart,
    this.dateEnd,
    required this.type,
    required this.title,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date_precision'] = Variable<String>(datePrecision);
    map['date_start'] = Variable<String>(dateStart);
    if (!nullToAbsent || dateEnd != null) {
      map['date_end'] = Variable<String>(dateEnd);
    }
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  ContextEventsCompanion toCompanion(bool nullToAbsent) {
    return ContextEventsCompanion(
      id: Value(id),
      datePrecision: Value(datePrecision),
      dateStart: Value(dateStart),
      dateEnd: dateEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(dateEnd),
      type: Value(type),
      title: Value(title),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ContextEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContextEvent(
      id: serializer.fromJson<String>(json['id']),
      datePrecision: serializer.fromJson<String>(json['datePrecision']),
      dateStart: serializer.fromJson<String>(json['dateStart']),
      dateEnd: serializer.fromJson<String?>(json['dateEnd']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'datePrecision': serializer.toJson<String>(datePrecision),
      'dateStart': serializer.toJson<String>(dateStart),
      'dateEnd': serializer.toJson<String?>(dateEnd),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  ContextEvent copyWith({
    String? id,
    String? datePrecision,
    String? dateStart,
    Value<String?> dateEnd = const Value.absent(),
    String? type,
    String? title,
    Value<String?> notes = const Value.absent(),
    String? createdAt,
    String? updatedAt,
  }) => ContextEvent(
    id: id ?? this.id,
    datePrecision: datePrecision ?? this.datePrecision,
    dateStart: dateStart ?? this.dateStart,
    dateEnd: dateEnd.present ? dateEnd.value : this.dateEnd,
    type: type ?? this.type,
    title: title ?? this.title,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ContextEvent copyWithCompanion(ContextEventsCompanion data) {
    return ContextEvent(
      id: data.id.present ? data.id.value : this.id,
      datePrecision: data.datePrecision.present
          ? data.datePrecision.value
          : this.datePrecision,
      dateStart: data.dateStart.present ? data.dateStart.value : this.dateStart,
      dateEnd: data.dateEnd.present ? data.dateEnd.value : this.dateEnd,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContextEvent(')
          ..write('id: $id, ')
          ..write('datePrecision: $datePrecision, ')
          ..write('dateStart: $dateStart, ')
          ..write('dateEnd: $dateEnd, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    datePrecision,
    dateStart,
    dateEnd,
    type,
    title,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContextEvent &&
          other.id == this.id &&
          other.datePrecision == this.datePrecision &&
          other.dateStart == this.dateStart &&
          other.dateEnd == this.dateEnd &&
          other.type == this.type &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ContextEventsCompanion extends UpdateCompanion<ContextEvent> {
  final Value<String> id;
  final Value<String> datePrecision;
  final Value<String> dateStart;
  final Value<String?> dateEnd;
  final Value<String> type;
  final Value<String> title;
  final Value<String?> notes;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const ContextEventsCompanion({
    this.id = const Value.absent(),
    this.datePrecision = const Value.absent(),
    this.dateStart = const Value.absent(),
    this.dateEnd = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContextEventsCompanion.insert({
    required String id,
    this.datePrecision = const Value.absent(),
    required String dateStart,
    this.dateEnd = const Value.absent(),
    required String type,
    required String title,
    this.notes = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dateStart = Value(dateStart),
       type = Value(type),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ContextEvent> custom({
    Expression<String>? id,
    Expression<String>? datePrecision,
    Expression<String>? dateStart,
    Expression<String>? dateEnd,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (datePrecision != null) 'date_precision': datePrecision,
      if (dateStart != null) 'date_start': dateStart,
      if (dateEnd != null) 'date_end': dateEnd,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContextEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? datePrecision,
    Value<String>? dateStart,
    Value<String?>? dateEnd,
    Value<String>? type,
    Value<String>? title,
    Value<String?>? notes,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return ContextEventsCompanion(
      id: id ?? this.id,
      datePrecision: datePrecision ?? this.datePrecision,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      type: type ?? this.type,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (datePrecision.present) {
      map['date_precision'] = Variable<String>(datePrecision.value);
    }
    if (dateStart.present) {
      map['date_start'] = Variable<String>(dateStart.value);
    }
    if (dateEnd.present) {
      map['date_end'] = Variable<String>(dateEnd.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContextEventsCompanion(')
          ..write('id: $id, ')
          ..write('datePrecision: $datePrecision, ')
          ..write('dateStart: $dateStart, ')
          ..write('dateEnd: $dateEnd, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EpisodesTable extends Episodes with TableInfo<$EpisodesTable, Episode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EpisodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  observationIds = GeneratedColumn<String>(
    'observation_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<String>>($EpisodesTable.$converterobservationIds);
  static const VerificationMeta _interpretationMeta = const VerificationMeta(
    'interpretation',
  );
  @override
  late final GeneratedColumn<String> interpretation = GeneratedColumn<String>(
    'interpretation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startDate,
    endDate,
    observationIds,
    interpretation,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'episodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Episode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('interpretation')) {
      context.handle(
        _interpretationMeta,
        interpretation.isAcceptableOrUnknown(
          data['interpretation']!,
          _interpretationMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Episode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Episode(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      ),
      observationIds: $EpisodesTable.$converterobservationIds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}observation_ids'],
        )!,
      ),
      interpretation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}interpretation'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EpisodesTable createAlias(String alias) {
    return $EpisodesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $converterobservationIds = const StringListConverter();
}

class Episode extends DataClass implements Insertable<Episode> {
  final String id;
  final String startDate;
  final String? endDate;
  final List<String> observationIds;
  final String? interpretation;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  const Episode({
    required this.id,
    required this.startDate,
    this.endDate,
    required this.observationIds,
    this.interpretation,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['start_date'] = Variable<String>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    {
      map['observation_ids'] = Variable<String>(
        $EpisodesTable.$converterobservationIds.toSql(observationIds),
      );
    }
    if (!nullToAbsent || interpretation != null) {
      map['interpretation'] = Variable<String>(interpretation);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  EpisodesCompanion toCompanion(bool nullToAbsent) {
    return EpisodesCompanion(
      id: Value(id),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      observationIds: Value(observationIds),
      interpretation: interpretation == null && nullToAbsent
          ? const Value.absent()
          : Value(interpretation),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Episode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Episode(
      id: serializer.fromJson<String>(json['id']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      observationIds: $EpisodesTable.$converterobservationIds.fromJson(
        serializer.fromJson<List<dynamic>>(json['observationIds']),
      ),
      interpretation: serializer.fromJson<String?>(json['interpretation']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'observationIds': serializer.toJson<List<dynamic>>(
        $EpisodesTable.$converterobservationIds.toJson(observationIds),
      ),
      'interpretation': serializer.toJson<String?>(interpretation),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Episode copyWith({
    String? id,
    String? startDate,
    Value<String?> endDate = const Value.absent(),
    List<String>? observationIds,
    Value<String?> interpretation = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? createdAt,
    String? updatedAt,
  }) => Episode(
    id: id ?? this.id,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    observationIds: observationIds ?? this.observationIds,
    interpretation: interpretation.present
        ? interpretation.value
        : this.interpretation,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Episode copyWithCompanion(EpisodesCompanion data) {
    return Episode(
      id: data.id.present ? data.id.value : this.id,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      observationIds: data.observationIds.present
          ? data.observationIds.value
          : this.observationIds,
      interpretation: data.interpretation.present
          ? data.interpretation.value
          : this.interpretation,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Episode(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('observationIds: $observationIds, ')
          ..write('interpretation: $interpretation, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startDate,
    endDate,
    observationIds,
    interpretation,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Episode &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.observationIds == this.observationIds &&
          other.interpretation == this.interpretation &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EpisodesCompanion extends UpdateCompanion<Episode> {
  final Value<String> id;
  final Value<String> startDate;
  final Value<String?> endDate;
  final Value<List<String>> observationIds;
  final Value<String?> interpretation;
  final Value<String?> notes;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const EpisodesCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.observationIds = const Value.absent(),
    this.interpretation = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EpisodesCompanion.insert({
    required String id,
    required String startDate,
    this.endDate = const Value.absent(),
    this.observationIds = const Value.absent(),
    this.interpretation = const Value.absent(),
    this.notes = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startDate = Value(startDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Episode> custom({
    Expression<String>? id,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<String>? observationIds,
    Expression<String>? interpretation,
    Expression<String>? notes,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (observationIds != null) 'observation_ids': observationIds,
      if (interpretation != null) 'interpretation': interpretation,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EpisodesCompanion copyWith({
    Value<String>? id,
    Value<String>? startDate,
    Value<String?>? endDate,
    Value<List<String>>? observationIds,
    Value<String?>? interpretation,
    Value<String?>? notes,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return EpisodesCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      observationIds: observationIds ?? this.observationIds,
      interpretation: interpretation ?? this.interpretation,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (observationIds.present) {
      map['observation_ids'] = Variable<String>(
        $EpisodesTable.$converterobservationIds.toSql(observationIds.value),
      );
    }
    if (interpretation.present) {
      map['interpretation'] = Variable<String>(interpretation.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EpisodesCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('observationIds: $observationIds, ')
          ..write('interpretation: $interpretation, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DayCheckInsTable dayCheckIns = $DayCheckInsTable(this);
  late final $DailyNotesTable dailyNotes = $DailyNotesTable(this);
  late final $FluidObservationsTable fluidObservations =
      $FluidObservationsTable(this);
  late final $LibidoEventsTable libidoEvents = $LibidoEventsTable(this);
  late final $MoodEventsTable moodEvents = $MoodEventsTable(this);
  late final $PhysicalSymptomsTable physicalSymptoms = $PhysicalSymptomsTable(
    this,
  );
  late final $ContextEventsTable contextEvents = $ContextEventsTable(this);
  late final $EpisodesTable episodes = $EpisodesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dayCheckIns,
    dailyNotes,
    fluidObservations,
    libidoEvents,
    moodEvents,
    physicalSymptoms,
    contextEvents,
    episodes,
    settings,
  ];
}

typedef $$DayCheckInsTableCreateCompanionBuilder =
    DayCheckInsCompanion Function({
      required String localDate,
      Value<String> status,
      required String confirmedAt,
      Value<int> rowid,
    });
typedef $$DayCheckInsTableUpdateCompanionBuilder =
    DayCheckInsCompanion Function({
      Value<String> localDate,
      Value<String> status,
      Value<String> confirmedAt,
      Value<int> rowid,
    });

class $$DayCheckInsTableFilterComposer
    extends Composer<_$AppDatabase, $DayCheckInsTable> {
  $$DayCheckInsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DayCheckInsTableOrderingComposer
    extends Composer<_$AppDatabase, $DayCheckInsTable> {
  $$DayCheckInsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DayCheckInsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayCheckInsTable> {
  $$DayCheckInsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => column,
  );
}

class $$DayCheckInsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DayCheckInsTable,
          DayCheckIn,
          $$DayCheckInsTableFilterComposer,
          $$DayCheckInsTableOrderingComposer,
          $$DayCheckInsTableAnnotationComposer,
          $$DayCheckInsTableCreateCompanionBuilder,
          $$DayCheckInsTableUpdateCompanionBuilder,
          (
            DayCheckIn,
            BaseReferences<_$AppDatabase, $DayCheckInsTable, DayCheckIn>,
          ),
          DayCheckIn,
          PrefetchHooks Function()
        > {
  $$DayCheckInsTableTableManager(_$AppDatabase db, $DayCheckInsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayCheckInsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayCheckInsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayCheckInsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> confirmedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayCheckInsCompanion(
                localDate: localDate,
                status: status,
                confirmedAt: confirmedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localDate,
                Value<String> status = const Value.absent(),
                required String confirmedAt,
                Value<int> rowid = const Value.absent(),
              }) => DayCheckInsCompanion.insert(
                localDate: localDate,
                status: status,
                confirmedAt: confirmedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DayCheckInsTable, DayCheckIn>(table),
                  BaseReferences<_$AppDatabase, $DayCheckInsTable, DayCheckIn>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DayCheckInsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DayCheckInsTable,
      DayCheckIn,
      $$DayCheckInsTableFilterComposer,
      $$DayCheckInsTableOrderingComposer,
      $$DayCheckInsTableAnnotationComposer,
      $$DayCheckInsTableCreateCompanionBuilder,
      $$DayCheckInsTableUpdateCompanionBuilder,
      (
        DayCheckIn,
        BaseReferences<_$AppDatabase, $DayCheckInsTable, DayCheckIn>,
      ),
      DayCheckIn,
      PrefetchHooks Function()
    >;
typedef $$DailyNotesTableCreateCompanionBuilder =
    DailyNotesCompanion Function({
      required String localDate,
      required String text_,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$DailyNotesTableUpdateCompanionBuilder =
    DailyNotesCompanion Function({
      Value<String> localDate,
      Value<String> text_,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$DailyNotesTableFilterComposer
    extends Composer<_$AppDatabase, $DailyNotesTable> {
  $$DailyNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get text_ => $composableBuilder(
    column: $table.text_,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyNotesTable> {
  $$DailyNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get text_ => $composableBuilder(
    column: $table.text_,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyNotesTable> {
  $$DailyNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get text_ =>
      $composableBuilder(column: $table.text_, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyNotesTable,
          DailyNote,
          $$DailyNotesTableFilterComposer,
          $$DailyNotesTableOrderingComposer,
          $$DailyNotesTableAnnotationComposer,
          $$DailyNotesTableCreateCompanionBuilder,
          $$DailyNotesTableUpdateCompanionBuilder,
          (
            DailyNote,
            BaseReferences<_$AppDatabase, $DailyNotesTable, DailyNote>,
          ),
          DailyNote,
          PrefetchHooks Function()
        > {
  $$DailyNotesTableTableManager(_$AppDatabase db, $DailyNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localDate = const Value.absent(),
                Value<String> text_ = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyNotesCompanion(
                localDate: localDate,
                text_: text_,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localDate,
                required String text_,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DailyNotesCompanion.insert(
                localDate: localDate,
                text_: text_,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyNotesTable, DailyNote>(table),
                  BaseReferences<_$AppDatabase, $DailyNotesTable, DailyNote>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyNotesTable,
      DailyNote,
      $$DailyNotesTableFilterComposer,
      $$DailyNotesTableOrderingComposer,
      $$DailyNotesTableAnnotationComposer,
      $$DailyNotesTableCreateCompanionBuilder,
      $$DailyNotesTableUpdateCompanionBuilder,
      (DailyNote, BaseReferences<_$AppDatabase, $DailyNotesTable, DailyNote>),
      DailyNote,
      PrefetchHooks Function()
    >;
typedef $$FluidObservationsTableCreateCompanionBuilder =
    FluidObservationsCompanion Function({
      required String id,
      required String localDate,
      Value<String?> localTime,
      Value<String> source,
      Value<String?> notes,
      required String createdAt,
      required String updatedAt,
      Value<List<String>> materialTypes,
      Value<List<String>> colours,
      Value<String?> amount,
      Value<List<String>> textures,
      Value<String> bloodPresence,
      Value<List<String>> visibilityContexts,
      Value<ClotObservation?> clot,
      Value<String?> odourChange,
      Value<int> rowid,
    });
typedef $$FluidObservationsTableUpdateCompanionBuilder =
    FluidObservationsCompanion Function({
      Value<String> id,
      Value<String> localDate,
      Value<String?> localTime,
      Value<String> source,
      Value<String?> notes,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<List<String>> materialTypes,
      Value<List<String>> colours,
      Value<String?> amount,
      Value<List<String>> textures,
      Value<String> bloodPresence,
      Value<List<String>> visibilityContexts,
      Value<ClotObservation?> clot,
      Value<String?> odourChange,
      Value<int> rowid,
    });

class $$FluidObservationsTableFilterComposer
    extends Composer<_$AppDatabase, $FluidObservationsTable> {
  $$FluidObservationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localTime => $composableBuilder(
    column: $table.localTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get materialTypes => $composableBuilder(
    column: $table.materialTypes,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get colours => $composableBuilder(
    column: $table.colours,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get textures => $composableBuilder(
    column: $table.textures,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get bloodPresence => $composableBuilder(
    column: $table.bloodPresence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get visibilityContexts => $composableBuilder(
    column: $table.visibilityContexts,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ClotObservation?, ClotObservation, String>
  get clot => $composableBuilder(
    column: $table.clot,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get odourChange => $composableBuilder(
    column: $table.odourChange,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FluidObservationsTableOrderingComposer
    extends Composer<_$AppDatabase, $FluidObservationsTable> {
  $$FluidObservationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localTime => $composableBuilder(
    column: $table.localTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get materialTypes => $composableBuilder(
    column: $table.materialTypes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colours => $composableBuilder(
    column: $table.colours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textures => $composableBuilder(
    column: $table.textures,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bloodPresence => $composableBuilder(
    column: $table.bloodPresence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visibilityContexts => $composableBuilder(
    column: $table.visibilityContexts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clot => $composableBuilder(
    column: $table.clot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get odourChange => $composableBuilder(
    column: $table.odourChange,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FluidObservationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FluidObservationsTable> {
  $$FluidObservationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get localTime =>
      $composableBuilder(column: $table.localTime, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get materialTypes =>
      $composableBuilder(
        column: $table.materialTypes,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<String>, String> get colours =>
      $composableBuilder(column: $table.colours, builder: (column) => column);

  GeneratedColumn<String> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get textures =>
      $composableBuilder(column: $table.textures, builder: (column) => column);

  GeneratedColumn<String> get bloodPresence => $composableBuilder(
    column: $table.bloodPresence,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String>
  get visibilityContexts => $composableBuilder(
    column: $table.visibilityContexts,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ClotObservation?, String> get clot =>
      $composableBuilder(column: $table.clot, builder: (column) => column);

  GeneratedColumn<String> get odourChange => $composableBuilder(
    column: $table.odourChange,
    builder: (column) => column,
  );
}

class $$FluidObservationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FluidObservationsTable,
          FluidObservation,
          $$FluidObservationsTableFilterComposer,
          $$FluidObservationsTableOrderingComposer,
          $$FluidObservationsTableAnnotationComposer,
          $$FluidObservationsTableCreateCompanionBuilder,
          $$FluidObservationsTableUpdateCompanionBuilder,
          (
            FluidObservation,
            BaseReferences<
              _$AppDatabase,
              $FluidObservationsTable,
              FluidObservation
            >,
          ),
          FluidObservation,
          PrefetchHooks Function()
        > {
  $$FluidObservationsTableTableManager(
    _$AppDatabase db,
    $FluidObservationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FluidObservationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FluidObservationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FluidObservationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> localDate = const Value.absent(),
                Value<String?> localTime = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<List<String>> materialTypes = const Value.absent(),
                Value<List<String>> colours = const Value.absent(),
                Value<String?> amount = const Value.absent(),
                Value<List<String>> textures = const Value.absent(),
                Value<String> bloodPresence = const Value.absent(),
                Value<List<String>> visibilityContexts = const Value.absent(),
                Value<ClotObservation?> clot = const Value.absent(),
                Value<String?> odourChange = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FluidObservationsCompanion(
                id: id,
                localDate: localDate,
                localTime: localTime,
                source: source,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                materialTypes: materialTypes,
                colours: colours,
                amount: amount,
                textures: textures,
                bloodPresence: bloodPresence,
                visibilityContexts: visibilityContexts,
                clot: clot,
                odourChange: odourChange,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String localDate,
                Value<String?> localTime = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<List<String>> materialTypes = const Value.absent(),
                Value<List<String>> colours = const Value.absent(),
                Value<String?> amount = const Value.absent(),
                Value<List<String>> textures = const Value.absent(),
                Value<String> bloodPresence = const Value.absent(),
                Value<List<String>> visibilityContexts = const Value.absent(),
                Value<ClotObservation?> clot = const Value.absent(),
                Value<String?> odourChange = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FluidObservationsCompanion.insert(
                id: id,
                localDate: localDate,
                localTime: localTime,
                source: source,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                materialTypes: materialTypes,
                colours: colours,
                amount: amount,
                textures: textures,
                bloodPresence: bloodPresence,
                visibilityContexts: visibilityContexts,
                clot: clot,
                odourChange: odourChange,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FluidObservationsTable, FluidObservation>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $FluidObservationsTable,
                    FluidObservation
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FluidObservationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FluidObservationsTable,
      FluidObservation,
      $$FluidObservationsTableFilterComposer,
      $$FluidObservationsTableOrderingComposer,
      $$FluidObservationsTableAnnotationComposer,
      $$FluidObservationsTableCreateCompanionBuilder,
      $$FluidObservationsTableUpdateCompanionBuilder,
      (
        FluidObservation,
        BaseReferences<
          _$AppDatabase,
          $FluidObservationsTable,
          FluidObservation
        >,
      ),
      FluidObservation,
      PrefetchHooks Function()
    >;
typedef $$LibidoEventsTableCreateCompanionBuilder =
    LibidoEventsCompanion Function({
      required String id,
      required String localDate,
      Value<String?> localTime,
      Value<String> source,
      Value<String?> notes,
      required String createdAt,
      required String updatedAt,
      required String direction,
      Value<int> rowid,
    });
typedef $$LibidoEventsTableUpdateCompanionBuilder =
    LibidoEventsCompanion Function({
      Value<String> id,
      Value<String> localDate,
      Value<String?> localTime,
      Value<String> source,
      Value<String?> notes,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String> direction,
      Value<int> rowid,
    });

class $$LibidoEventsTableFilterComposer
    extends Composer<_$AppDatabase, $LibidoEventsTable> {
  $$LibidoEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localTime => $composableBuilder(
    column: $table.localTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LibidoEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $LibidoEventsTable> {
  $$LibidoEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localTime => $composableBuilder(
    column: $table.localTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LibidoEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LibidoEventsTable> {
  $$LibidoEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get localTime =>
      $composableBuilder(column: $table.localTime, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);
}

class $$LibidoEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LibidoEventsTable,
          LibidoEvent,
          $$LibidoEventsTableFilterComposer,
          $$LibidoEventsTableOrderingComposer,
          $$LibidoEventsTableAnnotationComposer,
          $$LibidoEventsTableCreateCompanionBuilder,
          $$LibidoEventsTableUpdateCompanionBuilder,
          (
            LibidoEvent,
            BaseReferences<_$AppDatabase, $LibidoEventsTable, LibidoEvent>,
          ),
          LibidoEvent,
          PrefetchHooks Function()
        > {
  $$LibidoEventsTableTableManager(_$AppDatabase db, $LibidoEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibidoEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibidoEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibidoEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> localDate = const Value.absent(),
                Value<String?> localTime = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LibidoEventsCompanion(
                id: id,
                localDate: localDate,
                localTime: localTime,
                source: source,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                direction: direction,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String localDate,
                Value<String?> localTime = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                required String direction,
                Value<int> rowid = const Value.absent(),
              }) => LibidoEventsCompanion.insert(
                id: id,
                localDate: localDate,
                localTime: localTime,
                source: source,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                direction: direction,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LibidoEventsTable, LibidoEvent>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LibidoEventsTable,
                    LibidoEvent
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LibidoEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LibidoEventsTable,
      LibidoEvent,
      $$LibidoEventsTableFilterComposer,
      $$LibidoEventsTableOrderingComposer,
      $$LibidoEventsTableAnnotationComposer,
      $$LibidoEventsTableCreateCompanionBuilder,
      $$LibidoEventsTableUpdateCompanionBuilder,
      (
        LibidoEvent,
        BaseReferences<_$AppDatabase, $LibidoEventsTable, LibidoEvent>,
      ),
      LibidoEvent,
      PrefetchHooks Function()
    >;
typedef $$MoodEventsTableCreateCompanionBuilder =
    MoodEventsCompanion Function({
      required String id,
      required String localDate,
      Value<String?> localTime,
      Value<String> source,
      Value<String?> notes,
      required String createdAt,
      required String updatedAt,
      Value<List<String>> categories,
      Value<int> rowid,
    });
typedef $$MoodEventsTableUpdateCompanionBuilder =
    MoodEventsCompanion Function({
      Value<String> id,
      Value<String> localDate,
      Value<String?> localTime,
      Value<String> source,
      Value<String?> notes,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<List<String>> categories,
      Value<int> rowid,
    });

class $$MoodEventsTableFilterComposer
    extends Composer<_$AppDatabase, $MoodEventsTable> {
  $$MoodEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localTime => $composableBuilder(
    column: $table.localTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get categories => $composableBuilder(
    column: $table.categories,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$MoodEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodEventsTable> {
  $$MoodEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localTime => $composableBuilder(
    column: $table.localTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categories => $composableBuilder(
    column: $table.categories,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoodEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodEventsTable> {
  $$MoodEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get localTime =>
      $composableBuilder(column: $table.localTime, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get categories =>
      $composableBuilder(
        column: $table.categories,
        builder: (column) => column,
      );
}

class $$MoodEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodEventsTable,
          MoodEvent,
          $$MoodEventsTableFilterComposer,
          $$MoodEventsTableOrderingComposer,
          $$MoodEventsTableAnnotationComposer,
          $$MoodEventsTableCreateCompanionBuilder,
          $$MoodEventsTableUpdateCompanionBuilder,
          (
            MoodEvent,
            BaseReferences<_$AppDatabase, $MoodEventsTable, MoodEvent>,
          ),
          MoodEvent,
          PrefetchHooks Function()
        > {
  $$MoodEventsTableTableManager(_$AppDatabase db, $MoodEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> localDate = const Value.absent(),
                Value<String?> localTime = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<List<String>> categories = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoodEventsCompanion(
                id: id,
                localDate: localDate,
                localTime: localTime,
                source: source,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                categories: categories,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String localDate,
                Value<String?> localTime = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<List<String>> categories = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoodEventsCompanion.insert(
                id: id,
                localDate: localDate,
                localTime: localTime,
                source: source,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                categories: categories,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MoodEventsTable, MoodEvent>(table),
                  BaseReferences<_$AppDatabase, $MoodEventsTable, MoodEvent>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MoodEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodEventsTable,
      MoodEvent,
      $$MoodEventsTableFilterComposer,
      $$MoodEventsTableOrderingComposer,
      $$MoodEventsTableAnnotationComposer,
      $$MoodEventsTableCreateCompanionBuilder,
      $$MoodEventsTableUpdateCompanionBuilder,
      (MoodEvent, BaseReferences<_$AppDatabase, $MoodEventsTable, MoodEvent>),
      MoodEvent,
      PrefetchHooks Function()
    >;
typedef $$PhysicalSymptomsTableCreateCompanionBuilder =
    PhysicalSymptomsCompanion Function({
      required String id,
      required String localDate,
      Value<String?> localTime,
      Value<String> source,
      Value<String?> notes,
      required String createdAt,
      required String updatedAt,
      required String symptomType,
      Value<int?> severity,
      Value<List<String>> locations,
      Value<List<String>> qualities,
      Value<int> rowid,
    });
typedef $$PhysicalSymptomsTableUpdateCompanionBuilder =
    PhysicalSymptomsCompanion Function({
      Value<String> id,
      Value<String> localDate,
      Value<String?> localTime,
      Value<String> source,
      Value<String?> notes,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String> symptomType,
      Value<int?> severity,
      Value<List<String>> locations,
      Value<List<String>> qualities,
      Value<int> rowid,
    });

class $$PhysicalSymptomsTableFilterComposer
    extends Composer<_$AppDatabase, $PhysicalSymptomsTable> {
  $$PhysicalSymptomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localTime => $composableBuilder(
    column: $table.localTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptomType => $composableBuilder(
    column: $table.symptomType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get locations => $composableBuilder(
    column: $table.locations,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get qualities => $composableBuilder(
    column: $table.qualities,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$PhysicalSymptomsTableOrderingComposer
    extends Composer<_$AppDatabase, $PhysicalSymptomsTable> {
  $$PhysicalSymptomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localTime => $composableBuilder(
    column: $table.localTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptomType => $composableBuilder(
    column: $table.symptomType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locations => $composableBuilder(
    column: $table.locations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qualities => $composableBuilder(
    column: $table.qualities,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PhysicalSymptomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhysicalSymptomsTable> {
  $$PhysicalSymptomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get localTime =>
      $composableBuilder(column: $table.localTime, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get symptomType => $composableBuilder(
    column: $table.symptomType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get locations =>
      $composableBuilder(column: $table.locations, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get qualities =>
      $composableBuilder(column: $table.qualities, builder: (column) => column);
}

class $$PhysicalSymptomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PhysicalSymptomsTable,
          PhysicalSymptom,
          $$PhysicalSymptomsTableFilterComposer,
          $$PhysicalSymptomsTableOrderingComposer,
          $$PhysicalSymptomsTableAnnotationComposer,
          $$PhysicalSymptomsTableCreateCompanionBuilder,
          $$PhysicalSymptomsTableUpdateCompanionBuilder,
          (
            PhysicalSymptom,
            BaseReferences<
              _$AppDatabase,
              $PhysicalSymptomsTable,
              PhysicalSymptom
            >,
          ),
          PhysicalSymptom,
          PrefetchHooks Function()
        > {
  $$PhysicalSymptomsTableTableManager(
    _$AppDatabase db,
    $PhysicalSymptomsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhysicalSymptomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhysicalSymptomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhysicalSymptomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> localDate = const Value.absent(),
                Value<String?> localTime = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String> symptomType = const Value.absent(),
                Value<int?> severity = const Value.absent(),
                Value<List<String>> locations = const Value.absent(),
                Value<List<String>> qualities = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PhysicalSymptomsCompanion(
                id: id,
                localDate: localDate,
                localTime: localTime,
                source: source,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                symptomType: symptomType,
                severity: severity,
                locations: locations,
                qualities: qualities,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String localDate,
                Value<String?> localTime = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                required String symptomType,
                Value<int?> severity = const Value.absent(),
                Value<List<String>> locations = const Value.absent(),
                Value<List<String>> qualities = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PhysicalSymptomsCompanion.insert(
                id: id,
                localDate: localDate,
                localTime: localTime,
                source: source,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                symptomType: symptomType,
                severity: severity,
                locations: locations,
                qualities: qualities,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PhysicalSymptomsTable, PhysicalSymptom>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PhysicalSymptomsTable,
                    PhysicalSymptom
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PhysicalSymptomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PhysicalSymptomsTable,
      PhysicalSymptom,
      $$PhysicalSymptomsTableFilterComposer,
      $$PhysicalSymptomsTableOrderingComposer,
      $$PhysicalSymptomsTableAnnotationComposer,
      $$PhysicalSymptomsTableCreateCompanionBuilder,
      $$PhysicalSymptomsTableUpdateCompanionBuilder,
      (
        PhysicalSymptom,
        BaseReferences<_$AppDatabase, $PhysicalSymptomsTable, PhysicalSymptom>,
      ),
      PhysicalSymptom,
      PrefetchHooks Function()
    >;
typedef $$ContextEventsTableCreateCompanionBuilder =
    ContextEventsCompanion Function({
      required String id,
      Value<String> datePrecision,
      required String dateStart,
      Value<String?> dateEnd,
      required String type,
      required String title,
      Value<String?> notes,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$ContextEventsTableUpdateCompanionBuilder =
    ContextEventsCompanion Function({
      Value<String> id,
      Value<String> datePrecision,
      Value<String> dateStart,
      Value<String?> dateEnd,
      Value<String> type,
      Value<String> title,
      Value<String?> notes,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$ContextEventsTableFilterComposer
    extends Composer<_$AppDatabase, $ContextEventsTable> {
  $$ContextEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datePrecision => $composableBuilder(
    column: $table.datePrecision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateStart => $composableBuilder(
    column: $table.dateStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateEnd => $composableBuilder(
    column: $table.dateEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContextEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContextEventsTable> {
  $$ContextEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datePrecision => $composableBuilder(
    column: $table.datePrecision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateStart => $composableBuilder(
    column: $table.dateStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateEnd => $composableBuilder(
    column: $table.dateEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContextEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContextEventsTable> {
  $$ContextEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get datePrecision => $composableBuilder(
    column: $table.datePrecision,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dateStart =>
      $composableBuilder(column: $table.dateStart, builder: (column) => column);

  GeneratedColumn<String> get dateEnd =>
      $composableBuilder(column: $table.dateEnd, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ContextEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContextEventsTable,
          ContextEvent,
          $$ContextEventsTableFilterComposer,
          $$ContextEventsTableOrderingComposer,
          $$ContextEventsTableAnnotationComposer,
          $$ContextEventsTableCreateCompanionBuilder,
          $$ContextEventsTableUpdateCompanionBuilder,
          (
            ContextEvent,
            BaseReferences<_$AppDatabase, $ContextEventsTable, ContextEvent>,
          ),
          ContextEvent,
          PrefetchHooks Function()
        > {
  $$ContextEventsTableTableManager(_$AppDatabase db, $ContextEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContextEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContextEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContextEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> datePrecision = const Value.absent(),
                Value<String> dateStart = const Value.absent(),
                Value<String?> dateEnd = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContextEventsCompanion(
                id: id,
                datePrecision: datePrecision,
                dateStart: dateStart,
                dateEnd: dateEnd,
                type: type,
                title: title,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> datePrecision = const Value.absent(),
                required String dateStart,
                Value<String?> dateEnd = const Value.absent(),
                required String type,
                required String title,
                Value<String?> notes = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ContextEventsCompanion.insert(
                id: id,
                datePrecision: datePrecision,
                dateStart: dateStart,
                dateEnd: dateEnd,
                type: type,
                title: title,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContextEventsTable, ContextEvent>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ContextEventsTable,
                    ContextEvent
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContextEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContextEventsTable,
      ContextEvent,
      $$ContextEventsTableFilterComposer,
      $$ContextEventsTableOrderingComposer,
      $$ContextEventsTableAnnotationComposer,
      $$ContextEventsTableCreateCompanionBuilder,
      $$ContextEventsTableUpdateCompanionBuilder,
      (
        ContextEvent,
        BaseReferences<_$AppDatabase, $ContextEventsTable, ContextEvent>,
      ),
      ContextEvent,
      PrefetchHooks Function()
    >;
typedef $$EpisodesTableCreateCompanionBuilder =
    EpisodesCompanion Function({
      required String id,
      required String startDate,
      Value<String?> endDate,
      Value<List<String>> observationIds,
      Value<String?> interpretation,
      Value<String?> notes,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$EpisodesTableUpdateCompanionBuilder =
    EpisodesCompanion Function({
      Value<String> id,
      Value<String> startDate,
      Value<String?> endDate,
      Value<List<String>> observationIds,
      Value<String?> interpretation,
      Value<String?> notes,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$EpisodesTableFilterComposer
    extends Composer<_$AppDatabase, $EpisodesTable> {
  $$EpisodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get observationIds => $composableBuilder(
    column: $table.observationIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get interpretation => $composableBuilder(
    column: $table.interpretation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EpisodesTableOrderingComposer
    extends Composer<_$AppDatabase, $EpisodesTable> {
  $$EpisodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observationIds => $composableBuilder(
    column: $table.observationIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get interpretation => $composableBuilder(
    column: $table.interpretation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EpisodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EpisodesTable> {
  $$EpisodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get observationIds =>
      $composableBuilder(
        column: $table.observationIds,
        builder: (column) => column,
      );

  GeneratedColumn<String> get interpretation => $composableBuilder(
    column: $table.interpretation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EpisodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EpisodesTable,
          Episode,
          $$EpisodesTableFilterComposer,
          $$EpisodesTableOrderingComposer,
          $$EpisodesTableAnnotationComposer,
          $$EpisodesTableCreateCompanionBuilder,
          $$EpisodesTableUpdateCompanionBuilder,
          (Episode, BaseReferences<_$AppDatabase, $EpisodesTable, Episode>),
          Episode,
          PrefetchHooks Function()
        > {
  $$EpisodesTableTableManager(_$AppDatabase db, $EpisodesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EpisodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EpisodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EpisodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<List<String>> observationIds = const Value.absent(),
                Value<String?> interpretation = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EpisodesCompanion(
                id: id,
                startDate: startDate,
                endDate: endDate,
                observationIds: observationIds,
                interpretation: interpretation,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String startDate,
                Value<String?> endDate = const Value.absent(),
                Value<List<String>> observationIds = const Value.absent(),
                Value<String?> interpretation = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => EpisodesCompanion.insert(
                id: id,
                startDate: startDate,
                endDate: endDate,
                observationIds: observationIds,
                interpretation: interpretation,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EpisodesTable, Episode>(table),
                  BaseReferences<_$AppDatabase, $EpisodesTable, Episode>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EpisodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EpisodesTable,
      Episode,
      $$EpisodesTableFilterComposer,
      $$EpisodesTableOrderingComposer,
      $$EpisodesTableAnnotationComposer,
      $$EpisodesTableCreateCompanionBuilder,
      $$EpisodesTableUpdateCompanionBuilder,
      (Episode, BaseReferences<_$AppDatabase, $EpisodesTable, Episode>),
      Episode,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DayCheckInsTableTableManager get dayCheckIns =>
      $$DayCheckInsTableTableManager(_db, _db.dayCheckIns);
  $$DailyNotesTableTableManager get dailyNotes =>
      $$DailyNotesTableTableManager(_db, _db.dailyNotes);
  $$FluidObservationsTableTableManager get fluidObservations =>
      $$FluidObservationsTableTableManager(_db, _db.fluidObservations);
  $$LibidoEventsTableTableManager get libidoEvents =>
      $$LibidoEventsTableTableManager(_db, _db.libidoEvents);
  $$MoodEventsTableTableManager get moodEvents =>
      $$MoodEventsTableTableManager(_db, _db.moodEvents);
  $$PhysicalSymptomsTableTableManager get physicalSymptoms =>
      $$PhysicalSymptomsTableTableManager(_db, _db.physicalSymptoms);
  $$ContextEventsTableTableManager get contextEvents =>
      $$ContextEventsTableTableManager(_db, _db.contextEvents);
  $$EpisodesTableTableManager get episodes =>
      $$EpisodesTableTableManager(_db, _db.episodes);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
