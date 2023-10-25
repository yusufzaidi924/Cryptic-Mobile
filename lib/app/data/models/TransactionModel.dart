class TransactionModel {
  int id;
  String note;
  String symbol;
  String? tx;
  int? amount;
  DateTime? createdAt;
  DateTime? updatedAt;
  int from_id;
  int to_id;

  TransactionModel({
    required this.id,
    required this.note,
    required this.symbol,
    this.tx,
    required this.amount,
    this.createdAt,
    this.updatedAt,
    required this.from_id,
    required this.to_id,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int,
      note: json['note'] as String,
      symbol: json['symbol'] as String,
      tx: json['last_name'] ?? 'User' as String?,
      amount: json['amount'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      from_id: json['from_id'] as int,
      to_id: json['to_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['note'] = this.note;
    data['symbol'] = this.symbol;
    data['tx'] = this.tx;
    data['amount'] = this.amount;
    // data['created_at'] = this.createdAt?.toIso8601String();
    // data['updated_at'] = this.updatedAt?.toIso8601String();
    data['from_id'] = this.from_id;
    data['to_id'] = this.to_id;
    return data;
  }
}
