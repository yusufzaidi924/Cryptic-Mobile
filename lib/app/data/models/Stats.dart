import 'dart:convert';

class Stats {
  int listing_count = 0;
  double average_price = 0.0;
  int lowest_price_good_deals = 0;
  double lowest_price = 0.0;
  double highest_price = 0.0;
  int visible_listing_count = 0;
  int dq_budget_counts = 0;
  double median_price = 0.0;
  double lowest_sg_base_price = 0.0;
  int lowest_sg_base_price_good_deals = 0;

  Stats({
    required this.listing_count,
    required this.average_price,
    required this.lowest_price_good_deals,
    required this.lowest_price,
    required this.highest_price,
    required this.visible_listing_count,
    required this.dq_budget_counts,
    required this.median_price,
    required this.lowest_sg_base_price,
    required this.lowest_sg_base_price_good_deals,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'cardNumber': cardNumber,
  //     'cardNumberM': cardNumberM,
  //     'cardBrand': cardBrand,
  //   };
  // }

  // factory Stats.fromMap(Map<String, dynamic> map) {
  //   return Stats(
  //     cardNumber: map['cardNumber'],
  //     cardNumberM: map['cardNumberM'],
  //     cardBrand: map['cardBrand'],
  //   );
  // }

  // String toJson() => json.encode(toMap());

  Stats.fromJson(Map<String, dynamic> json) {
    listing_count = int.parse(
        json['listing_count'] != null ? json['listing_count'].toString() : "0");
    average_price = double.parse(json['average_price'] != null
        ? json['average_price'].toString()
        : "0.0");
    lowest_price = double.parse(
        json['lowest_price'] != null ? json['lowest_price'].toString() : "0.0");
    lowest_price_good_deals = int.parse(json['lowest_price_good_deals'] != null
        ? json['lowest_price_good_deals'].toString()
        : "0");
    highest_price = double.parse(json['highest_price'] != null
        ? json['highest_price'].toString()
        : "0.0");
    visible_listing_count = int.parse(json['visible_listing_count'] != null
        ? json['visible_listing_count'].toString()
        : "0");
    dq_budget_counts = int.parse(json['dq_budget_counts'] != null
        ? json['dq_budget_counts'].toString()
        : "0");
    median_price = double.parse(
        json['median_price'] != null ? json['median_price'].toString() : "0.0");
    lowest_sg_base_price = double.parse(json['lowest_sg_base_price'] != null
        ? json['lowest_sg_base_price'].toString()
        : "0.0");
    lowest_sg_base_price_good_deals = int.parse(
        json['lowest_sg_base_price_good_deals'] != null
            ? json['lowest_sg_base_price_good_deals'].toString()
            : "0");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listing_count'] = this.listing_count;
    data['average_price'] = this.average_price;
    data['lowest_price_good_deals'] = this.lowest_price_good_deals;
    data['lowest_price'] = this.lowest_price;
    data['highest_price'] = this.highest_price;
    data['visible_listing_count'] = this.visible_listing_count;
    data['dq_budget_counts'] = this.dq_budget_counts;
    data['median_price'] = this.median_price;
    data['lowest_sg_base_price'] = this.lowest_sg_base_price;
    data['lowest_sg_base_price_good_deals'] =
        this.lowest_sg_base_price_good_deals;
    return data;
  }

  // @override
  // String toString() =>
  //     'Stats(cardNumber: $cardNumber, cardNumberM: $cardNumberM, cardBrand: $cardBrand)';

  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;

  //   return other is Stats &&
  //       other.cardNumber == cardNumber &&
  //       other.cardNumberM == cardNumberM &&
  //       other.cardBrand == cardBrand;
  // }

  // @override
  // int get hashCode =>
  //     cardNumber.hashCode ^ cardNumberM.hashCode ^ cardBrand.hashCode;
}
