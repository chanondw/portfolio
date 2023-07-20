import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exchange Converter"),
      ),
      body: Column(
        children: [
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
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () => {appState.addCurrency("test")},
          child: const Text("+"),
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  List<String> selectedCurrency = [];

  void addCurrency(String currency) {
    selectedCurrency.add(currency);
    notifyListeners();
  }

  void removeCurrency(String currency) {
    selectedCurrency.remove(currency);
    notifyListeners();
  }
}

class CurrencyCard extends StatelessWidget {
  const CurrencyCard(this.code, {super.key});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: SizedBox(
        height: 100,
        child: Center(child: Text("Card for $code")),
      ),
    );
  }
}
