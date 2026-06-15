import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/gemini_service.dart';
import '../../core/services/local_storage_service.dart';
import '../../data/models/models.dart';
import '../../providers/app_provider.dart';

class AiCreationScreen extends StatefulWidget {
  const AiCreationScreen({super.key});

  @override
  State<AiCreationScreen> createState() => _AiCreationScreenState();
}

class _AiCreationScreenState extends State<AiCreationScreen> {
  final _apiKeyController = TextEditingController();
  final _topicNameController = TextEditingController();
  final _topicDescController = TextEditingController();
  final _topicEmojiController = TextEditingController();
  final _textContentController = TextEditingController();

  final LocalStorageService _storageService = LocalStorageService();
  final GeminiService _geminiService = GeminiService();

  int _selectedAgeGroup = 0; // 0: 3-5, 1: 6-7, 2: 8-10
  bool _isLoading = false;
  List<VocabularyWord> _previewWords = [];
  bool _hasAnalyzed = false;

  @override
  void initState() {
    super.initState();
    _loadSavedApiKey();
    _topicEmojiController.text = '📚'; // Mặc định chọn emoji sách
  }

  Future<void> _loadSavedApiKey() async {
    final savedKey = await _storageService.getSetting('gemini_api_key', defaultValue: '');
    if (mounted) {
      setState(() {
        _apiKeyController.text = savedKey;
      });
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _topicNameController.dispose();
    _topicDescController.dispose();
    _topicEmojiController.dispose();
    _textContentController.dispose();
    super.dispose();
  }

  Future<void> _analyzeText() async {
    final apiKey = _apiKeyController.text.trim();
    final topicName = _topicNameController.text.trim();
    final textContent = _textContentController.text.trim();

    if (apiKey.isEmpty) {
      _showSnackBar('Vui lòng nhập API Key Gemini để sử dụng dịch vụ.');
      return;
    }
    if (topicName.isEmpty) {
      _showSnackBar('Vui lòng nhập tên chủ đề.');
      return;
    }
    if (textContent.isEmpty) {
      _showSnackBar('Vui lòng dán văn bản tiếng Anh cần phân tích.');
      return;
    }

    setState(() {
      _isLoading = true;
      _previewWords.clear();
      _hasAnalyzed = false;
    });

    try {
      // Lưu lại API Key để lần sau giáo viên không phải nhập lại
      await _storageService.saveSetting('gemini_api_key', apiKey);

      // Tạo Slug ID từ tên chủ đề
      final topicId = topicName.toLowerCase().replaceAll(RegExp(r'\s+'), '_');

      final words = await _geminiService.generateVocabularyFromText(
        text: textContent,
        apiKey: apiKey,
        topicId: topicId,
        ageGroup: _selectedAgeGroup,
      );

      setState(() {
        _previewWords = words;
        _hasAnalyzed = true;
        _isLoading = false;
      });

      _showSnackBar('Đã trích xuất thành công ${words.length} từ vựng!');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Lỗi phân tích: Có thể do API Key sai hoặc mất kết nối.');
    }
  }

  void _saveTopic() {
    final topicName = _topicNameController.text.trim();
    final topicDesc = _topicDescController.text.trim();
    final topicEmoji = _topicEmojiController.text.trim();

    if (_previewWords.isEmpty) {
      _showSnackBar('Không có từ vựng nào để lưu.');
      return;
    }

    final topicId = topicName.toLowerCase().replaceAll(RegExp(r'\s+'), '_');

    final newTopic = TopicData(
      id: topicId,
      name: topicName,
      emoji: topicEmoji.isEmpty ? '📚' : topicEmoji,
      description: topicDesc.isEmpty ? 'Chủ đề tự chọn' : topicDesc,
      ageGroup: _selectedAgeGroup,
      words: _previewWords,
      difficulty: 2,
    );

    context.read<AppProvider>().addCustomTopic(newTopic);
    _showSnackBar('Đã lưu bài học "$topicName" thành công!');
    Navigator.of(context).pop();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Soạn bài học bằng AI',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. API Key Card
              _buildBentoSection(
                title: 'Cài đặt Gemini API Key',
                child: TextField(
                  controller: _apiKeyController,
                  obscureText: true,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Nhập API Key Gemini của bạn...',
                    hintStyle: const TextStyle(fontSize: 13, color: AppColors.outline),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLowest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2. Info Card
              _buildBentoSection(
                title: 'Thông tin chủ đề mới',
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _topicNameController,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: 'Ví dụ: Động vật đại dương',
                              labelText: 'Tên chủ đề',
                              filled: true,
                              fillColor: AppColors.surfaceContainerLowest,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _topicEmojiController,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              labelText: 'Emoji',
                              filled: true,
                              fillColor: AppColors.surfaceContainerLowest,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _topicDescController,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'Ví dụ: Khám phá các loài sinh vật dưới biển sâu.',
                        labelText: 'Mô tả ngắn',
                        filled: true,
                        fillColor: AppColors.surfaceContainerLowest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. Age Selector
              _buildBentoSection(
                title: 'Nhóm tuổi áp dụng',
                child: Row(
                  children: List.generate(3, (index) {
                    final labels = ['3-5 tuổi', '6-7 tuổi', '8-10 tuổi'];
                    final isSelected = _selectedAgeGroup == index;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: index < 2 ? 8.0 : 0.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedAgeGroup = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                labels[index],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected ? Colors.white : AppColors.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              // 4. Copy-Paste Input Area
              _buildBentoSection(
                title: 'Nội dung bài học / Văn bản tiếng Anh',
                child: Column(
                  children: [
                    TextField(
                      controller: _textContentController,
                      maxLines: 8,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: 'Hãy dán đoạn văn bản tiếng Anh, truyện kể, hoặc danh sách từ vựng/câu hỏi thô của bạn vào đây...',
                        hintStyle: const TextStyle(fontSize: 13, color: AppColors.outline),
                        filled: true,
                        fillColor: AppColors.surfaceContainerLowest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _analyzeText,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                        ),
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.psychology_rounded, size: 20),
                        label: Text(
                          _isLoading ? 'Đang trích xuất từ vựng...' : 'Phân tích & Trích xuất từ bằng AI',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 5. AI Preview Section
              if (_hasAnalyzed) ...[
                const SizedBox(height: 24),
                _buildBentoSection(
                  title: 'Xem trước danh sách từ vựng AI tạo ra',
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Giáo viên có thể kiểm tra nghĩa và xóa các từ không đạt yêu cầu.',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.outline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _previewWords.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final word = _previewWords[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.outlineVariant, width: 1),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  word.emoji,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        word.english,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        word.vietnamese,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.outline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.redAccent,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _previewWords.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: _saveTopic,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(27),
                            ),
                          ),
                          icon: const Icon(Icons.save_rounded, size: 20),
                          label: const Text(
                            'Xác nhận & Lưu chủ đề học tập',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBentoSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
