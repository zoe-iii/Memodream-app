import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const IconGeneratorApp());
}

class IconGeneratorApp extends StatelessWidget {
  const IconGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black12,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '梦绪 App Icon 预览\n1024 x 1024 像素',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 30),

              Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.5),
                      blurRadius: 50,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: CustomPaint(
                    size: const Size(350, 350),
                    painter: DreamIconPainter(),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton.icon(
                onPressed: () => _saveIcon(context),
                icon: const Icon(Icons.download),
                label: const Text('保存图标到本地'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                '提示：保存后请将图片复制到\n原项目 assets/images/icon.png',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveIcon(BuildContext context) async {
    // 创建1024x1024的画布
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(1024, 1024);

    final painter = DreamIconPainter();
    painter.paint(canvas, size);

    final picture = recorder.endRecording();
    final img = await picture.toImage(1024, 1024);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) return;

    final buffer = byteData.buffer.asUint8List();

    final directory = await getDownloadsDirectory();
    if (directory == null) return;

    final filePath = '${directory.path}/memodream_icon.png';
    final file = File(filePath);
    await file.writeAsBytes(buffer);

    // 关键修复：添加 mounted 检查
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('图标已保存到下载文件夹！')));
    }
  }
}

class DreamIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final bgGradient = RadialGradient(
      center: const Alignment(-0.3, -0.3),
      radius: 1.2,
      colors: [
        const Color(0xFF2D1B69),
        const Color(0xFF1A1A3E),
        const Color(0xFF0A0E21),
      ],
    );

    final bgPaint = Paint()
      ..shader = bgGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
    canvas.drawCircle(center, radius, bgPaint);

    final random = Random(42);
    for (int i = 0; i < 25; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final dist = random.nextDouble() * radius * 0.85;
      final starPos = center + Offset(cos(angle) * dist, sin(angle) * dist);
      final starSize = random.nextDouble() * 3 + 1;

      canvas.drawCircle(
        starPos,
        starSize,
        Paint()
          ..color = Colors.white.withValues(
            alpha: random.nextDouble() * 0.5 + 0.2,
          )
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
      );
    }

    final glowPaint = Paint()
      ..color = const Color(0xFF6C63FF).withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);
    canvas.drawCircle(center + const Offset(-30, 20), radius * 0.5, glowPaint);

    final moonCenter = center + const Offset(10, -10);
    final moonRadius = radius * 0.32;

    canvas.drawCircle(
      moonCenter,
      moonRadius,
      Paint()
        ..color = const Color(0xFFffd700).withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );

    final moonPath = Path()
      ..addArc(
        Rect.fromCircle(center: moonCenter, radius: moonRadius),
        pi * 0.15,
        pi * 1.7,
      );

    final innerPath = Path()
      ..addArc(
        Rect.fromCircle(
          center: moonCenter + const Offset(18, -8),
          radius: moonRadius * 0.8,
        ),
        pi * 0.1,
        pi * 1.8,
      );

    final crescentPath = Path.combine(
      PathOperation.difference,
      moonPath,
      innerPath,
    );

    canvas.drawPath(
      crescentPath,
      Paint()
        ..color = const Color(0xFFffd700)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    canvas.drawCircle(
      moonCenter + Offset(-moonRadius * 0.3, -moonRadius * 0.3),
      moonRadius * 0.15,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.9)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    final bigStarPos = center + Offset(radius * 0.45, -radius * 0.35);

    canvas.drawCircle(
      bigStarPos,
      15,
      Paint()
        ..color = const Color(0xFF00D9FF).withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    final starPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      bigStarPos + const Offset(0, -12),
      bigStarPos + const Offset(0, 12),
      starPaint,
    );
    canvas.drawLine(
      bigStarPos + const Offset(-12, 0),
      bigStarPos + const Offset(12, 0),
      starPaint,
    );
    canvas.drawCircle(bigStarPos, 4, Paint()..color = Colors.white);

    canvas.drawCircle(
      center + Offset(radius * 0.35, radius * 0.55),
      5,
      Paint()
        ..color = const Color(0xFF9D4EDD).withValues(alpha: 0.9)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
  }

  @override
  bool shouldRepaint(covariant customPainter) => false;
}
