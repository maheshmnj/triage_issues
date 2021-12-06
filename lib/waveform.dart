import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WaveFormSample extends StatelessWidget {
  const WaveFormSample({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: loadGraph(),
        builder: (context, AsyncSnapshot<Int16List> waveData) {
          return (!waveData.hasData)
              ? const CircularProgressIndicator.adaptive()
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 20,
                      height: MediaQuery.of(context).size.height,
                      child: RepaintBoundary(
                        child: CustomPaint(
                          willChange: false,
                          isComplex: true,
                          painter: PaintTest(
                            waveData: waveData.data!,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}

class PaintTest extends CustomPainter {
  final Int16List waveData;

  const PaintTest({
    required this.waveData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final _height = size.height;
    double x = 0;
    double strokeSize = .5;
    const zoomFactor = .5;

    final Paint paintPos = Paint()
      ..color = Colors.pink
      ..strokeWidth = strokeSize
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    final Paint paintNeg = Paint()
      ..color = Colors.pink
      ..strokeWidth = strokeSize
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    final Paint paintZero = Paint()
      ..color = Colors.green
      ..strokeWidth = strokeSize
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    int index = 0;
    for (index = 0; index < waveData.length; index++) {
      if (waveData[index].isNegative) {
        canvas.drawLine(
            Offset(x, _height * 1 / 2),
            Offset(
                x, _height * 1 / 2 - waveData[index] / 32768 * (_height / 2)),
            paintPos);
        x += zoomFactor;
      } else {
        (waveData[index] == 0)
            ? canvas.drawLine(Offset(x, _height * 1 / 2),
                Offset(x, _height * 1 / 2 + 1), paintZero)
            : canvas.drawLine(
                Offset(x, _height * 1 / 2),
                Offset(x,
                    _height * 1 / 2 - waveData[index] / 32767 * (_height / 2)),
                paintNeg);
        x += zoomFactor;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

Future<Int16List> loadGraph() async {
  //*_____________________________________________
  //! LOAD ANY WAVE FILE - THIS IS 16bit 44.1 MONO
  //*_____________________________________________
  Int16List load16bitMonoWave = await rootBundle
      .load('assets/twinkle_twinkle_little_star.wav')
      .then((value) => value.buffer.asInt16List());
  //! THIN WAVE FILE TO 1/20
  Int16List waveDataThinned =
      Int16List((load16bitMonoWave.length * 1 / 20).round());
  int reducedIndex = 0;
  for (int index = 0; index + 20 < load16bitMonoWave.length; index += 20) {
    waveDataThinned[reducedIndex] = load16bitMonoWave[index];
    reducedIndex++;
  }
  return waveDataThinned;
}
