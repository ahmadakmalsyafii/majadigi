import 'package:flutter/material.dart';

class HargaChartWidget extends StatelessWidget {
  const HargaChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grafik Harga',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Dummy chart representation
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                // Y-axis labels
                const Positioned(
                  left: 0,
                  top: 0,
                  bottom: 24,
                  width: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('1k+', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text('500', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text('150', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text('100', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text('50', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text('10', style: TextStyle(color: Colors.grey, fontSize: 10)),
                    ],
                  ),
                ),
                // Graph lines (Dummy)
                Positioned(
                  left: 40,
                  right: 0,
                  top: 0,
                  bottom: 24,
                  child: CustomPaint(
                    painter: _DummyChartPainter(),
                  ),
                ),
                // X-axis labels
                const Positioned(
                  left: 40,
                  right: 0,
                  bottom: 0,
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sun', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text('Mon', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text('Tue', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text('Wed', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text('Thu', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text('Fri', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text('Sat', style: TextStyle(color: Colors.grey, fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DummyChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    // Draw 6 grid lines
    for (int i = 0; i < 6; i++) {
      double y = size.height * (i / 5);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint, // In a real app we might use dotted line effect
      );
    }

    // Draw the main line
    final linePaint = Paint()
      ..color = Colors.cyan.shade400
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.6, size.width * 0.3, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.9, size.width * 0.5, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.2, size.width * 0.7, size.height * 0.1); // Peak
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.5, size.width * 0.85, size.height * 0.5);
    path.lineTo(size.width, size.height * 0.5);

    canvas.drawPath(path, linePaint);

    // Draw a secondary line (faded)
    final secLinePaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final secPath = Path();
    secPath.moveTo(0, size.height * 0.9);
    secPath.quadraticBezierTo(size.width * 0.2, size.height * 0.9, size.width * 0.3, size.height * 0.6);
    secPath.quadraticBezierTo(size.width * 0.4, size.height * 0.5, size.width * 0.5, size.height * 0.9);
    secPath.quadraticBezierTo(size.width * 0.6, size.height * 0.8, size.width * 0.7, size.height * 0.5); 
    secPath.quadraticBezierTo(size.width * 0.8, size.height * 0.8, size.width * 0.85, size.height * 0.8);
    secPath.lineTo(size.width, size.height * 0.8);

    canvas.drawPath(secPath, secLinePaint);

    // Draw peak point
    final pointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final pointBorderPaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final peakX = size.width * 0.7;
    final peakY = size.height * 0.1;
    
    // Draw vertical line from peak
    final vertLinePaint = Paint()
      ..color = Colors.orange.shade300
      ..strokeWidth = 1;
    canvas.drawLine(Offset(peakX, peakY), Offset(peakX, size.height), vertLinePaint);

    canvas.drawCircle(Offset(peakX, peakY), 4, pointPaint);
    canvas.drawCircle(Offset(peakX, peakY), 4, pointBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
