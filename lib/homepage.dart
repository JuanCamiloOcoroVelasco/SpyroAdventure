import 'dart:async';
import 'barreras.dart';
import 'spyro_bird.dart';
import 'texto_superior.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //VARIABLES DE SPYRO
  static double spyroY = 0;
  double posicionInicial = spyroY;
  double altura = 0;
  double tiempo = 0;
  double gravedad = -4.9; //FUERZA DE LA GRAVEDAD
  double velocidad = 2.5; //FUERZA DEL SALTO
  double anchoSpyro = 0.3; //ANCHO DE SPYRO
  double altoSpyro = 0.3; //ALTURA DE SPYRO

  //LOS TAMAÑOS ESTÁN HECHOS SOBRE 2, YA QUE 2 ES EL ANCHO DE LA PANTALLA

  //COMPROBADOR DE SI EL JUEGO HA COMENZADO
  bool juegoComenzado = false;

  //VARIABLES DE LA BARRERA
  static List<double> barreraX = [2, 2 + 1.5];
  static double anchoBarrera = 0.5;
  List<List<double>> altoBarrera = [
    //[altura superior, altura inferior]
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  void comenzarJuego() {
    juegoComenzado = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      //ECUACIÓN DEL SALTO
      altura = gravedad * tiempo * tiempo + velocidad * tiempo;

      setState(() {
        spyroY = posicionInicial - altura;
      });

      //PARAMOS EL JUEGO SI SPYRO HA MUERTO
      if (spyroHaMuerto()) {
        timer.cancel();
        _showDialog();
      }

      //MOVEMOS EL MAPA (BARRERAS) CONSTANTEMENTE
      moverMapa();

      //Y QUE SIGA EL TIEMPO
      tiempo += 0.01;
    });
  }

  void moverMapa() {
    for (int i = 0; i < barreraX.length; i++) {
      //MOVEMOS LAS BARRERAS
      setState(() {
        barreraX[i] -= 0.005;
      });

      //SI LA BARRERA SALE DEL MAPA, LA HACEMOS RETROCEDER PARA QUE
      //VUELVA A APARECER
      if (barreraX[i] < -1.5) {
        barreraX[i] += 3;
      }
    }
  }

  void resetearJuego() {
    Navigator.pop(context); //QUITAMOS LA PANTALLA DE ALERTA
    setState(() {
      spyroY = 0;
      juegoComenzado = false;
      tiempo = 0;
      posicionInicial = spyroY;
      barreraX = [2, 2 + 1.5];
    });
  }

  //PANTALLA DE ALERTA EN CASO DE QUE PERDAMOS
  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: Center(
              child: Text(
                "PERDISTE POR BOBO",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetearJuego,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: Text(
                      'INTENTAR DE NUEVO',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  //METODO DE SALTO
  void salto() {
    setState(() {
      tiempo = 0;
      posicionInicial = spyroY;
    });
  }

  //COMPROBAMOS SI SPYRO HA MUERTO
  bool spyroHaMuerto() {
    //SI CHOCA CON EL 'TECHO'
    if (spyroY < -1 || spyroY > 1) {
      return true;
    }

    //O SI CHOCA CON LAS BARRERAS COMPROBANDO SI LAS COORDENADAS DE AMBOS
    //OBJETOS COINCIDEN
    for (int i = 0; i < barreraX.length; i++) {
      if (barreraX[i] <= anchoSpyro &&
          barreraX[i] + anchoBarrera >= -anchoSpyro &&
          (spyroY <= -1 + altoBarrera[i][0] ||
              spyroY + altoSpyro >= 1 - altoBarrera[i][1])) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: juegoComenzado ? salto : comenzarJuego,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [
                      //SPYRO
                      SpyroMuneco(
                        spyroY: spyroY,
                        anchoSpyro: anchoSpyro,
                        altoSpyro: altoSpyro,
                      ),

                      //EL JUEGO EMPIEZA SI PULSAMOS LA PANTALLA
                      TextoSuperior(gameHasStarted: juegoComenzado),

                      //BARRERA SUPERIOR 1
                      BarreraTextura(
                        barreraX: barreraX[0],
                        anchoBarrera: anchoBarrera,
                        alturaBarrera: altoBarrera[0][0],
                        esBarreraInferior: false,
                      ),

                      //BARRERA INFERIOR 1
                      BarreraTextura(
                        barreraX: barreraX[0],
                        anchoBarrera: anchoBarrera,
                        alturaBarrera: altoBarrera[0][1],
                        esBarreraInferior: true,
                      ),

                      //BARRERA SUPERIOR 2
                      BarreraTextura(
                        barreraX: barreraX[1],
                        anchoBarrera: anchoBarrera,
                        alturaBarrera: altoBarrera[1][0],
                        esBarreraInferior: false,
                      ),

                      //BARRIER INFERIOR 2
                      BarreraTextura(
                        barreraX: barreraX[1],
                        anchoBarrera: anchoBarrera,
                        alturaBarrera: altoBarrera[1][1],
                        esBarreraInferior: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //PARTE SUPERIOR DONDE ESTÁ LA PUNTUACIÓN
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'PEPE',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            '0',
                            style: TextStyle(color: Colors.white, fontSize: 35),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'P U N T U A C I O N',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
