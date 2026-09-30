import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final num value;
  final int decimalplace;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.decimalplace,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;

    final boxWidth = isPortrait ? width * 0.35 : width * 0.21;
    final boxHeight = isPortrait ? height * 0.14 : height * 0.25;

    return Card(
      color: Color(0xFF4DB6AC),
      child: SizedBox(
        width: boxWidth,
        height: boxHeight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF12304A),
                ),
              ),
              Divider(),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '  ${value.toStringAsFixed(decimalplace)}',
                    style: TextStyle(
                      color: Color(0xFF12304A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
