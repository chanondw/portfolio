import '../models/currencies.dart';
import '../helpers/dio_helper.dart';

class CurrencyRepository {
  Future<List<CurrencyModel>> getList() async {
    var currencyList = <CurrencyModel>[];

/*
    final response =
        await DioHelper().getDio().get<Map<String, dynamic>>("/symbols");

    if (response.data != null && response.data!['symbols'] != null) {
      for (MapEntry<String, dynamic> v in response.data!['symbols'].entries) {
        currencyList.add(CurrencyModel(v.key, v.key, v.value));
      }
    }
    */

    currencyList = [
      CurrencyModel("AED", "AED", "United Arab Emirates Dirham"),
      CurrencyModel("AFN", "AFN", "Afghan Afghani"),
      CurrencyModel("ALL", "ALL", "Albanian Lek"),
      CurrencyModel("AMD", "AMD", "Armenian Dram"),
      CurrencyModel("ANG", "ANG", "Netherlands Antillean Guilder"),
    ];
    return currencyList;
  }
}
