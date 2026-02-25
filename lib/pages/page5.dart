import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'page4.dart';

class Page5 extends StatefulWidget {
  const Page5({super.key});

  @override
  State<Page5> createState() => _Page5State();
}

class _Page5State extends State<Page5> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final Map<String, dynamic> userStats = {
    'totalFragments': 12,
    'favoriteKeyword': '星云',
    'shortestFallAsleep': 8,
    'longestDeepSleep': 3.5,
  };

  // 梦绪星轨数据（历史记录）- 包含更多信息用于传递给报告页
  final List<Map<String, dynamic>> dreamHistory = [
    {
      'date': '2.08',
      'fullDate': '2025年2月8日',
      'day': '周四',
      'efficiency': 0.82,
      'dreamTitle': '星空漫步',
    },
    {
      'date': '2.10',
      'fullDate': '2025年2月10日',
      'day': '周六',
      'efficiency': 0.75,
      'dreamTitle': '深海秘境',
    },
    {
      'date': '2.12',
      'fullDate': '2025年2月12日',
      'day': '周一',
      'efficiency': 0.88,
      'dreamTitle': '云端城堡',
    },
    {
      'date': '2.14',
      'fullDate': '2025年2月14日',
      'day': '周三',
      'efficiency': 0.92,
      'dreamTitle': '时间花园',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          bottom: true, // 确保底部安全区域生效
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // 顶部导航
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white70,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Text(
                        '梦绪档案',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ========== 梦绪寄语 ==========
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF1A1F3D),
                          const Color(0xFF2D1B69).withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF6C63FF,
                          ).withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '你好呀，亲爱的造梦主',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '快来看看你的记录吧',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          height: 1,
                          width: 60,
                          color: const Color(0xFF6C63FF).withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              number: '${userStats['totalFragments']}',
                              label: '条梦绪碎片',
                              icon: Icons.auto_awesome,
                              color: const Color(0xFF00D9FF),
                            ),
                            _buildStatItem(
                              number: userStats['favoriteKeyword'],
                              label: '最爱关键词',
                              icon: Icons.favorite,
                              color: const Color(0xFFFF6B9D),
                              isText: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              number: '${userStats['shortestFallAsleep']}min',
                              label: '最短入睡',
                              icon: Icons.bolt,
                              color: const Color(0xFF00F5D4),
                            ),
                            _buildStatItem(
                              number: '${userStats['longestDeepSleep']}h',
                              label: '最长深睡',
                              icon: Icons.nights_stay,
                              color: const Color(0xFF9D4EDD),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ========== 梦绪星轨 ==========
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_graph,
                            color: Color(0xFF6C63FF),
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            '梦绪星轨',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '点击星星查看详情',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '你的梦境航行轨迹',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 星轨可视化区域 - 使用LayoutBuilder避免溢出
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          // 动态计算位置，避免屏幕宽度不足导致溢出
                          final positions = [
                            Offset(width * 0.15, 100),
                            Offset(width * 0.38, 70),
                            Offset(width * 0.62, 110),
                            Offset(width * 0.85, 80),
                          ];

                          return Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFF15192B),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(
                                  0xFF6C63FF,
                                ).withValues(alpha: 0.2),
                              ),
                            ),
                            child: Stack(
                              children: [
                                CustomPaint(
                                  size: Size(width, 200),
                                  painter: StarGridPainter(),
                                ),
                                AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return CustomPaint(
                                      size: Size(width, 200),
                                      painter: OrbitPathPainter(
                                        progress: _controller.value,
                                        nodeCount: dreamHistory.length,
                                        width: width,
                                      ),
                                    );
                                  },
                                ),
                                ...List.generate(dreamHistory.length, (index) {
                                  final pos =
                                      positions[index % positions.length];
                                  final data = dreamHistory[index];

                                  return Positioned(
                                    left: pos.dx - 25,
                                    top: pos.dy - 25,
                                    child: GestureDetector(
                                      onTap: () => _navigateToReport(index),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFF6C63FF),
                                                  Color(0xFF00D9FF),
                                                ],
                                              ),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(
                                                    0xFF00D9FF,
                                                  ).withValues(alpha: 0.5),
                                                  blurRadius: 15,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.star,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1A1F3D),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: const Color(
                                                  0xFF6C63FF,
                                                ).withValues(alpha: 0.3),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  data['date'],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  data['day'],
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.6),
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 36),

                  // ========== 梦绪洞察 ==========
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            color: Color(0xFF6C63FF),
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            '梦绪洞察',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '探索更深层的梦境世界',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 两个功能按钮 - 移除了固定高度，使用IntrinsicHeight避免溢出
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _buildInsightButton(
                                icon: Icons.edit_note,
                                title: '梦境问卷',
                                subtitle: '完善你的睡眠档案',
                                color: const Color(0xFF00D9FF),
                                onTap: () => _showQuestionnaire(),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInsightButton(
                                icon: Icons.workspace_premium,
                                title: '订阅服务',
                                subtitle: '解锁高级造梦指南',
                                color: const Color(0xFF9D4EDD),
                                onTap: () => _showSubscription(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // 关键修复：增加足够的底部安全距离，防止Bottom Overflow
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String number,
    required String label,
    required IconData icon,
    required Color color,
    bool isText = false,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 10),
        isText
            ? Text(
                number,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF1A1F3D), const Color(0xFF0F1433)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // 修改后的导航方法：传递选中的梦境数据
  void _navigateToReport(int index) {
    final selectedDream = dreamHistory[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Page4(
          date: selectedDream['date'],
          fullDate: selectedDream['fullDate'],
          day: selectedDream['day'],
          efficiency: selectedDream['efficiency'],
          dreamTitle: selectedDream['dreamTitle'],
        ),
      ),
    );
  }

  void _showQuestionnaire() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F3D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.edit_note, color: Color(0xFF00D9FF), size: 48),
            const SizedBox(height: 16),
            const Text(
              '梦境问卷',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '完善问卷可获取更精准的梦境引导方案',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00D9FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '开始填写',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showSubscription() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F3D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(
              Icons.workspace_premium,
              color: Color(0xFF9D4EDD),
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              '订阅服务',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '解锁无限梦境素材库与AI梦境分析师',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9D4EDD),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '查看方案',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class StarGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;

    for (int i = 0; i < size.width; i += 40) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }
    for (int i = 0; i < size.height; i += 40) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }

    final starPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final x = (i * 37) % size.width;
      final y = (i * 23) % size.height;
      canvas.drawCircle(Offset(x, y), (i % 3 + 1).toDouble(), starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OrbitPathPainter extends CustomPainter {
  final double progress;
  final int nodeCount;
  final double width;

  OrbitPathPainter({
    required this.progress,
    required this.nodeCount,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6C63FF).withValues(alpha: 0.4)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final points = [
      Offset(width * 0.15, 100),
      Offset(width * 0.38, 70),
      Offset(width * 0.62, 110),
      Offset(width * 0.85, 80),
    ];

    if (points.isEmpty) return;

    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final controlPoint = Offset((current.dx + next.dx) / 2, current.dy - 30);
      path.quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        next.dx,
        next.dy,
      );
    }

    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      final extractPath = metric.extractPath(0, metric.length * progress);
      canvas.drawPath(extractPath, paint);

      final glowPaint = Paint()
        ..color = const Color(0xFF00D9FF).withValues(alpha: 0.3)
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawPath(extractPath, glowPaint);
    }

    if (progress > 0.5) {
      final particlePaint = Paint()
        ..color = const Color(0xFF00D9FF)
        ..style = PaintingStyle.fill;

      for (int i = 0; i < points.length; i++) {
        final delay = i * 0.2;
        if (progress > delay) {
          final particleProgress = ((progress - delay) / (1 - delay)).clamp(
            0.0,
            1.0,
          );
          canvas.drawCircle(
            Offset(
              points[i].dx,
              points[i].dy - 10 * sin(particleProgress * 3.14159),
            ),
            3 * particleProgress,
            particlePaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant OrbitPathPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.width != width;
}
