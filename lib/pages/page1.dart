import 'dart:math';
import 'package:flutter/material.dart';
import 'page2.dart'; // 确保导入Page2
import 'page5.dart';
import 'page6.dart';

void main() {
  runApp(const MemoDreamApp());
}

class MemoDreamApp extends StatelessWidget {
  const MemoDreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MemoDream',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _planetMoveController;
  late AnimationController _planetRotateController;
  late AnimationController _ringController;
  late AnimationController _starController;
  late AnimationController _sparkleController;
  late AnimationController _textController;

  late Animation<Offset> _planetMoveAnimation;
  late Animation<double> _line1Animation;
  late Animation<double> _line2Animation;
  late Animation<double> _line3Animation;

  final List<Star> stars = [];
  final Random random = Random();
  final List<Sparkle> sparkles = [];

  @override
  void initState() {
    super.initState();
    _initStars();

    _planetMoveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);

    _planetMoveAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(-20, -15),
        ).animate(
          CurvedAnimation(
            parent: _planetMoveController,
            curve: Curves.easeInOut,
          ),
        );

    _planetRotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();

    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..forward();

    _line1Animation = CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );
    _line2Animation = CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.25, 0.6, curve: Curves.easeOut),
    );
    _line3Animation = CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.55, 0.9, curve: Curves.easeOut),
    );

    _generateSparkles();
  }

  void _initStars() {
    for (int i = 0; i < 80; i++) {
      stars.add(
        Star(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 2 + 0.5,
          opacity: random.nextDouble() * 0.7 + 0.3,
          speedX: (random.nextDouble() - 0.5) * 0.0005,
          speedY: (random.nextDouble() - 0.5) * 0.0005,
        ),
      );
    }
  }

  void _generateSparkles() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          sparkles.add(
            Sparkle(
              x: random.nextDouble() * 0.8 + 0.1,
              startY: -0.1,
              size: random.nextDouble() * 3 + 1,
              speed: random.nextDouble() * 0.002 + 0.001,
              opacity: random.nextDouble() * 0.6 + 0.4,
            ),
          );
        });
        if (sparkles.length > 15) sparkles.removeAt(0);
        _generateSparkles();
      }
    });
  }

  @override
  void dispose() {
    _planetMoveController.dispose();
    _planetRotateController.dispose();
    _ringController.dispose();
    _starController.dispose();
    _sparkleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0d0d1a),
              Color(0xFF12122b),
              Color(0xFF1a1a3e),
              Color(0xFF252550),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // 背景星星层
            AnimatedBuilder(
              animation: _starController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: StarPainter(stars, _starController.value),
                );
              },
            ),

            // 亮片层
            AnimatedBuilder(
              animation: _sparkleController,
              builder: (context, child) {
                for (var sparkle in sparkles) {
                  sparkle.y += sparkle.speed;
                  if (sparkle.y > 1.2) {
                    sparkle.y = -0.1;
                    sparkle.x = random.nextDouble() * 0.8 + 0.1;
                  }
                }
                sparkles.removeWhere((s) => s.y > 1.2);
                return CustomPaint(
                  size: Size.infinite,
                  painter: SparklePainter(sparkles),
                );
              },
            ),

            // 主内容层
            SafeArea(
              child: Stack(
                children: [
                  // 小行星（背景层）
                  Positioned(
                    right: 20,
                    bottom: 100,
                    child: SlideTransition(
                      position: _planetMoveAnimation,
                      child: RotationTransition(
                        turns: _planetRotateController,
                        child: SizedBox(
                          width: 140,
                          height: 140,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              RotationTransition(
                                turns: _ringController,
                                child: Container(
                                  width: 200,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(
                                        0xFF8a8ab0,
                                      ).withValues(alpha: 0.25),
                                      width: 1.2,
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.transparent,
                                        const Color(
                                          0xFF9a9ab8,
                                        ).withValues(alpha: 0.2),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              RotationTransition(
                                turns: ReverseAnimation(_ringController),
                                child: Container(
                                  width: 160,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(
                                        0xFF6C63FF,
                                      ).withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(45),
                                  ),
                                ),
                              ),
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    center: const Alignment(-0.3, -0.3),
                                    colors: [
                                      const Color(
                                        0xFFb8b8d8,
                                      ).withValues(alpha: 0.9),
                                      const Color(
                                        0xFF8a8ab0,
                                      ).withValues(alpha: 0.8),
                                      const Color(
                                        0xFF5a5a7a,
                                      ).withValues(alpha: 0.9),
                                      const Color(
                                        0xFF3a3a5a,
                                      ).withValues(alpha: 0.95),
                                    ],
                                    stops: const [0.1, 0.4, 0.8, 1.0],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF8a8ab0,
                                      ).withValues(alpha: 0.3),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                    BoxShadow(
                                      color: const Color(
                                        0xFF000000,
                                      ).withValues(alpha: 0.4),
                                      blurRadius: 20,
                                      spreadRadius: -5,
                                      offset: const Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: CustomPaint(
                                    size: const Size(110, 110),
                                    painter: PlanetSurfacePainter(),
                                  ),
                                ),
                              ),
                              RotationTransition(
                                turns: _planetRotateController,
                                child: Transform.translate(
                                  offset: const Offset(65, 0),
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFe0e0ff),
                                          Color(0xFFa0a0d0),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFe0e0ff,
                                          ).withValues(alpha: 0.6),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 主界面内容
                  Column(
                    children: [
                      // 顶部标题
                      Padding(
                        padding: const EdgeInsets.only(left: 24, top: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFffd700),
                                    Color(0xFFffed4e),
                                    Color(0xFFffa500),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFffd700,
                                    ).withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: CustomPaint(painter: MoonPainter()),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'MemoDream',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 2,
                                color: Color(0xFFffd700),
                                fontFamily: 'Georgia',
                                shadows: [
                                  Shadow(
                                    color: Color(0xFFffd700),
                                    blurRadius: 15,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(flex: 2),

                      // 欢迎文字
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            FadeTransition(
                              opacity: _line1Animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.3),
                                  end: Offset.zero,
                                ).animate(_line1Animation),
                                child: const Text(
                                  '欢迎回家，亲爱的造梦主，',
                                  style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.white,
                                    letterSpacing: 4,
                                    height: 2.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            FadeTransition(
                              opacity: _line2Animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.3),
                                  end: Offset.zero,
                                ).animate(_line2Animation),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 23,
                                      color: Colors.white,
                                      letterSpacing: 4,
                                      height: 2.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    children: [
                                      TextSpan(text: '这是您的第'),
                                      TextSpan(
                                        text: '28',
                                        style: TextStyle(
                                          color: Color(0xFFffd700),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(text: '次梦绪，'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            FadeTransition(
                              opacity: _line3Animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.3),
                                  end: Offset.zero,
                                ).animate(_line3Animation),
                                child: const Text(
                                  '愿您好梦依旧。',
                                  style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.white,
                                    letterSpacing: 4,
                                    height: 2.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(flex: 2),

                      // 功能按钮 - 关键修正：梦绪新启跳转到Page2
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 100,
                          left: 20,
                          right: 20,
                        ),
                        child: Column(
                          children: [
                            SoftButton(
                              icon: Icons.add_circle_outline,
                              label: '梦绪新启',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DreamEntryScreen(), // 跳转到Page2
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            SoftButton(
                              icon: Icons.auto_stories_outlined,
                              label: '梦绪档案',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Page5(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            SoftButton(
                              icon: Icons.person_outline,
                              label: '个人中心',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Page6(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const Spacer(flex: 1),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 柔和点击按钮
class SoftButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SoftButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<SoftButton> createState() => _SoftButtonState();
}

class _SoftButtonState extends State<SoftButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        transform: Matrix4.diagonal3Values(
          _isPressed ? 0.97 : 1.0,
          _isPressed ? 0.97 : 1.0,
          1,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: _isPressed ? 0.15 : 0.1),
              Colors.white.withValues(alpha: _isPressed ? 0.08 : 0.05),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: _isPressed ? 0.3 : 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(
                0xFF9d4edd,
              ).withValues(alpha: _isPressed ? 0.15 : 0.2),
              blurRadius: _isPressed ? 15 : 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: const Color(
                0xFFe0aaff,
              ).withValues(alpha: _isPressed ? 0.8 : 1.0),
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withValues(alpha: _isPressed ? 0.8 : 0.9),
                letterSpacing: 4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 数据类与绘制器
class Star {
  double x, y, size, opacity, speedX, speedY;
  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speedX,
    required this.speedY,
  });
}

class StarPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;
  StarPainter(this.stars, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeCap = StrokeCap.round;
    for (var star in stars) {
      double newX = (star.x + star.speedX * animationValue * 1000) % 1.0;
      double newY = (star.y + star.speedY * animationValue * 1000) % 1.0;
      if (newX < 0) newX += 1.0;
      if (newY < 0) newY += 1.0;
      double twinkle =
          sin(animationValue * 2 * pi * 3 + star.x * 10) * 0.3 + 0.7;
      paint.color = Colors.white.withValues(alpha: star.opacity * twinkle);
      paint.strokeWidth = star.size;
      canvas.drawCircle(
        Offset(newX * size.width, newY * size.height),
        star.size / 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Sparkle {
  double x, y, startY, size, speed, opacity;
  Sparkle({
    required this.x,
    required this.startY,
    required this.size,
    required this.speed,
    required this.opacity,
  }) : y = startY;
}

class SparklePainter extends CustomPainter {
  final List<Sparkle> sparkles;
  SparklePainter(this.sparkles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var sparkle in sparkles) {
      final paint = Paint()
        ..color = Colors.white.withValues(
          alpha: sparkle.opacity * (1 - sparkle.y),
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      final center = Offset(sparkle.x * size.width, sparkle.y * size.height);
      canvas.drawLine(
        Offset(center.dx, center.dy - sparkle.size),
        Offset(center.dx, center.dy + sparkle.size),
        paint..strokeWidth = sparkle.size * 0.3,
      );
      canvas.drawLine(
        Offset(center.dx - sparkle.size, center.dy),
        Offset(center.dx + sparkle.size, center.dy),
        paint..strokeWidth = sparkle.size * 0.3,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MoonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0d0d1a)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.35),
      size.width * 0.35,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PlanetSurfacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);
    for (int i = 0; i < 8; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 8 + 3;
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = const Color(0xFF2a2a4a).withValues(alpha: 0.4)
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        Offset(x - 1, y - 1),
        radius - 1,
        Paint()
          ..color = const Color(0xFFa0a0c0).withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
    for (int i = 0; i < 5; i++) {
      final path = Path();
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;
      path.moveTo(startX, startY);
      path.quadraticBezierTo(
        startX + random.nextDouble() * 20 - 10,
        startY + random.nextDouble() * 20 - 10,
        startX + random.nextDouble() * 30 - 15,
        startY + random.nextDouble() * 30 - 15,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF6a6a8a).withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
