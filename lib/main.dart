import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const BaseConversionApp());

class BaseConversionApp extends StatelessWidget {
  const BaseConversionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Base Converter Pro 🚀',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.cyan,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        cardTheme: CardTheme(
          color: const Color(0xFF1A1A1A),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1A1A1A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.cyan, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.cyan, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.cyanAccent),
        ),
      ),
      home: const BaseConversionHome(),
    );
  }
}

class BaseConversionHome extends StatefulWidget {
  const BaseConversionHome({super.key});

  @override
  BaseConversionHomeState createState() => BaseConversionHomeState();
}

class BaseConversionHomeState extends State<BaseConversionHome> {
  final TextEditingController inputController = TextEditingController();
  int fromBase = 2;
  int toBase = 10;
  String result = "";
  int maxDigit = 0;
  static const String baseChars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  // LinkedIn URL launcher
  Future<void> _launchLinkedIn() async {
    final Uri url = Uri.parse('https://www.linkedin.com/in/mantakamahir/');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  static const Map<int, int> maxDigitMap = {
    2: 55,
    3: 39,
    4: 31,
    5: 27,
    6: 24,
    7: 22,
    8: 21,
    9: 19,
    10: 18,
    11: 18,
    12: 17,
    13: 17,
    14: 16,
    15: 16,
    16: 15,
    17: 15,
    18: 15,
    19: 14,
    20: 14,
    21: 14,
    22: 14,
    23: 13,
    24: 13,
    25: 13,
    26: 13,
    27: 13,
    28: 13,
    29: 12,
    30: 12,
    31: 12,
    32: 12,
    33: 12,
    34: 12,
    35: 12,
    36: 12,
  };

  @override
  void initState() {
    super.initState();
    _updateMaxDigit();
  }

  void _updateMaxDigit() {
    setState(() {
      maxDigit = maxDigitMap[fromBase] ?? 12;
    });
    inputController.clear();
  }

  void convert() {
    String input = inputController.text.toUpperCase();

    if (input.isEmpty || !_isValidInput(input, fromBase)) {
      setState(() {
        result = "Invalid input for base $fromBase.";
      });
      return;
    }

    try {
      List<String> parts = input.split('.');
      int integerPart = _convertToDecimal(parts[0], fromBase);
      String fractionalPart = parts.length > 1 ? parts[1] : "";
      String convertedIntegerPart = _convertFromDecimal(integerPart, toBase);
      String convertedFractionalPart = fractionalPart.isNotEmpty
          ? _convertFractionalPart(fractionalPart, fromBase, toBase)
          : "";

      setState(() {
        result = convertedFractionalPart.isNotEmpty
            ? "$convertedIntegerPart.$convertedFractionalPart"
            : convertedIntegerPart;
      });
    } catch (e) {
      setState(() {
        result = "Error in conversion.";
      });
    }
  }

  bool _isValidInput(String input, int base) {
    int dotCount = 0;

    for (var char in input.split('')) {
      if (char == '.') {
        dotCount++;
        if (dotCount > 1) return false;
        continue;
      }
      int value = baseChars.indexOf(char);
      if (value == -1 || value >= base) {
        return false;
      }
    }
    return true;
  }

  int _convertToDecimal(String input, int base) {
    int sum = 0;
    for (int i = 0; i < input.length; i++) {
      int value = baseChars.indexOf(input[i]);
      if (value >= base || value == -1) {
        throw Exception("Invalid digit for base $base.");
      }
      sum = sum * base + value;
    }
    return sum;
  }

  String _convertFromDecimal(int number, int base) {
    if (number == 0) return "0";
    String result = "";
    while (number > 0) {
      result = baseChars[number % base] + result;
      number ~/= base;
    }
    return result;
  }

  String _convertFractionalPart(String fraction, int fromBase, int toBase) {
    double decimalFraction = _convertFractionToDecimal(fraction, fromBase);
    return _convertFromDecimalFraction(decimalFraction, toBase);
  }

  double _convertFractionToDecimal(String fraction, int base) {
    double sum = 0;
    double power = 1.0 / base;
    for (int i = 0; i < fraction.length; i++) {
      int value = baseChars.indexOf(fraction[i]);
      if (value >= base || value == -1) {
        throw Exception("Invalid digit for base $base.");
      }
      sum += value * power;
      power /= base;
    }
    return sum;
  }

  String _convertFromDecimalFraction(double fraction, int base) {
    String result = "";
    for (int i = 0; i < 20; i++) {
      fraction *= base;
      int integerPart = fraction.floor();

      result += baseChars[integerPart];
      fraction -= integerPart;

      if (fraction == 0) break;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0A0A),
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
            Color(0xFF0F3460),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.cyan, Colors.blue, Colors.purple],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Text(
              '🎮 BASE CONVERTER PRO 🚀',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Animated input section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyan.withOpacity(0.1),
                        Colors.blue.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.cyan.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyan.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '💻 ENTER YOUR NUMBER 💻',
                        style: TextStyle(
                          color: Colors.cyanAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: inputController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          labelText: '🎯 Max $maxDigit digits',
                          labelStyle: const TextStyle(color: Colors.cyanAccent),
                          counterStyle: const TextStyle(color: Colors.cyan),
                          prefixIcon:
                              const Icon(Icons.keyboard, color: Colors.cyan),
                        ),
                        maxLength: maxDigit,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(maxDigit),
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^[0-9A-Z.]+$'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // Base selection section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.withOpacity(0.1),
                        Colors.pink.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.purple.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '⚡ SELECT NUMBER BASES ⚡',
                        style: TextStyle(
                          color: Colors.purpleAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.cyan.withOpacity(0.2),
                                    Colors.blue.withOpacity(0.2)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.cyan),
                              ),
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: '🔥 From',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: InputBorder.none,
                                  labelStyle:
                                      TextStyle(color: Colors.cyanAccent),
                                ),
                                dropdownColor: const Color(0xFF1A1A1A),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                                value: fromBase,
                                onChanged: (value) {
                                  setState(() => fromBase = value!);
                                  _updateMaxDigit();
                                },
                                items: List.generate(35, (index) => index + 2)
                                    .map(
                                      (base) => DropdownMenuItem(
                                        value: base,
                                        child: Text('$base'),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.cyan, Colors.purple],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(Icons.sync_alt,
                                color: Colors.white, size: 20),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.purple.withOpacity(0.2),
                                    Colors.pink.withOpacity(0.2)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.purple),
                              ),
                              child: DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: '🎯 To',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: InputBorder.none,
                                  labelStyle:
                                      TextStyle(color: Colors.purpleAccent),
                                ),
                                dropdownColor: const Color(0xFF1A1A1A),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                                value: toBase,
                                onChanged: (value) =>
                                    setState(() => toBase = value!),
                                items: List.generate(35, (index) => index + 2)
                                    .map(
                                      (base) => DropdownMenuItem(
                                        value: base,
                                        child: Text('$base'),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Convert button
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.cyan,
                        Colors.blue,
                        Colors.purple,
                        Colors.pink
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyan.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: convert,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    icon: const Icon(Icons.rocket_launch,
                        color: Colors.white, size: 28),
                    label: const Text(
                      'CONVERT NOW! 🚀',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Result section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.withOpacity(0.1),
                        Colors.teal.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.green.withOpacity(0.3), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '✨ RESULT ✨',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        result.isEmpty ? '🎮 Ready to convert!' : result,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color:
                              result.isEmpty ? Colors.grey : Colors.greenAccent,
                          letterSpacing: 1.1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Credits section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.withOpacity(0.1),
                        Colors.red.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '',
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        '🎯 Mantaka Mahir',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // LinkedIn Button
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0077B5), Color(0xFF005885)],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0077B5).withOpacity(0.4),
                              blurRadius: 15,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: _launchLinkedIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          icon: const Icon(Icons.business,
                              color: Colors.white, size: 24),
                          label: const Text(
                            ' LinkedIn Profile',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
