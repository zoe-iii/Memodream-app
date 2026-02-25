import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'page4.dart'; // 预留导入，即使现在没有文件也不会报错，等创建 page4 后自动生效

class SleepMonitorScreen extends StatefulWidget {
  const SleepMonitorScreen({super.key});

  @override
  State<SleepMonitorScreen> createState() => _SleepMonitorScreenState();
}

class _SleepMonitorScreenState extends State<SleepMonitorScreen>
    with TickerProviderStateMixin {
  MonitorStatus _status = MonitorStatus.monitoring;

  Timer? _timer;
  DateTime _startTime = DateTime.now();
  Duration _elapsed = Duration.zero;

  // 定时监测相关
  int? _scheduledHours; // 设置的监测小时数，null 表示手动模式
  Duration _remainingTime = Duration.zero; // 剩余时间

  late AnimationController _pulseController;
  late AnimationController _waveController;

  final Random _random = Random();
  double _heartRate = 72;
  double _movement = 0.3;
  String _sleepStage = '入睡';

  final List<double> _heartRateHistory = [];
  final List<double> _movementHistory = [];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _startTimer();

    for (int i = 0; i < 20; i++) {
      _heartRateHistory.add(70 + _random.nextDouble() * 10);
      _movementHistory.add(_random.nextDouble() * 0.5);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _startTime = DateTime.now().subtract(_elapsed);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_status == MonitorStatus.monitoring) {
        setState(() {
          _elapsed = DateTime.now().difference(_startTime);

          // 如果有设置定时，检查是否到达时间
          if (_scheduledHours != null) {
            final totalSeconds = _scheduledHours! * 3600;
            final elapsedSeconds = _elapsed.inSeconds;
            _remainingTime = Duration(seconds: totalSeconds - elapsedSeconds);

            // 时间到了自动结束
            if (_remainingTime.inSeconds <= 0) {
              _autoEndMonitoring();
            }
          }

          _updateSleepData();
        });
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _updateSleepData() {
    _heartRate = 60 + _random.nextDouble() * 20;
    _heartRateHistory.add(_heartRate);
    if (_heartRateHistory.length > 20) _heartRateHistory.removeAt(0);

    _movement = _random.nextDouble() * 0.8;
    _movementHistory.add(_movement);
    if (_movementHistory.length > 20) _movementHistory.removeAt(0);

    setState(() {
      if (_heartRate < 65 && _movement < 0.15) {
        _sleepStage = '深睡';
      } else if (_heartRate >= 65 && _heartRate < 75 && _movement < 0.3) {
        _sleepStage = '浅睡';
      } else if (_heartRate >= 75 && _heartRate < 85 && _movement < 0.1) {
        _sleepStage = 'REM';
      } else if (_heartRate >= 85 || _movement > 0.5) {
        _sleepStage = '入睡';
      }
    });
  }

  // 设置监测时长
  void _showDurationPicker() {
    if (_status != MonitorStatus.monitoring) return; // 只有在监测中才能设置

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '设置监测时长',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE0E0F0),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _buildDurationChip(1),
                  _buildDurationChip(2),
                  _buildDurationChip(3),
                  _buildDurationChip(4),
                  _buildDurationChip(6),
                  _buildDurationChip(8),
                ],
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() {
                    _scheduledHours = null;
                    _remainingTime = Duration.zero;
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  '手动结束模式',
                  style: TextStyle(color: Color(0xFF6C5DD3)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDurationChip(int hours) {
    final isSelected = _scheduledHours == hours;
    return ChoiceChip(
      label: Text('$hours 小时'),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _scheduledHours = hours;
            _remainingTime = Duration(hours: hours);
          });
          Navigator.pop(context);
        }
      },
      backgroundColor: const Color(0xFF252542),
      selectedColor: const Color(0xFF6C5DD3),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFFB8A9C9),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final hours = _elapsed.inHours.toString().padLeft(2, '0');
    final minutes = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String get _formattedRemainingTime {
    if (_scheduledHours == null) return '手动模式';
    final hours = _remainingTime.inHours.toString().padLeft(2, '0');
    final minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');
    return '剩余 $hours:$minutes:$seconds';
  }

  void _togglePause() {
    HapticFeedback.mediumImpact();
    setState(() {
      if (_status == MonitorStatus.monitoring) {
        _status = MonitorStatus.paused;
        _pauseTimer();
      } else if (_status == MonitorStatus.paused) {
        _status = MonitorStatus.monitoring;
        _startTimer();
      }
    });
  }

  // 自动结束（定时到达）
  void _autoEndMonitoring() {
    _pauseTimer();
    setState(() => _status = MonitorStatus.ended);

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '监测完成',
          style: TextStyle(
            color: Color(0xFFE0E0F0),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '已完成 $_scheduledHours 小时睡眠监测\n即将为您生成睡眠报告...',
          style: const TextStyle(color: Color(0xFFB8A9C9)),
        ),
      ),
    );

    // 5秒后跳转到 page4
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pop(); // 关闭对话框
        _navigateToPage4();
      }
    });
  }

  // 手动结束
  void _endMonitoring() {
    HapticFeedback.heavyImpact();
    _pauseTimer();
    setState(() => _status = MonitorStatus.ended);

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '睡眠监测已结束',
          style: TextStyle(
            color: Color(0xFFE0E0F0),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '本次睡眠时长：$_formattedTime\n主要睡眠阶段：$_sleepStage\n\n即将为您生成睡眠报告...',
          style: const TextStyle(color: Color(0xFFB8A9C9)),
        ),
      ),
    );

    // 5秒后跳转到 page4
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pop(); // 关闭对话框
        _navigateToPage4();
      }
    });
  }

  // 跳转到 page4
  void _navigateToPage4() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Page4(),
      ), // 假设 page4 的类名是 SleepReportScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D15),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0D0D15),
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E).withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 顶部 - 添加设置时长按钮
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Color(0xFF6C5DD3),
                          size: 20,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          '睡眠监测中',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8B8BA7),
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    // 设置时长按钮
                    GestureDetector(
                      onTap: _showDurationPicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _scheduledHours != null
                              ? const Color(0xFF6C5DD3).withValues(alpha: 0.3)
                              : const Color(0xFF252542),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(
                              0xFF6C5DD3,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          _scheduledHours != null ? '$_scheduledHours小时' : '定时',
                          style: TextStyle(
                            fontSize: 12,
                            color: _scheduledHours != null
                                ? const Color(0xFF6C5DD3)
                                : const Color(0xFFB8A9C9),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 显示剩余时间（如果设置了定时）
              if (_scheduledHours != null && _status != MonitorStatus.ended)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _formattedRemainingTime,
                    style: TextStyle(
                      fontSize: 14,
                      color: _remainingTime.inMinutes < 30
                          ? const Color(0xFFEF5350)
                          : const Color(0xFF81C784),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              // 普通时钟
              _buildNormalClock(),

              const SizedBox(height: 16),

              // 状态文字
              Text(
                _status == MonitorStatus.monitoring
                    ? '监测中'
                    : _status == MonitorStatus.paused
                    ? '已暂停'
                    : '已结束',
                style: TextStyle(
                  fontSize: 14,
                  color: _status == MonitorStatus.monitoring
                      ? const Color(0xFF81C784)
                      : _status == MonitorStatus.paused
                      ? const Color(0xFFFFA726)
                      : const Color(0xFFEF5350),
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 40),

              // 三个数据板块
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(child: _buildHeartRateCard()),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMovementCard()),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSleepStageCard()),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 控制按钮
              _buildControlButtons(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNormalClock() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFF1E1E36), const Color(0xFF252542)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C5DD3).withValues(alpha: 0.15),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
            border: Border.all(
              color: const Color(0xFF6C5DD3).withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            _formattedTime,
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFE0E0F0),
              fontFamily: 'monospace',
              letterSpacing: 4,
              shadows: [
                Shadow(
                  color: const Color(0xFF6C5DD3).withValues(alpha: 0.5),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) => Container(
            width: 120,
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  const Color(
                    0xFF6C5DD3,
                  ).withValues(alpha: 0.3 + _pulseController.value * 0.4),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(1),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFF6C5DD3,
                  ).withValues(alpha: 0.2 * _pulseController.value),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeartRateCard() {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEF5350).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite,
                color: const Color(0xFFEF5350).withValues(alpha: 0.8),
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                '心率',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF8B8BA7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${_heartRate.toInt()}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE0E0F0),
            ),
          ),
          Text(
            'BPM',
            style: TextStyle(fontSize: 11, color: const Color(0xFF8B8BA7)),
          ),
          const Spacer(),
          SizedBox(
            height: 40,
            child: CustomPaint(
              size: const Size(double.infinity, 40),
              painter: WaveformPainter(
                data: _heartRateHistory,
                color: const Color(0xFFEF5350),
                animation: _waveController,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementCard() {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4ECDC4).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.waves,
                color: const Color(0xFF4ECDC4).withValues(alpha: 0.8),
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                '体动',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF8B8BA7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${(_movement * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE0E0F0),
            ),
          ),
          Text(
            '活跃度',
            style: TextStyle(fontSize: 11, color: const Color(0xFF8B8BA7)),
          ),
          const Spacer(),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _movementHistory
                  .take(10)
                  .map(
                    (value) => Container(
                      width: 6,
                      height: 8 + value * 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4ECDC4).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepStageCard() {
    Color stageColor;
    IconData stageIcon;

    switch (_sleepStage) {
      case '深睡':
        stageColor = const Color(0xFF6C5DD3);
        stageIcon = Icons.bedtime;
        break;
      case '浅睡':
        stageColor = const Color(0xFF81C784);
        stageIcon = Icons.nightlight;
        break;
      case 'REM':
        stageColor = const Color(0xFFFFB74D);
        stageIcon = Icons.visibility;
        break;
      case '入睡':
      default:
        stageColor = const Color(0xFF4FC3F7);
        stageIcon = Icons.access_time;
    }

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: stageColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                stageIcon,
                color: stageColor.withValues(alpha: 0.8),
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                '睡眠阶段',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF8B8BA7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  _sleepStage,
                  key: ValueKey(_sleepStage),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: stageColor,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: stageColor,
                boxShadow: [
                  BoxShadow(
                    color: stageColor.withValues(alpha: 0.6),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _status == MonitorStatus.ended ? null : _togglePause,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 56,
                decoration: BoxDecoration(
                  gradient: _status == MonitorStatus.ended
                      ? null
                      : LinearGradient(
                          colors: _status == MonitorStatus.paused
                              ? [
                                  const Color(0xFF81C784),
                                  const Color(0xFF66BB6A),
                                ]
                              : [
                                  const Color(0xFFFFA726),
                                  const Color(0xFFFF9800),
                                ],
                        ),
                  color: _status == MonitorStatus.ended
                      ? const Color(0xFF2D2D3A)
                      : null,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: _status == MonitorStatus.ended
                      ? []
                      : [
                          BoxShadow(
                            color:
                                (_status == MonitorStatus.paused
                                        ? const Color(0xFF81C784)
                                        : const Color(0xFFFFA726))
                                    .withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _status == MonitorStatus.paused
                            ? Icons.play_arrow
                            : Icons.pause,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _status == MonitorStatus.paused ? '继续' : '暂停',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: GestureDetector(
              onTap: _status == MonitorStatus.ended ? null : _endMonitoring,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEF5350), Color(0xFFE53935)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF5350).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.stop, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text(
                        '结束',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum MonitorStatus { monitoring, paused, ended }

class WaveformPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final Animation<double> animation;

  WaveformPainter({
    required this.data,
    required this.color,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path();
    final width = size.width;
    final height = size.height;
    final step = width / (data.length - 1);
    path.moveTo(0, height - (data[0] / 100) * height);
    for (int i = 1; i < data.length; i++) {
      path.lineTo(i * step, height - (data[i] / 100) * height * 0.8);
    }
    canvas.drawPath(path, paint);
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;
    canvas.drawPath(
      Path.from(path)
        ..lineTo(width, height)
        ..lineTo(0, height)
        ..close(),
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
