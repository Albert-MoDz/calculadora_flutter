import 'package:flutter/material.dart';
import 'dart:math'; // Importa para realizar operaciones matemáticas avanzadas si es necesario

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Avanzada',
      theme: ThemeData.light(),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = "0";
  String previousInput = "";
  bool isCalculated = false;

  // Método para evaluar la expresión matemática usando un enfoque manual
  double? evaluateExpression(String input) {
    try {
      // Evalúa la expresión simple utilizando la función `compute`
      // Esta función solo manejará operaciones básicas
      Parser parser = Parser(input);
      return parser.evaluate();
    } catch (e) {
      return null;
    }
  }

  // Formatear el resultado para mostrarlo adecuadamente
  String formatDisplay(double value) {
    return value.toStringAsFixed(value == value.toInt() ? 0 : 3);
  }

  // Manejo de los botones presionados
  void onButtonTap(String buttonValue) {
    setState(() {
      if (buttonValue == "C") {
        display = "0";
        previousInput = "";
        isCalculated = false;
      } else if (buttonValue == "←") {
        if (display.length > 1) {
          display = display.substring(0, display.length - 1);
        } else {
          display = "0";
        }
      } else if (buttonValue == "=") {
        if (!isCalculated) {
          previousInput = display;
          double? result = evaluateExpression(display);
          display = result != null ? formatDisplay(result) : "Error";
          isCalculated = true;
        }
      } else if (buttonValue == ".") {
        if (!isCalculated && !display.endsWith(".")) {
          display += buttonValue;
        }
      } else {
        if (isCalculated) {
          display = buttonValue;
          isCalculated = false;
        } else if (display == "0" && buttonValue != ".") {
          display = buttonValue;
        } else {
          display += buttonValue;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculadora Avanzada',
          selectionColor: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 9, 57, 141),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              previousInput,
              style: const TextStyle(
                  fontSize: 18, color: Color.fromARGB(255, 151, 0, 0)),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              display,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildButtonRow(["C", "←", "/", "*"]),
                buildButtonRow(["7", "8", "9", "-"]),
                buildButtonRow(["4", "5", "6", "+"]),
                buildButtonRow(["1", "2", "3", "="]),
                buildButtonRow(["0", "."]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método para construir filas de botones
  Row buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((buttonText) => createButton(buttonText)).toList(),
    );
  }

  // Método para crear un botón
  Widget createButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => onButtonTap(buttonText),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(70, 70),
            backgroundColor:
                Colors.blueGrey[800], // Cambiado de primary a backgroundColor
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// Clase para parsear y evaluar la expresión matemáticamente.
class Parser {
  final String input;

  Parser(this.input);

  // Evaluar la expresión
  double evaluate() {
    try {
      List<String> tokens = tokenize(input);
      return compute(tokens);
    } catch (e) {
      throw Exception('Expresión inválida');
    }
  }

  // Tokenizar la cadena de entrada
  List<String> tokenize(String input) {
    return input
        .split(RegExp(r'(?<=[-+*/])|(?=[-+*/])')); // Tokenizar por operadores
  }

  // Método para calcular el resultado de la expresión
  double compute(List<String> tokens) {
    double result = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      String operator = tokens[i];
      double operand = double.parse(tokens[i + 1]);

      if (operator == '+') {
        result += operand;
      } else if (operator == '-') {
        result -= operand;
      } else if (operator == '*') {
        result *= operand;
      } else if (operator == '/') {
        result /= operand;
      }
    }
    return result;
  }
}
