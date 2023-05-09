//
//     final paymentModel = paymentModelFromJson(jsonString);

import 'dart:convert';

PaymentModel paymentModelFromJson(String str) =>
    PaymentModel.fromJson(json.decode(str));

String paymentModelToJson(PaymentModel data) => json.encode(data.toJson());

class PaymentModel {
  PaymentModel({
    this.key,
    this.amount,
    this.name,
    this.description,
    this.retry,
    this.sendSmsHash,
    this.prefill,
    this.paymentModelExternal,
  });

  String? key;
  String? amount;
  String? name;
  String? description;
  Retry? retry;
  String? sendSmsHash;
  Prefill? prefill;
  External? paymentModelExternal;

  PaymentModel copyWith({
    String? key,
    String? amount,
    String? name,
    String? description,
    Retry? retry,
    String? sendSmsHash,
    Prefill? prefill,
    External? paymentModelExternal,
  }) =>
      PaymentModel(
        key: key ?? this.key,
        amount: amount ?? this.amount,
        name: name ?? this.name,
        description: description ?? this.description,
        retry: retry ?? this.retry,
        sendSmsHash: sendSmsHash ?? this.sendSmsHash,
        prefill: prefill ?? this.prefill,
        paymentModelExternal: paymentModelExternal ?? this.paymentModelExternal,
      );

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        key: json["key"],
        amount: json["amount"],
        name: json["name"],
        description: json["description"],
        retry: Retry.fromJson(json["retry"]),
        sendSmsHash: json["send_sms_hash"],
        prefill: Prefill.fromJson(json["prefill"]),
        paymentModelExternal: External.fromJson(json["external"]),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "amount": amount,
        "name": name,
        "description": description,
        "retry": retry?.toJson(),
        "send_sms_hash": sendSmsHash,
        "prefill": prefill?.toJson(),
        "external": paymentModelExternal!.toJson(),
      };
}

class External {
  External({
    required this.wallets,
  });

  List<String> wallets;

  External copyWith({
    List<String>? wallets,
  }) =>
      External(
        wallets: wallets ?? this.wallets,
      );

  factory External.fromJson(Map<String, dynamic> json) => External(
        wallets: List<String>.from(json["wallets"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "wallets": List<dynamic>.from(wallets.map((x) => x)),
      };
}

class Prefill {
  Prefill({
    this.contact,
    this.email,
  });

  String? contact;
  String? email;

  Prefill copyWith({
    String? contact,
    String? email,
  }) =>
      Prefill(
        contact: contact ?? this.contact,
        email: email ?? this.email,
      );

  factory Prefill.fromJson(Map<String, dynamic> json) => Prefill(
        contact: json["contact"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "contact": contact,
        "email": email,
      };
}

class Retry {
  Retry({
    required this.enabled,
    required this.maxCount,
  });

  String enabled;
  String maxCount;

  Retry copyWith({
    String? enabled,
    String? maxCount,
  }) =>
      Retry(
        enabled: enabled ?? this.enabled,
        maxCount: maxCount ?? this.maxCount,
      );

  factory Retry.fromJson(Map<String, dynamic> json) => Retry(
        enabled: json["enabled"],
        maxCount: json["max_count"],
      );

  Map<String, dynamic> toJson() => {
        "enabled": enabled,
        "max_count": maxCount,
      };
}
