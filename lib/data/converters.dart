import 'dart:convert';

import 'package:drift/drift.dart';

/// A list of vocabulary keys, stored as JSON text.
class StringListConverter extends TypeConverter<List<String>, String>
    with JsonTypeConverter2<List<String>, String, List<dynamic>> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as List).cast<String>();

  @override
  String toSql(List<String> value) => jsonEncode(value);

  @override
  List<String> fromJson(List<dynamic> json) => json.cast<String>();

  @override
  List<dynamic> toJson(List<String> value) => value;
}

/// Optional clot detail (brief §28).
class ClotObservation {
  const ClotObservation({
    required this.presence,
    this.quantity,
    this.largestApproximateSizeMm,
    this.sizeCategory,
    this.appearance = const [],
  });

  final String presence; // possible | definite
  final String? quantity;
  final int? largestApproximateSizeMm;
  final String? sizeCategory;
  final List<String> appearance;

  Map<String, Object?> toJson() => {
        'presence': presence,
        'quantity': quantity,
        'largestApproximateSizeMm': largestApproximateSizeMm,
        'sizeCategory': sizeCategory,
        'appearance': appearance,
      };

  factory ClotObservation.fromJson(Map<String, Object?> j) => ClotObservation(
        presence: j['presence'] as String,
        quantity: j['quantity'] as String?,
        largestApproximateSizeMm: j['largestApproximateSizeMm'] as int?,
        sizeCategory: j['sizeCategory'] as String?,
        appearance: ((j['appearance'] as List?) ?? const []).cast<String>(),
      );
}

class ClotConverter extends TypeConverter<ClotObservation, String>
    with JsonTypeConverter2<ClotObservation, String, Map<String, Object?>> {
  const ClotConverter();

  @override
  ClotObservation fromSql(String fromDb) =>
      ClotObservation.fromJson(jsonDecode(fromDb) as Map<String, Object?>);

  @override
  String toSql(ClotObservation value) => jsonEncode(value.toJson());

  @override
  ClotObservation fromJson(Map<String, Object?> json) =>
      ClotObservation.fromJson(json);

  @override
  Map<String, Object?> toJson(ClotObservation value) => value.toJson();
}
