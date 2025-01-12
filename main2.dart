import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora IMC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // tirar a targe do debug
      home: MinhaCalculadoraDeImc(),
    );
  }
}

class MinhaCalculadoraDeImc extends StatefulWidget {
  @override
  _MinhaCalculadoraDeImcState createState() => _MinhaCalculadoraDeImcState();
}

class _MinhaCalculadoraDeImcState extends State<MinhaCalculadoraDeImc> {
  late TextEditingController pesoController;
  late TextEditingController alturaController;
  late double valorPeso = 40;
  double valorAltura = 1.5;

  double? imc = 0.0; // var para armazenar o cálculo do IMC
  String? classificacao = ''; // se é obeso ou outros
  Color? corResultado = Colors.white; // guardar a inf. da cor*/

  @override
  void initState() {
    // é um método do cilco de vida do initState, é ideal para inicilizar as váriaveis
    pesoController = TextEditingController(text: valorPeso.toString());
    alturaController = TextEditingController(text: valorAltura.toString());
    super.initState();
  }

  @override
  void dispose() {
    // é executado toda vez que o width é destruido
    pesoController.dispose();
    alturaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        width: double.infinity, // pegar o tamanho da tela toda
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // centralizar na horizontal
          crossAxisAlignment:
              CrossAxisAlignment.center, // centralizar na vertical
          children: [
            imc == null
                ? Text(
                    'Adicione valores de peso e altura \npara calcular seu IMC',
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Container(
                    // operador ternário :
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      // decoration diz como o container vai ser
                      borderRadius: BorderRadius.circular(150), // uma bola
                      border: Border.all(
                        width: 10,
                        color: corResultado ?? Colors.transparent,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${imc?.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 42,
                            color: corResultado,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          classificacao!,
                          style: TextStyle(),
                        )
                      ],
                    ),
                  ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Seu peso'),
                    SizedBox(height: 6),
                    Container(
                      width: 75,
                      child: TextField(
                        enabled: false,
                        controller: pesoController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            suffixText: 'kg'),
                        keyboardType:
                            TextInputType.number, // ativar o key númerico
                      ),
                    ),
                    Slider(
                      activeColor: Colors.purple,
                      value: valorPeso,
                      onChanged: (peso) {
                        setState(() {
                          valorPeso = peso;
                          pesoController.text = valorPeso.toString();
                        });
                      },
                      min: 40,
                      max: 200,
                    )
                  ],
                ),
                SizedBox(width: 22),
                Column(
                  children: [
                    Text('Sua altura'),
                    SizedBox(height: 6),
                    Container(
                      width: 75,
                      child: TextField(
                        controller: alturaController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            suffixText: 'm'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  child: Column(),
                ),
              ],
            ),
            SizedBox(height: 22),
            Container(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  try {
                    double peso = double.parse(pesoController.text);
                    double altura = double.parse(alturaController.text);
                    setState(() {
                      imc = peso / (altura * altura);
                      classificacao = getClassificacaoIMC(imc!)!;
                      corResultado = getCorIMC(imc!);
                    });
                  } on Exception {
                    setState(() {
                      imc = null;
                      pesoController.text = '';
                      alturaController.text = '';
                      classificacao = null;
                      corResultado = null;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                child: Text(
                  'Calcular',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? getClassificacaoIMC(double imc) {
    if (imc <= 18.5) {
      return 'Abaixo do Peso';
    } else if (imc > 18.5 && imc <= 24.9) {
      return 'Peso Normal';
    } else if (imc > 25.0 && imc <= 29.9) {
      return 'Sobrepeso';
    } else if (imc > 30.0 && imc <= 34.9) {
      return 'Obesidade Grau I';
    } else if (imc > 35.0 && imc <= 39.9) {
      return 'Obesidade Grau II';
    } else if (imc > 40.0) {
      return 'Obesidade Grau III';
    }
    return null;
  }

  Color getCorIMC(double imc) {
    if (imc <= 18.5) {
      return Colors.blue;
    } else if (imc > 18.5 && imc <= 24.9) {
      return Colors.green;
    } else if (imc > 25.0 && imc <= 29.9) {
      return Colors.brown;
    } else if (imc > 30.0 && imc <= 34.9) {
      return Color(0xFFEE9809);
    } else if (imc > 35.0 && imc <= 39.9) {
      return Colors.pink;
    } else if (imc > 40.0) {
      return Colors.red;
    }
    return Colors.black;
  }
}
