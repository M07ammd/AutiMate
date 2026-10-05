import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:atuimate_app/screens/parent/parent_home.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> assessment;

  const ResultScreen({super.key, required this.assessment});

  @override
  Widget build(BuildContext context) {
    final probability = (assessment["probability"] ?? 0) * 100;
    final nonAutism = 100 - probability;

    final risk = assessment["riskLevel"] ?? "UNKNOWN";
    final summary = assessment["summary"] ?? "";

    Color color =
    risk == "HIGH"
        ? Colors.red
        : risk == "MEDIUM"
        ? Colors.orange
        : Colors.green;

    return Scaffold(
      backgroundColor: const Color(0xffF4F6F6),
      appBar: AppBar(
        title: const Text("Result"),
        backgroundColor: const Color(0xFF45BB89),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// TOP VALUES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text("Autism Probability"),
                    Text(
                      "${probability.toStringAsFixed(2)}%",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text("Non-Autism Probability"),
                    Text(
                      "${nonAutism.toStringAsFixed(2)}%",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),
            SizedBox(
              height: 260,
              child: SfRadialGauge(
                axes: [
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    showLabels: false,
                    showTicks: false,

                    startAngle: 0,
                    endAngle: 360,

                    axisLineStyle: const AxisLineStyle(
                      thickness: 0.15,
                      thicknessUnit: GaugeSizeUnit.factor,
                      color: Color(0xffE6EAF2),
                    ),

                    pointers: [
                      RangePointer(
                        value: probability,
                        width: 0.15,
                        sizeUnit: GaugeSizeUnit.factor,
                        color: color,
                        cornerStyle: CornerStyle.bothCurve,
                      ),
                    ],

                    annotations: [
                      GaugeAnnotation(
                        angle: 90,
                        positionFactor: 0.0,
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${probability.toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              risk,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              summary,
              textAlign: TextAlign.center,
            ),

            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF45BB89),
                padding:
                const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ParentHome(),
                  ),
                      (route) => false,
                );
              },
              child: const Text(
                "Go Home",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
