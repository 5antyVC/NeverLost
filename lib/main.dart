import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const CameraApp());
}

/// CameraApp is the Main Application.
class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({Key? key}) : super(key: key);

  @override
  State<CameraApp> createState() => _CameraAppState();
}
class CalcGap {
  late double dimensionTotal;
  late double tamanoOcupado;
  late double espacioARepartir;

  CalcGap(double dimensionTotal, double tamanoOcupado) {
    this.dimensionTotal = dimensionTotal;
    this.tamanoOcupado = tamanoOcupado;
  }

  double calcularEspacio(dimensionTotal, tamanoOcupado) {
    espacioARepartir = dimensionTotal - tamanoOcupado;
    return espacioARepartir / 4;
  }
}
class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
// Tengo que traspasar esto a una clase.
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    //******************************************************** */
    double tamanoOcupado = 290;
    CalcGap resul = CalcGap(screenWidth, tamanoOcupado);
    double TamanoGap = resul.calcularEspacio(screenWidth, tamanoOcupado);

    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: Stack(
        children: <Widget>[
          CameraPreview(controller),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: screenWidth * 0.90,
              height: screenHeight * 0.20,
              child: Image.asset('assets/billete.png'),
            ),
            Container(
              height: screenHeight * 0.57,
            ),
            Row(
              children: [
                Container(
                  height: 80,
                  width: screenWidth,
                  child: Row(children: [
                    SizedBox(
                      width: TamanoGap,
                    ),
                    Container(
                      width: 70,
                      height: 70,
                      child: Image.asset(
                        'assets/mapas-y-banderas.png',
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.blueAccent),
                    ),
                    SizedBox(
                      width: TamanoGap,
                    ),
                    Container(
                      width: 150,
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '50 m',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.white),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.blueAccent),
                    ),
                    SizedBox(
                      width: TamanoGap,
                    ),
                    Container(
                      width: 70,
                      height: 70,
                      child: Image.asset('assets/accesibilidad.png'),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.blueAccent),
                    ),
                  ]),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
          ),
        ],
      ),
    );
  }
}
