class ExchangeRateList {
  String base;
  Map<String, double> exchangeRates;

  ExchangeRateList(this.base, this.exchangeRates);

  factory ExchangeRateList.fromJson(Map<String, dynamic> json) {
    Map<String, double> rateList = {};
    json['rates'].forEach((k, v) => rateList[k] = v + 0.0);

    return ExchangeRateList(
      json['base'],
      rateList,
    );
  }

  double convert(String from, String to, double amount) {
    if (from == to) {
      return amount;
    }
    if (exchangeRates[from] != null && base == to) {
      return amount / exchangeRates[from]!;
    }

    if (exchangeRates[to] != null && base == from) {
      return amount * exchangeRates[to]!;
    }

    if (exchangeRates[to] != null && exchangeRates[from] != null) {
      return (amount / exchangeRates[to]!) * exchangeRates[from]!;
    }
    return 0.0;
  }
}
