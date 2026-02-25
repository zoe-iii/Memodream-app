import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Page4 extends StatefulWidget {
  // 所有参数都有默认值，避免调用时缺少参数报错
  final String date;
  final String fullDate;
  final String day;
  final double efficiency;
  final String dreamTitle;

  const Page4({
    super.key,
    this.date = '2.14',
    this.fullDate = '2025年2月14日',
    this.day = '周三',
    this.efficiency = 0.92,
    this.dreamTitle = '时间花园',
  });

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Map<String, dynamic> sleepData;
  late Map<String, dynamic> dreamProfile;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..forward();

    _initData();
  }

  void _initData() {
    // 修复：使用 efficiencyPercent 避免警告
    final efficiencyPercent = (widget.efficiency * 100).toInt();

    sleepData = {
      'heartRate': 60 + (widget.efficiency * 10).toInt(),
      'bodyMovement': (20 - widget.efficiency * 10).toInt(),
      'interventionStatus': '已完成',
      'sleepEfficiency': widget.efficiency,
      'fallAsleepTime': (15 - widget.efficiency * 8).toInt(),
      'deepSleepDuration': (2.0 + widget.efficiency).clamp(2.0, 4.0),
      'remIntervention': widget.efficiency,
      'efficiencyPercentile': efficiencyPercent, // 使用了变量
      'deepSleepImprovement': (widget.efficiency - 0.7).clamp(0.0, 0.3),
      'fallAsleepImprovement': (widget.efficiency - 0.8).clamp(-0.3, 0.2),
      'date': widget.fullDate,
      'totalSleepTime': '7h ${(32 + widget.efficiency * 20).toInt()}m',
      'dreamDuration': '1h ${(30 + widget.efficiency * 30).toInt()}m',
    };

    final dreamThemes = {
      '星空漫步': {
        'theme': '星云漫游',
        'tags': ['失重', '琉璃', '回声'],
        'icon': Icons.cloud_queue,
      },
      '深海秘境': {
        'theme': '深海潜游',
        'tags': ['静谧', '幽蓝', '潜流'],
        'icon': Icons.water,
      },
      '云端城堡': {
        'theme': '浮空城堡',
        'tags': ['漂浮', '柔软', '光辉'],
        'icon': Icons.castle,
      },
      '时间花园': {
        'theme': '时序花园',
        'tags': ['绽放', '时砂', '轮回'],
        'icon': Icons.access_time,
      },
    };

    final themeData = dreamThemes[widget.dreamTitle] ?? dreamThemes['星空漫步']!;

    dreamProfile = {
      'dreamType': widget.efficiency > 0.85 ? '清醒梦' : '普通梦',
      'consciousnessLevel': efficiencyPercent, // 使用了变量
      'dreamTheme': themeData['theme'],
      'moodTags': themeData['tags'],
      'dreamSignature':
          '今夜我在${themeData['theme']}里收集${(themeData['tags'] as List<String>)[0]}的${(themeData['tags'] as List<String>)[1]}',
      'icon': themeData['icon'],
    };
  }

  List<String> generateHealthTips() {
    if (widget.efficiency > 0.9) {
      return [
        '🌌 今夜意识漂移轨迹平稳，你在第3次REM期成功捕捉到"琉璃质地的回声"。',
        '⚡ 入睡速度击败全网${sleepData['efficiencyPercentile']}%的造梦师。',
        '🧬 深睡细胞修复指数超标，你的大脑皮层正在闪闪发光。',
      ];
    } else if (widget.efficiency > 0.8) {
      return [
        '🌙 梦境清晰度良好，你在REM期有一定的意识控制能力。',
        '✨ 深睡时长达标，身体恢复状况优于平均水平。',
        '💤 建议保持规律的作息时间，有望进入清醒梦状态。',
      ];
    } else {
      return [
        '🌊 今夜梦境较为模糊，建议尝试睡前冥想提升意识清晰度。',
        '📉 深睡比例有提升空间，建议减少睡前屏幕使用时间。',
        '🌱 尝试使用"梦境锚点"技巧，帮助在梦中保持意识清醒。',
      ];
    }
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
          bottom: true,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // 页面标题
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
                      Column(
                        children: [
                          const Text(
                            '梦绪报告',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.date} ${widget.day}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ========== 睡眠数据区域 ==========
                  Container(
                    height: MediaQuery.of(context).size.height * 0.40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF1A1F3D).withValues(alpha: 0.8),
                          const Color(0xFF0F1433).withValues(alpha: 0.9),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.bar_chart,
                                color: Color(0xFF6C63FF),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.date} 睡眠数据',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 45,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AnimatedBuilder(
                                        animation: _controller,
                                        builder: (context, child) {
                                          return CustomPaint(
                                            size: const Size(120, 120),
                                            painter: CircularProgressPainter(
                                              progress:
                                                  sleepData['sleepEfficiency'] *
                                                  _controller.value,
                                              backgroundColor: const Color(
                                                0xFF2A2F4D,
                                              ),
                                              progressColor: const Color(
                                                0xFF00D9FF,
                                              ),
                                              secondaryColor: const Color(
                                                0xFF6C63FF,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        '睡眠效率',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        '${(sleepData['sleepEfficiency'] * 100).toInt()}%',
                                        style: const TextStyle(
                                          color: Color(0xFF00D9FF),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 55,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildMetricBar(
                                        label: '入睡速度',
                                        value: sleepData['fallAsleepTime'] / 30,
                                        displayValue:
                                            '${sleepData['fallAsleepTime']}min',
                                        color: const Color(0xFF00D9FF),
                                        icon: Icons.bedtime_outlined,
                                      ),
                                      const SizedBox(height: 14),
                                      _buildMetricBar(
                                        label: '深睡时长',
                                        value:
                                            sleepData['deepSleepDuration'] / 4,
                                        displayValue:
                                            '${sleepData['deepSleepDuration']}h',
                                        color: const Color(0xFF9D4EDD),
                                        icon: Icons.nights_stay_outlined,
                                      ),
                                      const SizedBox(height: 14),
                                      _buildMetricBar(
                                        label: 'REM干预效果',
                                        value: sleepData['remIntervention'],
                                        displayValue:
                                            '${(sleepData['remIntervention'] * 100).toInt()}%',
                                        color: const Color(0xFF00F5D4),
                                        icon: Icons.psychology_outlined,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF6C63FF,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(
                                  0xFF6C63FF,
                                ).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Flexible(
                                  child: _buildComparisonBadge(
                                    icon: Icons.people_alt_outlined,
                                    text:
                                        '超过 ${sleepData['efficiencyPercentile']}% 用户',
                                    color: const Color(0xFF00D9FF),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 16,
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                                Flexible(
                                  child: _buildComparisonBadge(
                                    icon: Icons.trending_up,
                                    text: sleepData['deepSleepImprovement'] > 0
                                        ? '深睡 +${(sleepData['deepSleepImprovement'] * 100).toInt()}%'
                                        : '深睡 ${(sleepData['deepSleepImprovement'] * 100).toInt()}%',
                                    color: const Color(0xFF00F5D4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ========== 健康建议区域 ==========
                  Container(
                    height: MediaQuery.of(context).size.height * 0.22,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF15192B),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              color: Color(0xFF9D4EDD),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '梦绪建议',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: generateHealthTips().length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return _buildChatBubble(
                                generateHealthTips()[index],
                                isFirst: index == 0,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ========== 梦绪印象区域 ==========
                  Container(
                    height: MediaQuery.of(context).size.height * 0.42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF1A1F3D),
                          const Color(0xFF2D1B69).withValues(alpha: 0.95),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return CustomPaint(
                                size: Size(
                                  MediaQuery.of(context).size.width,
                                  MediaQuery.of(context).size.height * 0.42,
                                ),
                                painter: DreamFlowPainter(
                                  animationValue: _controller.value,
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withValues(
                                              alpha: 0.2,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.calendar_today,
                                              color: Color(0xFF00D9FF),
                                              size: 14,
                                            ),
                                            const SizedBox(width: 6),
                                            Flexible(
                                              child: Text(
                                                widget.fullDate,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color(
                                                0xFF6C63FF,
                                              ).withValues(alpha: 0.8),
                                              const Color(
                                                0xFF00D9FF,
                                              ).withValues(alpha: 0.6),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF6C63FF,
                                              ).withValues(alpha: 0.4),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.bubble_chart,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 6),
                                            Flexible(
                                              child: Text(
                                                '意识等级 ${dreamProfile['consciousnessLevel']}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 55,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 6,
                                                  height: 6,
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Color(
                                                          0xFF00F5D4,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    dreamProfile['dreamTheme'],
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0.5,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xFF6C63FF,
                                                ).withValues(alpha: 0.15),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFF6C63FF,
                                                  ).withValues(alpha: 0.3),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.timelapse,
                                                        color: Color(
                                                          0xFF00D9FF,
                                                        ),
                                                        size: 16,
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Flexible(
                                                        child: Text(
                                                          sleepData['totalSleepTime'],
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Flexible(
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 6,
                                                                vertical: 2,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color:
                                                                const Color(
                                                                  0xFF00D9FF,
                                                                ).withValues(
                                                                  alpha: 0.2,
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  4,
                                                                ),
                                                          ),
                                                          child: Text(
                                                            '${sleepData['dreamDuration']}清醒',
                                                            style:
                                                                const TextStyle(
                                                                  color: Color(
                                                                    0xFF00D9FF,
                                                                  ),
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '关键词：${(dreamProfile['moodTags'] as List<String>).join('·')}',
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.6,
                                                          ),
                                                      fontSize: 11,
                                                      letterSpacing: 0.5,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(
                                                  alpha: 0.05,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.1),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.edit_note,
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.5,
                                                            ),
                                                        size: 12,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        '梦绪个签',
                                                        style: TextStyle(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.5,
                                                              ),
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    dreamProfile['dreamSignature'],
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.9,
                                                          ),
                                                      fontSize: 12,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      height: 1.3,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        flex: 45,
                                        child: Center(
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: RadialGradient(
                                                  colors: [
                                                    const Color(
                                                      0xFF00D9FF,
                                                    ).withValues(alpha: 0.3),
                                                    const Color(
                                                      0xFF6C63FF,
                                                    ).withValues(alpha: 0.1),
                                                    Colors.transparent,
                                                  ],
                                                  stops: const [0.2, 0.6, 1.0],
                                                ),
                                              ),
                                              child: Center(
                                                child: AnimatedBuilder(
                                                  animation: _controller,
                                                  builder: (context, child) {
                                                    return Transform.rotate(
                                                      angle:
                                                          _controller.value *
                                                          2 *
                                                          pi *
                                                          0.5,
                                                      child: Container(
                                                        width: 65,
                                                        height: 65,
                                                        decoration: BoxDecoration(
                                                          gradient:
                                                              SweepGradient(
                                                                center:
                                                                    Alignment
                                                                        .center,
                                                                colors: [
                                                                  const Color(
                                                                    0xFF6C63FF,
                                                                  ).withValues(
                                                                    alpha: 0.8,
                                                                  ),
                                                                  const Color(
                                                                    0xFF00D9FF,
                                                                  ).withValues(
                                                                    alpha: 0.6,
                                                                  ),
                                                                  const Color(
                                                                    0xFF00F5D4,
                                                                  ).withValues(
                                                                    alpha: 0.4,
                                                                  ),
                                                                  const Color(
                                                                    0xFF6C63FF,
                                                                  ).withValues(
                                                                    alpha: 0.8,
                                                                  ),
                                                                ],
                                                              ),
                                                          shape:
                                                              BoxShape.circle,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color:
                                                                  const Color(
                                                                    0xFF00D9FF,
                                                                  ).withValues(
                                                                    alpha: 0.5,
                                                                  ),
                                                              blurRadius: 20,
                                                              spreadRadius: 2,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Center(
                                                          child: Icon(
                                                            dreamProfile['icon']
                                                                    as IconData? ??
                                                                Icons
                                                                    .cloud_queue,
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.9,
                                                                ),
                                                            size: 30,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  height: 42,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _showShareOptions(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.15,
                                      ),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: Colors.white.withValues(
                                            alpha: 0.3,
                                          ),
                                        ),
                                      ),
                                      elevation: 0,
                                    ),
                                    icon: const Icon(
                                      Icons.share_rounded,
                                      size: 18,
                                    ),
                                    label: const Text(
                                      '分享梦绪',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 100), // 底部安全距离
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricBar({
    required String label,
    required double value,
    required String displayValue,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color.withValues(alpha: 0.8), size: 14),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            Text(
              displayValue,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            backgroundColor: const Color(0xFF2A2F4D),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 5,
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonBadge({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: color.withValues(alpha: 0.9),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildChatBubble(String text, {bool isFirst = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isFirst) ...[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF00D9FF)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
          ] else ...[
            const SizedBox(width: 42),
          ],
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.15),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isFirst ? 4 : 16),
                  topRight: const Radius.circular(16),
                  bottomLeft: const Radius.circular(16),
                  bottomRight: const Radius.circular(16),
                ),
                border: Border.all(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xDEFFFFFF),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F3D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
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
              Text(
                '分享 ${widget.date} 的梦绪',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareOption(
                    Icons.image,
                    '生成海报',
                    const Color(0xFF6C63FF),
                  ),
                  _buildShareOption(
                    Icons.link,
                    '复制链接',
                    const Color(0xFF00D9FF),
                  ),
                  _buildShareOption(
                    Icons.people,
                    '好友',
                    const Color(0xFF9D4EDD),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareOption(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final Color secondaryColor;

  CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 20) / 2;
    const strokeWidth = 12.0;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -90 * (3.14159 / 180),
      endAngle: 270 * (3.14159 / 180),
      colors: [progressColor, secondaryColor, progressColor],
      stops: const [0.0, 0.5, 1.0],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * (3.14159 / 180),
      sweepAngle,
      false,
      progressPaint,
    );

    final glowPaint = Paint()
      ..color = progressColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 8
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * (3.14159 / 180),
      sweepAngle,
      false,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DreamFlowPainter extends CustomPainter {
  final double animationValue;

  DreamFlowPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 5; i++) {
      final path = Path();
      final startY = size.height * 0.1 + (i * 25);
      path.moveTo(size.width * 0.5, startY);

      for (double x = size.width * 0.5; x < size.width; x += 20) {
        final y =
            startY +
            10 *
                (i % 2 == 0 ? 1 : -1) *
                sin(animationValue * 2 * 3.14159 + x / 30);
        path.lineTo(x, y);
      }

      final paint = Paint()
        ..color = Color.lerp(
          const Color(0xFF6C63FF),
          const Color(0xFF00D9FF),
          i / 5,
        )!.withValues(alpha: 0.1 + (i * 0.03))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(path, paint);
    }

    final dustPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final x =
          (i * 47 + animationValue * 30) % (size.width * 0.4) +
          size.width * 0.6;
      final y = (i * 23) % size.height.toInt();
      final radius = (i % 3 + 1) * 1.5;

      canvas.drawCircle(Offset(x, y.toDouble()), radius, dustPaint);
    }

    final center = Offset(size.width * 0.75, size.height * 0.3);
    final nebulaPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF6C63FF).withValues(alpha: 0.2),
          const Color(0xFF00D9FF).withValues(alpha: 0.1),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 60));

    canvas.drawCircle(center, 60 + (animationValue * 10), nebulaPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
