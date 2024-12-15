import 'package:flutter/material.dart';

void main() {
  runApp(UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => UnitConverterHomePage(),
        '/history': (context) => ConversionHistoryScreen(),
      },
    );
  }
}

class UnitConverterHomePage extends StatefulWidget {
  @override
  _UnitConverterHomePageState createState() => _UnitConverterHomePageState();
}

class _UnitConverterHomePageState extends State<UnitConverterHomePage> {
  String selectedConversion = 'Length';
  final TextEditingController inputController = TextEditingController();
  String result = '';

  final Map<String, Map<String, double>> conversionFactors = {
    'Length': {
      'Meters to Kilometers': 0.001,
      'Kilometers to Meters': 1000,
    },
    'Weight': {
      'Grams to Kilograms': 0.001,
      'Kilograms to Grams': 1000,
    },
  };

  String selectedConversionType = 'Meters to Kilometers';

  List<String> conversionHistory = [];

  void addToHistory(String conversion) {
    setState(() {
      conversionHistory.add(conversion);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Converter'),
        backgroundColor: Colors.teal[700],
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/history', arguments: conversionHistory);
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.teal[900],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Conversion Category:',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              DropdownButton<String>(
                dropdownColor: Colors.teal[800],
                value: selectedConversion,
                onChanged: (value) {
                  setState(() {
                    selectedConversion = value!;
                    selectedConversionType = conversionFactors[selectedConversion]!.keys.first;
                  });
                },
                items: conversionFactors.keys
                    .map((key) => DropdownMenuItem(
                          value: key,
                          child: Text(key, style: TextStyle(color: Colors.white)),
                        ))
                    .toList(),
              ),
              SizedBox(height: 16),
              Text(
                'Select Conversion Type:',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              DropdownButton<String>(
                dropdownColor: Colors.teal[800],
                value: selectedConversionType,
                onChanged: (value) {
                  setState(() {
                    selectedConversionType = value!;
                  });
                },
                items: conversionFactors[selectedConversion]!
                    .keys
                    .map((key) => DropdownMenuItem(
                          value: key,
                          child: Text(key, style: TextStyle(color: Colors.white)),
                        ))
                    .toList(),
              ),
              SizedBox(height: 16),
              TextField(
                controller: inputController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter value',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[600],
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: () {
                  final input = double.tryParse(inputController.text);
                  if (input != null) {
                    final factor = conversionFactors[selectedConversion]![selectedConversionType]!;
                    final conversionResult = (input * factor).toStringAsFixed(2);
                    setState(() {
                      result = conversionResult;
                      addToHistory('$input $selectedConversionType = $conversionResult');
                    });
                  } else {
                    setState(() {
                      result = 'Invalid input';
                    });
                  }
                },
                child: Text('Convert', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              SizedBox(height: 16),
              Text(
                'Result: $result',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConversionHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> history = ModalRoute.of(context)!.settings.arguments as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Conversion History'),
        backgroundColor: Colors.teal[700],
      ),
      body: Container(
        color: Colors.teal[900],
        child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: history.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.teal[700],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  history[index],
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
