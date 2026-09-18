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

    return Card(
      color: const Color.fromARGB(255, 248, 219, 229),
      child: SizedBox(
        width: width * 0.18,
        height: height * 0.2,
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
                  color: Colors.blue[900],
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('  ${value.toStringAsFixed(decimalplace)}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
