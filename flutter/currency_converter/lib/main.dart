import 'package:currency_converter/models/exchange_rate_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/currency_repository.dart';
import '../models/currencies.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Currency Calculator',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final curList = CurrencyRepository().getList();
    appState.curList = curList;
    var convList = CurrencyRepository().getConversionList("USD");
    convList.then((v) => appState.rateList = v);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exchange Converter"),
      ),
      body: Column(
        children: [
          const BaseCurrencySelector(),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: appState.selectedCurrency.length,
              prototypeItem: const CurrencyCard("currency"),
              itemBuilder: (context, index) {
                return CurrencyCard(appState.selectedCurrency[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomAppBar(
        child: CurrencyDropDown(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  List<String> selectedCurrency = [];
  String baseCurrency = "USD";
  double baseAmount = 0;
  late Future<List<CurrencyModel>> curList;
  var rateList = ExchangeRateList("USD", {});

  void addCurrency(String currency) {
    selectedCurrency.add(currency);
    notifyListeners();
  }

  void removeCurrency(String currency) {
    selectedCurrency.remove(currency);
    notifyListeners();
  }

  void setBaseCurrency(String newBase) {
    baseCurrency = newBase;
    notifyListeners();
  }

  void setBaseAmount(String amount) {
    baseAmount = double.parse(amount);
    notifyListeners();
  }
}

class CurrencyCard extends StatelessWidget {
  const CurrencyCard(this.code, {super.key});

  final String code;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<MyAppState>();

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: ListTile(
        title: Text(
            "${appState.rateList.convert(appState.baseCurrency, code, appState.baseAmount)}"),
        subtitle: Text(code),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.delete_outline, semanticLabel: "Delete"),
              color: theme.colorScheme.error,
              onPressed: () {
                appState.removeCurrency(code);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyDropDown extends StatelessWidget {
  const CurrencyDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return FutureBuilder(
        future: appState.curList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: DropdownButton<String>(
                  isExpanded: true,
                  items: snapshot.data!.map((item) {
                    return DropdownMenuItem(
                      value: item.code,
                      child: Text(item.code),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue == null) {
                      return;
                    }
                    appState.addCurrency(newValue);
                  }));
        });
  }
}

class BaseCurrencySelector extends StatelessWidget {
  const BaseCurrencySelector({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: FutureBuilder(
                          future: appState.curList,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            return DropdownButton<String>(
                              isExpanded: true,
                              items: snapshot.data!.map((item) {
                                return DropdownMenuItem(
                                  value: item.code,
                                  child: Text(item.code),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue == null) {
                                  return;
                                }
                                appState.setBaseCurrency(newValue);
                              },
                              value: appState.baseCurrency,
                            );
                          }))),
              Expanded(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      decoration:
                          const InputDecoration(labelText: "Enter amount"),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[0-9]+.?[0-9]{0,2}'))
                      ],
                      onChanged: (v) => appState.setBaseAmount(v),
                    )),
              ),
            ])));
  }
}
