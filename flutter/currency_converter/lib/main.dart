import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/currency_repository.dart';

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
      bottomNavigationBar: const BottomAppBar(
        child: CurrencyDropDown(),
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
    final theme = Theme.of(context);
    final appState = context.watch<MyAppState>();

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: ListTile(
        title: Center(child: Text(code)),
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

    final curList = CurrencyRepository().getList();

    return FutureBuilder(
        future: curList,
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
                appState.addCurrency(newValue);
              });
        });
  }
}
