// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _passBookNoMeta =
      const VerificationMeta('passBookNo');
  @override
  late final GeneratedColumn<String> passBookNo = GeneratedColumn<String>(
      'pass_book_no', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _eqWtMeta = const VerificationMeta('eqWt');
  @override
  late final GeneratedColumn<double> eqWt = GeneratedColumn<double>(
      'eq_wt', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _receivedAmountMeta =
      const VerificationMeta('receivedAmount');
  @override
  late final GeneratedColumn<double> receivedAmount = GeneratedColumn<double>(
      'received_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _importedAtMeta =
      const VerificationMeta('importedAt');
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
      'imported_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        passBookNo,
        name,
        phone,
        amount,
        eqWt,
        receivedAmount,
        notes,
        importedAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pass_book_no')) {
      context.handle(
          _passBookNoMeta,
          passBookNo.isAcceptableOrUnknown(
              data['pass_book_no']!, _passBookNoMeta));
    } else if (isInserting) {
      context.missing(_passBookNoMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('eq_wt')) {
      context.handle(
          _eqWtMeta, eqWt.isAcceptableOrUnknown(data['eq_wt']!, _eqWtMeta));
    }
    if (data.containsKey('received_amount')) {
      context.handle(
          _receivedAmountMeta,
          receivedAmount.isAcceptableOrUnknown(
              data['received_amount']!, _receivedAmountMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('imported_at')) {
      context.handle(
          _importedAtMeta,
          importedAt.isAcceptableOrUnknown(
              data['imported_at']!, _importedAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {passBookNo},
      ];
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      passBookNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pass_book_no'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      eqWt: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}eq_wt'])!,
      receivedAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}received_amount'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      importedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}imported_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final String passBookNo;
  final String name;
  final String phone;
  final double amount;
  final double eqWt;
  final double receivedAmount;
  final String notes;
  final DateTime importedAt;
  final DateTime updatedAt;
  const Customer(
      {required this.id,
      required this.passBookNo,
      required this.name,
      required this.phone,
      required this.amount,
      required this.eqWt,
      required this.receivedAmount,
      required this.notes,
      required this.importedAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pass_book_no'] = Variable<String>(passBookNo);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['amount'] = Variable<double>(amount);
    map['eq_wt'] = Variable<double>(eqWt);
    map['received_amount'] = Variable<double>(receivedAmount);
    map['notes'] = Variable<String>(notes);
    map['imported_at'] = Variable<DateTime>(importedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      passBookNo: Value(passBookNo),
      name: Value(name),
      phone: Value(phone),
      amount: Value(amount),
      eqWt: Value(eqWt),
      receivedAmount: Value(receivedAmount),
      notes: Value(notes),
      importedAt: Value(importedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      passBookNo: serializer.fromJson<String>(json['passBookNo']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      amount: serializer.fromJson<double>(json['amount']),
      eqWt: serializer.fromJson<double>(json['eqWt']),
      receivedAmount: serializer.fromJson<double>(json['receivedAmount']),
      notes: serializer.fromJson<String>(json['notes']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'passBookNo': serializer.toJson<String>(passBookNo),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'amount': serializer.toJson<double>(amount),
      'eqWt': serializer.toJson<double>(eqWt),
      'receivedAmount': serializer.toJson<double>(receivedAmount),
      'notes': serializer.toJson<String>(notes),
      'importedAt': serializer.toJson<DateTime>(importedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Customer copyWith(
          {int? id,
          String? passBookNo,
          String? name,
          String? phone,
          double? amount,
          double? eqWt,
          double? receivedAmount,
          String? notes,
          DateTime? importedAt,
          DateTime? updatedAt}) =>
      Customer(
        id: id ?? this.id,
        passBookNo: passBookNo ?? this.passBookNo,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        amount: amount ?? this.amount,
        eqWt: eqWt ?? this.eqWt,
        receivedAmount: receivedAmount ?? this.receivedAmount,
        notes: notes ?? this.notes,
        importedAt: importedAt ?? this.importedAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      passBookNo:
          data.passBookNo.present ? data.passBookNo.value : this.passBookNo,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      amount: data.amount.present ? data.amount.value : this.amount,
      eqWt: data.eqWt.present ? data.eqWt.value : this.eqWt,
      receivedAmount: data.receivedAmount.present
          ? data.receivedAmount.value
          : this.receivedAmount,
      notes: data.notes.present ? data.notes.value : this.notes,
      importedAt:
          data.importedAt.present ? data.importedAt.value : this.importedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('passBookNo: $passBookNo, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('amount: $amount, ')
          ..write('eqWt: $eqWt, ')
          ..write('receivedAmount: $receivedAmount, ')
          ..write('notes: $notes, ')
          ..write('importedAt: $importedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, passBookNo, name, phone, amount, eqWt,
      receivedAmount, notes, importedAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.passBookNo == this.passBookNo &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.amount == this.amount &&
          other.eqWt == this.eqWt &&
          other.receivedAmount == this.receivedAmount &&
          other.notes == this.notes &&
          other.importedAt == this.importedAt &&
          other.updatedAt == this.updatedAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String> passBookNo;
  final Value<String> name;
  final Value<String> phone;
  final Value<double> amount;
  final Value<double> eqWt;
  final Value<double> receivedAmount;
  final Value<String> notes;
  final Value<DateTime> importedAt;
  final Value<DateTime> updatedAt;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.passBookNo = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.amount = const Value.absent(),
    this.eqWt = const Value.absent(),
    this.receivedAmount = const Value.absent(),
    this.notes = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String passBookNo,
    required String name,
    this.phone = const Value.absent(),
    this.amount = const Value.absent(),
    this.eqWt = const Value.absent(),
    this.receivedAmount = const Value.absent(),
    this.notes = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : passBookNo = Value(passBookNo),
        name = Value(name);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? passBookNo,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<double>? amount,
    Expression<double>? eqWt,
    Expression<double>? receivedAmount,
    Expression<String>? notes,
    Expression<DateTime>? importedAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (passBookNo != null) 'pass_book_no': passBookNo,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (amount != null) 'amount': amount,
      if (eqWt != null) 'eq_wt': eqWt,
      if (receivedAmount != null) 'received_amount': receivedAmount,
      if (notes != null) 'notes': notes,
      if (importedAt != null) 'imported_at': importedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CustomersCompanion copyWith(
      {Value<int>? id,
      Value<String>? passBookNo,
      Value<String>? name,
      Value<String>? phone,
      Value<double>? amount,
      Value<double>? eqWt,
      Value<double>? receivedAmount,
      Value<String>? notes,
      Value<DateTime>? importedAt,
      Value<DateTime>? updatedAt}) {
    return CustomersCompanion(
      id: id ?? this.id,
      passBookNo: passBookNo ?? this.passBookNo,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      amount: amount ?? this.amount,
      eqWt: eqWt ?? this.eqWt,
      receivedAmount: receivedAmount ?? this.receivedAmount,
      notes: notes ?? this.notes,
      importedAt: importedAt ?? this.importedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (passBookNo.present) {
      map['pass_book_no'] = Variable<String>(passBookNo.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (eqWt.present) {
      map['eq_wt'] = Variable<double>(eqWt.value);
    }
    if (receivedAmount.present) {
      map['received_amount'] = Variable<double>(receivedAmount.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('passBookNo: $passBookNo, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('amount: $amount, ')
          ..write('eqWt: $eqWt, ')
          ..write('receivedAmount: $receivedAmount, ')
          ..write('notes: $notes, ')
          ..write('importedAt: $importedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ReceiptsTable extends Receipts with TableInfo<$ReceiptsTable, Receipt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceiptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _passBookIdMeta =
      const VerificationMeta('passBookId');
  @override
  late final GeneratedColumn<String> passBookId = GeneratedColumn<String>(
      'pass_book_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entryDateMeta =
      const VerificationMeta('entryDate');
  @override
  late final GeneratedColumn<DateTime> entryDate = GeneratedColumn<DateTime>(
      'entry_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _goldRateMeta =
      const VerificationMeta('goldRate');
  @override
  late final GeneratedColumn<double> goldRate = GeneratedColumn<double>(
      'gold_rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _amountReceivedMeta =
      const VerificationMeta('amountReceived');
  @override
  late final GeneratedColumn<double> amountReceived = GeneratedColumn<double>(
      'amount_received', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _eqWtAddedMeta =
      const VerificationMeta('eqWtAdded');
  @override
  late final GeneratedColumn<double> eqWtAdded = GeneratedColumn<double>(
      'eq_wt_added', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _remarksMeta =
      const VerificationMeta('remarks');
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
      'remarks', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _isCancelledMeta =
      const VerificationMeta('isCancelled');
  @override
  late final GeneratedColumn<bool> isCancelled = GeneratedColumn<bool>(
      'is_cancelled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_cancelled" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        passBookId,
        name,
        entryDate,
        goldRate,
        amountReceived,
        eqWtAdded,
        paymentMethod,
        remarks,
        isCancelled
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receipts';
  @override
  VerificationContext validateIntegrity(Insertable<Receipt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pass_book_id')) {
      context.handle(
          _passBookIdMeta,
          passBookId.isAcceptableOrUnknown(
              data['pass_book_id']!, _passBookIdMeta));
    } else if (isInserting) {
      context.missing(_passBookIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('entry_date')) {
      context.handle(_entryDateMeta,
          entryDate.isAcceptableOrUnknown(data['entry_date']!, _entryDateMeta));
    }
    if (data.containsKey('gold_rate')) {
      context.handle(_goldRateMeta,
          goldRate.isAcceptableOrUnknown(data['gold_rate']!, _goldRateMeta));
    } else if (isInserting) {
      context.missing(_goldRateMeta);
    }
    if (data.containsKey('amount_received')) {
      context.handle(
          _amountReceivedMeta,
          amountReceived.isAcceptableOrUnknown(
              data['amount_received']!, _amountReceivedMeta));
    } else if (isInserting) {
      context.missing(_amountReceivedMeta);
    }
    if (data.containsKey('eq_wt_added')) {
      context.handle(
          _eqWtAddedMeta,
          eqWtAdded.isAcceptableOrUnknown(
              data['eq_wt_added']!, _eqWtAddedMeta));
    } else if (isInserting) {
      context.missing(_eqWtAddedMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('remarks')) {
      context.handle(_remarksMeta,
          remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta));
    }
    if (data.containsKey('is_cancelled')) {
      context.handle(
          _isCancelledMeta,
          isCancelled.isAcceptableOrUnknown(
              data['is_cancelled']!, _isCancelledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Receipt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Receipt(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      passBookId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pass_book_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      entryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}entry_date'])!,
      goldRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gold_rate'])!,
      amountReceived: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}amount_received'])!,
      eqWtAdded: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}eq_wt_added'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      remarks: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remarks'])!,
      isCancelled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_cancelled'])!,
    );
  }

  @override
  $ReceiptsTable createAlias(String alias) {
    return $ReceiptsTable(attachedDatabase, alias);
  }
}

class Receipt extends DataClass implements Insertable<Receipt> {
  final int id;
  final String passBookId;
  final String name;
  final DateTime entryDate;
  final double goldRate;
  final double amountReceived;
  final double eqWtAdded;
  final String paymentMethod;
  final String remarks;
  final bool isCancelled;
  const Receipt(
      {required this.id,
      required this.passBookId,
      required this.name,
      required this.entryDate,
      required this.goldRate,
      required this.amountReceived,
      required this.eqWtAdded,
      required this.paymentMethod,
      required this.remarks,
      required this.isCancelled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pass_book_id'] = Variable<String>(passBookId);
    map['name'] = Variable<String>(name);
    map['entry_date'] = Variable<DateTime>(entryDate);
    map['gold_rate'] = Variable<double>(goldRate);
    map['amount_received'] = Variable<double>(amountReceived);
    map['eq_wt_added'] = Variable<double>(eqWtAdded);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['remarks'] = Variable<String>(remarks);
    map['is_cancelled'] = Variable<bool>(isCancelled);
    return map;
  }

  ReceiptsCompanion toCompanion(bool nullToAbsent) {
    return ReceiptsCompanion(
      id: Value(id),
      passBookId: Value(passBookId),
      name: Value(name),
      entryDate: Value(entryDate),
      goldRate: Value(goldRate),
      amountReceived: Value(amountReceived),
      eqWtAdded: Value(eqWtAdded),
      paymentMethod: Value(paymentMethod),
      remarks: Value(remarks),
      isCancelled: Value(isCancelled),
    );
  }

  factory Receipt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Receipt(
      id: serializer.fromJson<int>(json['id']),
      passBookId: serializer.fromJson<String>(json['passBookId']),
      name: serializer.fromJson<String>(json['name']),
      entryDate: serializer.fromJson<DateTime>(json['entryDate']),
      goldRate: serializer.fromJson<double>(json['goldRate']),
      amountReceived: serializer.fromJson<double>(json['amountReceived']),
      eqWtAdded: serializer.fromJson<double>(json['eqWtAdded']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      remarks: serializer.fromJson<String>(json['remarks']),
      isCancelled: serializer.fromJson<bool>(json['isCancelled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'passBookId': serializer.toJson<String>(passBookId),
      'name': serializer.toJson<String>(name),
      'entryDate': serializer.toJson<DateTime>(entryDate),
      'goldRate': serializer.toJson<double>(goldRate),
      'amountReceived': serializer.toJson<double>(amountReceived),
      'eqWtAdded': serializer.toJson<double>(eqWtAdded),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'remarks': serializer.toJson<String>(remarks),
      'isCancelled': serializer.toJson<bool>(isCancelled),
    };
  }

  Receipt copyWith(
          {int? id,
          String? passBookId,
          String? name,
          DateTime? entryDate,
          double? goldRate,
          double? amountReceived,
          double? eqWtAdded,
          String? paymentMethod,
          String? remarks,
          bool? isCancelled}) =>
      Receipt(
        id: id ?? this.id,
        passBookId: passBookId ?? this.passBookId,
        name: name ?? this.name,
        entryDate: entryDate ?? this.entryDate,
        goldRate: goldRate ?? this.goldRate,
        amountReceived: amountReceived ?? this.amountReceived,
        eqWtAdded: eqWtAdded ?? this.eqWtAdded,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        remarks: remarks ?? this.remarks,
        isCancelled: isCancelled ?? this.isCancelled,
      );
  Receipt copyWithCompanion(ReceiptsCompanion data) {
    return Receipt(
      id: data.id.present ? data.id.value : this.id,
      passBookId:
          data.passBookId.present ? data.passBookId.value : this.passBookId,
      name: data.name.present ? data.name.value : this.name,
      entryDate: data.entryDate.present ? data.entryDate.value : this.entryDate,
      goldRate: data.goldRate.present ? data.goldRate.value : this.goldRate,
      amountReceived: data.amountReceived.present
          ? data.amountReceived.value
          : this.amountReceived,
      eqWtAdded: data.eqWtAdded.present ? data.eqWtAdded.value : this.eqWtAdded,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      isCancelled:
          data.isCancelled.present ? data.isCancelled.value : this.isCancelled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Receipt(')
          ..write('id: $id, ')
          ..write('passBookId: $passBookId, ')
          ..write('name: $name, ')
          ..write('entryDate: $entryDate, ')
          ..write('goldRate: $goldRate, ')
          ..write('amountReceived: $amountReceived, ')
          ..write('eqWtAdded: $eqWtAdded, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('remarks: $remarks, ')
          ..write('isCancelled: $isCancelled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, passBookId, name, entryDate, goldRate,
      amountReceived, eqWtAdded, paymentMethod, remarks, isCancelled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Receipt &&
          other.id == this.id &&
          other.passBookId == this.passBookId &&
          other.name == this.name &&
          other.entryDate == this.entryDate &&
          other.goldRate == this.goldRate &&
          other.amountReceived == this.amountReceived &&
          other.eqWtAdded == this.eqWtAdded &&
          other.paymentMethod == this.paymentMethod &&
          other.remarks == this.remarks &&
          other.isCancelled == this.isCancelled);
}

class ReceiptsCompanion extends UpdateCompanion<Receipt> {
  final Value<int> id;
  final Value<String> passBookId;
  final Value<String> name;
  final Value<DateTime> entryDate;
  final Value<double> goldRate;
  final Value<double> amountReceived;
  final Value<double> eqWtAdded;
  final Value<String> paymentMethod;
  final Value<String> remarks;
  final Value<bool> isCancelled;
  const ReceiptsCompanion({
    this.id = const Value.absent(),
    this.passBookId = const Value.absent(),
    this.name = const Value.absent(),
    this.entryDate = const Value.absent(),
    this.goldRate = const Value.absent(),
    this.amountReceived = const Value.absent(),
    this.eqWtAdded = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.remarks = const Value.absent(),
    this.isCancelled = const Value.absent(),
  });
  ReceiptsCompanion.insert({
    this.id = const Value.absent(),
    required String passBookId,
    required String name,
    this.entryDate = const Value.absent(),
    required double goldRate,
    required double amountReceived,
    required double eqWtAdded,
    required String paymentMethod,
    this.remarks = const Value.absent(),
    this.isCancelled = const Value.absent(),
  })  : passBookId = Value(passBookId),
        name = Value(name),
        goldRate = Value(goldRate),
        amountReceived = Value(amountReceived),
        eqWtAdded = Value(eqWtAdded),
        paymentMethod = Value(paymentMethod);
  static Insertable<Receipt> custom({
    Expression<int>? id,
    Expression<String>? passBookId,
    Expression<String>? name,
    Expression<DateTime>? entryDate,
    Expression<double>? goldRate,
    Expression<double>? amountReceived,
    Expression<double>? eqWtAdded,
    Expression<String>? paymentMethod,
    Expression<String>? remarks,
    Expression<bool>? isCancelled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (passBookId != null) 'pass_book_id': passBookId,
      if (name != null) 'name': name,
      if (entryDate != null) 'entry_date': entryDate,
      if (goldRate != null) 'gold_rate': goldRate,
      if (amountReceived != null) 'amount_received': amountReceived,
      if (eqWtAdded != null) 'eq_wt_added': eqWtAdded,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (remarks != null) 'remarks': remarks,
      if (isCancelled != null) 'is_cancelled': isCancelled,
    });
  }

  ReceiptsCompanion copyWith(
      {Value<int>? id,
      Value<String>? passBookId,
      Value<String>? name,
      Value<DateTime>? entryDate,
      Value<double>? goldRate,
      Value<double>? amountReceived,
      Value<double>? eqWtAdded,
      Value<String>? paymentMethod,
      Value<String>? remarks,
      Value<bool>? isCancelled}) {
    return ReceiptsCompanion(
      id: id ?? this.id,
      passBookId: passBookId ?? this.passBookId,
      name: name ?? this.name,
      entryDate: entryDate ?? this.entryDate,
      goldRate: goldRate ?? this.goldRate,
      amountReceived: amountReceived ?? this.amountReceived,
      eqWtAdded: eqWtAdded ?? this.eqWtAdded,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      remarks: remarks ?? this.remarks,
      isCancelled: isCancelled ?? this.isCancelled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (passBookId.present) {
      map['pass_book_id'] = Variable<String>(passBookId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (entryDate.present) {
      map['entry_date'] = Variable<DateTime>(entryDate.value);
    }
    if (goldRate.present) {
      map['gold_rate'] = Variable<double>(goldRate.value);
    }
    if (amountReceived.present) {
      map['amount_received'] = Variable<double>(amountReceived.value);
    }
    if (eqWtAdded.present) {
      map['eq_wt_added'] = Variable<double>(eqWtAdded.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (isCancelled.present) {
      map['is_cancelled'] = Variable<bool>(isCancelled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptsCompanion(')
          ..write('id: $id, ')
          ..write('passBookId: $passBookId, ')
          ..write('name: $name, ')
          ..write('entryDate: $entryDate, ')
          ..write('goldRate: $goldRate, ')
          ..write('amountReceived: $amountReceived, ')
          ..write('eqWtAdded: $eqWtAdded, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('remarks: $remarks, ')
          ..write('isCancelled: $isCancelled')
          ..write(')'))
        .toString();
  }
}

class $PendingMessagesTable extends PendingMessages
    with TableInfo<$PendingMessagesTable, PendingMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, phone, message, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_messages';
  @override
  VerificationContext validateIntegrity(Insertable<PendingMessage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingMessage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PendingMessagesTable createAlias(String alias) {
    return $PendingMessagesTable(attachedDatabase, alias);
  }
}

class PendingMessage extends DataClass implements Insertable<PendingMessage> {
  final int id;
  final String phone;
  final String message;
  final DateTime createdAt;
  const PendingMessage(
      {required this.id,
      required this.phone,
      required this.message,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['phone'] = Variable<String>(phone);
    map['message'] = Variable<String>(message);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingMessagesCompanion toCompanion(bool nullToAbsent) {
    return PendingMessagesCompanion(
      id: Value(id),
      phone: Value(phone),
      message: Value(message),
      createdAt: Value(createdAt),
    );
  }

  factory PendingMessage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingMessage(
      id: serializer.fromJson<int>(json['id']),
      phone: serializer.fromJson<String>(json['phone']),
      message: serializer.fromJson<String>(json['message']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'phone': serializer.toJson<String>(phone),
      'message': serializer.toJson<String>(message),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingMessage copyWith(
          {int? id, String? phone, String? message, DateTime? createdAt}) =>
      PendingMessage(
        id: id ?? this.id,
        phone: phone ?? this.phone,
        message: message ?? this.message,
        createdAt: createdAt ?? this.createdAt,
      );
  PendingMessage copyWithCompanion(PendingMessagesCompanion data) {
    return PendingMessage(
      id: data.id.present ? data.id.value : this.id,
      phone: data.phone.present ? data.phone.value : this.phone,
      message: data.message.present ? data.message.value : this.message,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingMessage(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, phone, message, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingMessage &&
          other.id == this.id &&
          other.phone == this.phone &&
          other.message == this.message &&
          other.createdAt == this.createdAt);
}

class PendingMessagesCompanion extends UpdateCompanion<PendingMessage> {
  final Value<int> id;
  final Value<String> phone;
  final Value<String> message;
  final Value<DateTime> createdAt;
  const PendingMessagesCompanion({
    this.id = const Value.absent(),
    this.phone = const Value.absent(),
    this.message = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PendingMessagesCompanion.insert({
    this.id = const Value.absent(),
    required String phone,
    required String message,
    this.createdAt = const Value.absent(),
  })  : phone = Value(phone),
        message = Value(message);
  static Insertable<PendingMessage> custom({
    Expression<int>? id,
    Expression<String>? phone,
    Expression<String>? message,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phone != null) 'phone': phone,
      if (message != null) 'message': message,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PendingMessagesCompanion copyWith(
      {Value<int>? id,
      Value<String>? phone,
      Value<String>? message,
      Value<DateTime>? createdAt}) {
    return PendingMessagesCompanion(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingMessagesCompanion(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $ReceiptsTable receipts = $ReceiptsTable(this);
  late final $PendingMessagesTable pendingMessages =
      $PendingMessagesTable(this);
  late final CustomerDao customerDao = CustomerDao(this as AppDatabase);
  late final ReceiptDao receiptDao = ReceiptDao(this as AppDatabase);
  late final PendingMessageDao pendingMessageDao =
      PendingMessageDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [customers, receipts, pendingMessages];
}

typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  required String passBookNo,
  required String name,
  Value<String> phone,
  Value<double> amount,
  Value<double> eqWt,
  Value<double> receivedAmount,
  Value<String> notes,
  Value<DateTime> importedAt,
  Value<DateTime> updatedAt,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  Value<String> passBookNo,
  Value<String> name,
  Value<String> phone,
  Value<double> amount,
  Value<double> eqWt,
  Value<double> receivedAmount,
  Value<String> notes,
  Value<DateTime> importedAt,
  Value<DateTime> updatedAt,
});

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passBookNo => $composableBuilder(
      column: $table.passBookNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get eqWt => $composableBuilder(
      column: $table.eqWt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get receivedAmount => $composableBuilder(
      column: $table.receivedAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get importedAt => $composableBuilder(
      column: $table.importedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passBookNo => $composableBuilder(
      column: $table.passBookNo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get eqWt => $composableBuilder(
      column: $table.eqWt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get receivedAmount => $composableBuilder(
      column: $table.receivedAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get importedAt => $composableBuilder(
      column: $table.importedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get passBookNo => $composableBuilder(
      column: $table.passBookNo, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get eqWt =>
      $composableBuilder(column: $table.eqWt, builder: (column) => column);

  GeneratedColumn<double> get receivedAmount => $composableBuilder(
      column: $table.receivedAmount, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get importedAt => $composableBuilder(
      column: $table.importedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CustomersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
    Customer,
    PrefetchHooks Function()> {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> passBookNo = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<double> eqWt = const Value.absent(),
            Value<double> receivedAmount = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<DateTime> importedAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CustomersCompanion(
            id: id,
            passBookNo: passBookNo,
            name: name,
            phone: phone,
            amount: amount,
            eqWt: eqWt,
            receivedAmount: receivedAmount,
            notes: notes,
            importedAt: importedAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String passBookNo,
            required String name,
            Value<String> phone = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<double> eqWt = const Value.absent(),
            Value<double> receivedAmount = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<DateTime> importedAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CustomersCompanion.insert(
            id: id,
            passBookNo: passBookNo,
            name: name,
            phone: phone,
            amount: amount,
            eqWt: eqWt,
            receivedAmount: receivedAmount,
            notes: notes,
            importedAt: importedAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CustomersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
    Customer,
    PrefetchHooks Function()>;
typedef $$ReceiptsTableCreateCompanionBuilder = ReceiptsCompanion Function({
  Value<int> id,
  required String passBookId,
  required String name,
  Value<DateTime> entryDate,
  required double goldRate,
  required double amountReceived,
  required double eqWtAdded,
  required String paymentMethod,
  Value<String> remarks,
  Value<bool> isCancelled,
});
typedef $$ReceiptsTableUpdateCompanionBuilder = ReceiptsCompanion Function({
  Value<int> id,
  Value<String> passBookId,
  Value<String> name,
  Value<DateTime> entryDate,
  Value<double> goldRate,
  Value<double> amountReceived,
  Value<double> eqWtAdded,
  Value<String> paymentMethod,
  Value<String> remarks,
  Value<bool> isCancelled,
});

class $$ReceiptsTableFilterComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passBookId => $composableBuilder(
      column: $table.passBookId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get entryDate => $composableBuilder(
      column: $table.entryDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get goldRate => $composableBuilder(
      column: $table.goldRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amountReceived => $composableBuilder(
      column: $table.amountReceived,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get eqWtAdded => $composableBuilder(
      column: $table.eqWtAdded, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remarks => $composableBuilder(
      column: $table.remarks, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCancelled => $composableBuilder(
      column: $table.isCancelled, builder: (column) => ColumnFilters(column));
}

class $$ReceiptsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passBookId => $composableBuilder(
      column: $table.passBookId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get entryDate => $composableBuilder(
      column: $table.entryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get goldRate => $composableBuilder(
      column: $table.goldRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amountReceived => $composableBuilder(
      column: $table.amountReceived,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get eqWtAdded => $composableBuilder(
      column: $table.eqWtAdded, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remarks => $composableBuilder(
      column: $table.remarks, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCancelled => $composableBuilder(
      column: $table.isCancelled, builder: (column) => ColumnOrderings(column));
}

class $$ReceiptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get passBookId => $composableBuilder(
      column: $table.passBookId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get entryDate =>
      $composableBuilder(column: $table.entryDate, builder: (column) => column);

  GeneratedColumn<double> get goldRate =>
      $composableBuilder(column: $table.goldRate, builder: (column) => column);

  GeneratedColumn<double> get amountReceived => $composableBuilder(
      column: $table.amountReceived, builder: (column) => column);

  GeneratedColumn<double> get eqWtAdded =>
      $composableBuilder(column: $table.eqWtAdded, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<bool> get isCancelled => $composableBuilder(
      column: $table.isCancelled, builder: (column) => column);
}

class $$ReceiptsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReceiptsTable,
    Receipt,
    $$ReceiptsTableFilterComposer,
    $$ReceiptsTableOrderingComposer,
    $$ReceiptsTableAnnotationComposer,
    $$ReceiptsTableCreateCompanionBuilder,
    $$ReceiptsTableUpdateCompanionBuilder,
    (Receipt, BaseReferences<_$AppDatabase, $ReceiptsTable, Receipt>),
    Receipt,
    PrefetchHooks Function()> {
  $$ReceiptsTableTableManager(_$AppDatabase db, $ReceiptsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReceiptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReceiptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReceiptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> passBookId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> entryDate = const Value.absent(),
            Value<double> goldRate = const Value.absent(),
            Value<double> amountReceived = const Value.absent(),
            Value<double> eqWtAdded = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String> remarks = const Value.absent(),
            Value<bool> isCancelled = const Value.absent(),
          }) =>
              ReceiptsCompanion(
            id: id,
            passBookId: passBookId,
            name: name,
            entryDate: entryDate,
            goldRate: goldRate,
            amountReceived: amountReceived,
            eqWtAdded: eqWtAdded,
            paymentMethod: paymentMethod,
            remarks: remarks,
            isCancelled: isCancelled,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String passBookId,
            required String name,
            Value<DateTime> entryDate = const Value.absent(),
            required double goldRate,
            required double amountReceived,
            required double eqWtAdded,
            required String paymentMethod,
            Value<String> remarks = const Value.absent(),
            Value<bool> isCancelled = const Value.absent(),
          }) =>
              ReceiptsCompanion.insert(
            id: id,
            passBookId: passBookId,
            name: name,
            entryDate: entryDate,
            goldRate: goldRate,
            amountReceived: amountReceived,
            eqWtAdded: eqWtAdded,
            paymentMethod: paymentMethod,
            remarks: remarks,
            isCancelled: isCancelled,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReceiptsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReceiptsTable,
    Receipt,
    $$ReceiptsTableFilterComposer,
    $$ReceiptsTableOrderingComposer,
    $$ReceiptsTableAnnotationComposer,
    $$ReceiptsTableCreateCompanionBuilder,
    $$ReceiptsTableUpdateCompanionBuilder,
    (Receipt, BaseReferences<_$AppDatabase, $ReceiptsTable, Receipt>),
    Receipt,
    PrefetchHooks Function()>;
typedef $$PendingMessagesTableCreateCompanionBuilder = PendingMessagesCompanion
    Function({
  Value<int> id,
  required String phone,
  required String message,
  Value<DateTime> createdAt,
});
typedef $$PendingMessagesTableUpdateCompanionBuilder = PendingMessagesCompanion
    Function({
  Value<int> id,
  Value<String> phone,
  Value<String> message,
  Value<DateTime> createdAt,
});

class $$PendingMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $PendingMessagesTable> {
  $$PendingMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$PendingMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingMessagesTable> {
  $$PendingMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$PendingMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingMessagesTable> {
  $$PendingMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PendingMessagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PendingMessagesTable,
    PendingMessage,
    $$PendingMessagesTableFilterComposer,
    $$PendingMessagesTableOrderingComposer,
    $$PendingMessagesTableAnnotationComposer,
    $$PendingMessagesTableCreateCompanionBuilder,
    $$PendingMessagesTableUpdateCompanionBuilder,
    (
      PendingMessage,
      BaseReferences<_$AppDatabase, $PendingMessagesTable, PendingMessage>
    ),
    PendingMessage,
    PrefetchHooks Function()> {
  $$PendingMessagesTableTableManager(
      _$AppDatabase db, $PendingMessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> message = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PendingMessagesCompanion(
            id: id,
            phone: phone,
            message: message,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String phone,
            required String message,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PendingMessagesCompanion.insert(
            id: id,
            phone: phone,
            message: message,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PendingMessagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PendingMessagesTable,
    PendingMessage,
    $$PendingMessagesTableFilterComposer,
    $$PendingMessagesTableOrderingComposer,
    $$PendingMessagesTableAnnotationComposer,
    $$PendingMessagesTableCreateCompanionBuilder,
    $$PendingMessagesTableUpdateCompanionBuilder,
    (
      PendingMessage,
      BaseReferences<_$AppDatabase, $PendingMessagesTable, PendingMessage>
    ),
    PendingMessage,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$ReceiptsTableTableManager get receipts =>
      $$ReceiptsTableTableManager(_db, _db.receipts);
  $$PendingMessagesTableTableManager get pendingMessages =>
      $$PendingMessagesTableTableManager(_db, _db.pendingMessages);
}
