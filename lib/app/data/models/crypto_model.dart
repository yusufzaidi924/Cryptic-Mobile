class CryptoModel {
  final int? id;
  final String? name;
  final String? symbol;
  final String? slug;
  final int? cmcRank;
  final int? numMarketPairs;
  final int? circulatingSupply;
  final int? totalSupply;
  final int? maxSupply;
  final dynamic infiniteSupply;
  final String? lastUpdated;
  final String? dateAdded;
  final List<String>? tags;
  final dynamic platform;
  final dynamic selfReportedCirculatingSupply;
  final dynamic selfReportedMarketCap;
  final Quote? quote;

  CryptoModel({
    this.id,
    this.name,
    this.symbol,
    this.slug,
    this.cmcRank,
    this.numMarketPairs,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.infiniteSupply,
    this.lastUpdated,
    this.dateAdded,
    this.tags,
    this.platform,
    this.selfReportedCirculatingSupply,
    this.selfReportedMarketCap,
    this.quote,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      slug: json['slug'],
      cmcRank: json['cmc_rank'],
      numMarketPairs: json['num_market_pairs'],
      circulatingSupply: json['circulating_supply'],
      totalSupply: json['total_supply'],
      maxSupply: json['max_supply'],
      infiniteSupply: json['infinite_supply'],
      lastUpdated: json['last_updated'],
      dateAdded: json['date_added'],
      tags: List<String>.from(json['tags']),
      platform: json['platform'],
      selfReportedCirculatingSupply: json['self_reported_circulating_supply'],
      selfReportedMarketCap: json['self_reported_market_cap'],
      quote: Quote.fromJson(json['quote']),
    );
  }
}

class Quote {
  final USD? usd;

  Quote({this.usd});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      usd: USD.fromJson(json['USD']),
    );
  }
}

class USD {
  final double? price;
  final int? volume24h;
  final double? volumeChange24h;
  final double? percentChange1h;
  final double? percentChange24h;
  final double? percentChange7d;
  final double? marketCap;
  final int? marketCapDominance;
  final double? fullyDilutedMarketCap;
  final String? lastUpdated;

  USD({
    this.price,
    this.volume24h,
    this.volumeChange24h,
    this.percentChange1h,
    this.percentChange24h,
    this.percentChange7d,
    this.marketCap,
    this.marketCapDominance,
    this.fullyDilutedMarketCap,
    this.lastUpdated,
  });

  factory USD.fromJson(Map<String, dynamic> json) {
    return USD(
      price: json['price'],
      volume24h: json['volume_24h'],
      volumeChange24h: json['volume_change_24h'],
      percentChange1h: json['percent_change_1h'],
      percentChange24h: json['percent_change_24h'],
      percentChange7d: json['percent_change_7d'],
      marketCap: json['market_cap'],
      marketCapDominance: json['market_cap_dominance'],
      fullyDilutedMarketCap: json['fully_diluted_market_cap'],
      lastUpdated: json['last_updated'],
    );
  }
}
