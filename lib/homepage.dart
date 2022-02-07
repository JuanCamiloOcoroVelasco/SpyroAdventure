import 'dart:async';
import 'barriers.dart';
import 'bird.dart';
import 'coverscreen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //VARIABLES DE SPYRO
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9; //FUERZA DE LA GRAVEDAD
  double velocity = 2.5; //FUERZA DEL SALTO
  double birdWidth = 0.3; //ANCHO DE SPYRO
  double birdHeight = 0.3; //ALTURA DE SPYRO

  //LOS TAMAÑOS ESTÁN HECHOS SOBRE 2, YA QUE 2 ES EL ANCHO DE LA PANTALLA

  //COMPROBADOR DE SI EL JUEGO HA COMENZADO
  bool gameHasStarted = false;

  //VARIABLES DE LA BARRERA
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    //[altura superior, altura inferior]
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      //ECUACIÓN DEL SALTO
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPos - height;
      });

      //PARAMOS EL JUEGO SI SPYRO HA MUERTO
      if (birdIsDead()) {
        timer.cancel();
        _showDialog();
      }

      //MOVEMOS EL MAPA (BARRERAS) CONSTANTEMENTE
      moveMap();

      //Y QUE SIGA EL TIEMPO
      time += 0.01;
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      //MOVEMOS LAS BARRERAS
      setState(() {
        barrierX[i] -= 0.005;
      });

      //SI LA BARRERA SALE DEL MAPA, LA HACEMOS RETROCEDER PARA QUE
      //VUELVA A APARECER
      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }
  }

  void resetGame() {
    Navigator.pop(context); //QUITAMOS LA PANTALLA DE ALERTA
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
      barrierX = [2, 2 + 1.5];
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
                onTap: resetGame,
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

  //SALTO
  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  //COMPROBAMOS SI SPYRO HA MUERTO
  bool birdIsDead() {
    //SI CHOCA CON EL 'TECHO'
    if (birdY < -1 || birdY > 1) {
      return true;
    }

    //O SI CHOCA CON LAS BARRERAS COMPROBANDO SI LAS COORDENADAS DE AMBOS
    //OBJETOS COINCIDEN
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
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
                      MyBird(
                        birdY: birdY,
                        birdWidth: birdWidth,
                        birdHeight: birdHeight,
                      ),

                      //EL JUEGO EMPIEZA SI PULSAMOS LA PANTALLA
                      MyCoverScreen(gameHasStarted: gameHasStarted),

                      //BARRERA SUPERIOR 1
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][0],
                        isThisBottomBarrier: false,
                      ),

                      //BARRERA INFERIOR 1
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][1],
                        isThisBottomBarrier: true,
                      ),

                      //BARRERA SUPERIOR 2
                      MyBarrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][0],
                        isThisBottomBarrier: false,
                      ),

                      //BARRIER INFERIOR 2
                      MyBarrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][1],
                        isThisBottomBarrier: true,
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
