import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'page3.dart';

class DreamEntryScreen extends StatefulWidget {
  const DreamEntryScreen({super.key});

  @override
  State<DreamEntryScreen> createState() => _DreamEntryScreenState();
}

class _DreamEntryScreenState extends State<DreamEntryScreen>
    with TickerProviderStateMixin {
  int selectedEmotionIndex = 0;
  int selectedPackageIndex = 0;
  bool isUploadMenuOpen = false;
  bool isPickingFile = false;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<Map<String, dynamic>> emotions = [
    {
      'name': '甜蜜',
      'emoji': '🥰',
      'desc': '棉花糖般柔软',
      'color': const Color(0xFFFFA6C9),
      'subColor': const Color(0xFFFFD1E6),
      'glowColor': const Color(0xFFFF6B9D),
    },
    {
      'name': '困倦',
      'emoji': '😴',
      'desc': '沉入鹅绒枕头',
      'color': const Color(0xFF98D8C8),
      'subColor': const Color(0xFFC8F0E4),
      'glowColor': const Color(0xFF7BC4B2),
    },
    {
      'name': '兴奋',
      'emoji': '🤩',
      'desc': '追逐午夜流星',
      'color': const Color(0xFFFFD93D),
      'subColor': const Color(0xFFFFF0B5),
      'glowColor': const Color(0xFFFFC107),
    },
    {
      'name': '平静',
      'emoji': '🧘',
      'desc': '湖面月影荡漾',
      'color': const Color(0xFFC9B1FF),
      'subColor': const Color(0xFFE8D9FF),
      'glowColor': const Color(0xFFB39DDB),
    },
    {
      'name': '期待',
      'emoji': '✨',
      'desc': '拆礼物的瞬间',
      'color': const Color(0xFF87CEEB),
      'subColor': const Color(0xFFB8E6F0),
      'glowColor': const Color(0xFF5DADE2),
    },
  ];

  final List<Map<String, dynamic>> packages = [
    {
      'title': '深海漫游',
      'subtitle': '潜入蓝色梦境',
      'keywords': ['鲸歌', '失重', '深蓝'],
      'icon': Icons.water,
      'colors': [const Color(0xFF1A237E), const Color(0xFF3949AB)],
    },
    {
      'title': '云端漫步',
      'subtitle': '触碰棉花糖云',
      'keywords': ['漂浮', '轻盈', '绵软'],
      'icon': Icons.cloud,
      'colors': [const Color(0xFF7B1FA2), const Color(0xFFBA68C8)],
    },
    {
      'title': '林间晨雾',
      'subtitle': '呼吸第一缕清新',
      'keywords': ['露珠', '静谧', '氧吧'],
      'icon': Icons.forest,
      'colors': [const Color(0xFF1B5E20), const Color(0xFF4CAF50)],
    },
  ];

  final List<String> tags = [
    '鲸落',
    '失重感',
    '缓慢下沉',
    '坠入银河深处',
    '呼吸般的节奏',
    '漂浮云端',
    '微光里',
  ];

  Set<String> selectedTags = {};

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _pickFile() {
    HapticFeedback.mediumImpact();
    setState(() {
      isUploadMenuOpen = false;
      isPickingFile = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => isPickingFile = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('文件选择功能开发中...'),
            backgroundColor: const Color(0xFF6C5DD3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D15),
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0D0D15), Color(0xFF1A1A2E), Color(0xFF16213E)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 20),

                Expanded(
                  child: Column(
                    children: [
                      Expanded(flex: 30, child: _buildEmotionSection()),

                      const SizedBox(height: 28),

                      Expanded(flex: 35, child: _buildPackageSection()),

                      const SizedBox(height: 28),

                      Expanded(flex: 25, child: _buildMaterialSection()),

                      const SizedBox(height: 28),

                      Expanded(flex: 10, child: _buildDreamButton()),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20), // 0.08 -> 20
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withAlpha(26),
                ), // 0.1 -> 26
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFFB8A9C9),
                size: 18,
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                '梦绪新启',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFE0E0F0),
                  letterSpacing: 4,
                ),
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildEmotionSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.palette_rounded,
                color: Color(0xFFE0E0F0),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                '情绪色盘',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFE0E0F0),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: (emotions[selectedEmotionIndex]['color'] as Color)
                      .withAlpha(51), // 0.2 -> 51
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: (emotions[selectedEmotionIndex]['color'] as Color)
                        .withAlpha(77), // 0.3 -> 77
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '此刻心情: ',
                      style: TextStyle(
                        fontSize: 12,
                        color: emotions[selectedEmotionIndex]['color'],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      emotions[selectedEmotionIndex]['desc'],
                      style: TextStyle(
                        fontSize: 12,
                        color: emotions[selectedEmotionIndex]['color'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: emotions.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final e = emotions[index];
                final isSelected = selectedEmotionIndex == index;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() => selectedEmotionIndex = index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isSelected ? 90 : 84,
                    height: isSelected ? 90 : 84,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [e['color'], e['subColor']],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: (e['glowColor'] as Color).withAlpha(
                            isSelected ? 128 : 64,
                          ), // 0.5->128, 0.25->64
                          blurRadius: isSelected ? 20 : 12,
                          spreadRadius: isSelected ? 2 : 0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: isSelected
                            ? Colors.white.withAlpha(230) // 0.9 -> 230
                            : Colors.white.withAlpha(38), // 0.15 -> 38
                        width: isSelected ? 3 : 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedScale(
                          scale: isSelected ? 1.2 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            e['emoji'],
                            style: const TextStyle(fontSize: 38),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          e['name'],
                          style: TextStyle(
                            color: const Color(0xFF2D2D3A),
                            fontSize: isSelected ? 13 : 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: Color(0xFF9B8AA6),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                '梦绪套餐',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFB8A9C9),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Expanded(
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.88),
              onPageChanged: (index) =>
                  setState(() => selectedPackageIndex = index),
              itemCount: packages.length,
              itemBuilder: (context, index) {
                final p = packages[index];
                final isSelected = selectedPackageIndex == index;
                return AnimatedScale(
                  scale: isSelected ? 1.0 : 0.95,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: p['colors'],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: (p['colors'][0] as Color).withAlpha(
                            89,
                          ), // 0.35 -> 89
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -25,
                            bottom: -25,
                            child: Icon(
                              p['icon'],
                              size: 130,
                              color: Colors.white.withAlpha(15), // 0.06 -> 15
                            ),
                          ),
                          Positioned(
                            left: -25,
                            top: -25,
                            child: Icon(
                              p['icon'],
                              size: 90,
                              color: Colors.white.withAlpha(10), // 0.04 -> 10
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      p['title'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(
                                          51,
                                        ), // 0.2 -> 51
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  p['subtitle'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withAlpha(
                                      217,
                                    ), // 0.85 -> 217
                                  ),
                                ),

                                const Spacer(),

                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: (p['keywords'] as List<String>).map(
                                    (keyword) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(
                                            38,
                                          ), // 0.15 -> 38
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withAlpha(
                                              26,
                                            ), // 0.1 -> 26
                                          ),
                                        ),
                                        child: Text(
                                          keyword,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white.withAlpha(
                                              242,
                                            ), // 0.95 -> 242
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.edit_note_rounded,
                color: const Color(0xFF9B8AA6),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                '梦境素材',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFB8A9C9),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(153, 26, 26, 46), // 0.6 -> 153
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color.fromARGB(128, 45, 45, 58),
                ), // 0.5 -> 128
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF252542),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              focusNode: _focusNode,
                              style: const TextStyle(
                                color: Color(0xFFE0E0F0),
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: '记录当下的思绪...',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF6B6B7B),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                              ),
                              onTap: () =>
                                  setState(() => isUploadMenuOpen = false),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() {
                              isUploadMenuOpen = !isUploadMenuOpen;
                              if (isUploadMenuOpen) _focusNode.unfocus();
                            }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isUploadMenuOpen
                                      ? [
                                          const Color(0xFF8B7FD4),
                                          const Color(0xFF6C5DD3),
                                        ]
                                      : [
                                          const Color(0xFF6C5DD3),
                                          const Color(0xFF8B7FD4),
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: AnimatedRotation(
                                turns: isUploadMenuOpen ? 0.125 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: const Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  AnimatedCrossFade(
                    firstChild: const SizedBox(height: 0),
                    secondChild: Container(
                      margin: const EdgeInsets.only(
                        bottom: 8,
                        left: 10,
                        right: 10,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: isPickingFile ? null : _pickFile,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                38,
                                108,
                                93,
                                211,
                              ), // 0.15 -> 38
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color.fromARGB(77, 108, 93, 211),
                              ), // 0.3 -> 77
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isPickingFile)
                                  SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        const Color(0xFF9B8AA6),
                                      ),
                                    ),
                                  )
                                else
                                  const Icon(
                                    Icons.folder_open_rounded,
                                    color: Color(0xFF9B8AA6),
                                    size: 16,
                                  ),
                                const SizedBox(width: 6),
                                Text(
                                  isPickingFile ? '正在打开...' : '选择文件',
                                  style: const TextStyle(
                                    color: Color(0xFFB8A9C9),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    crossFadeState: isUploadMenuOpen
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                  ),

                  if (!isUploadMenuOpen)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: tags.map((tag) {
                            final isSelected = selectedTags.contains(tag);
                            return GestureDetector(
                              onTap: () => setState(() {
                                isSelected
                                    ? selectedTags.remove(tag)
                                    : selectedTags.add(tag);
                              }),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF6C5DD3)
                                      : const Color(0xFF252542),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF8B7FD4)
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF9B8AA6),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDreamButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SleepMonitorScreen()),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C5DD3), Color(0xFF8B7FD4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(27),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(102, 108, 93, 211), // 0.4 -> 102
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.nightlight_round, color: Colors.white, size: 24),
                SizedBox(width: 10),
                Text(
                  '一键入梦',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
