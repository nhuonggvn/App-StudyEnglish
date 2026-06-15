import 'package:flutter/material.dart';
import '../core/services/local_storage_service.dart';
import '../core/services/tts_service.dart';
import '../data/models/models.dart';
import '../data/vocabulary_data.dart';

class AppProvider extends ChangeNotifier {
  final LocalStorageService _storageService = LocalStorageService();
  final TtsService _ttsService = TtsService();

  // User Profile
  String _userName = 'Ban nho';
  int _ageGroup = 0; // 0: 3-5, 1: 6-7, 2: 8-10
  String _avatarEmoji = '';
  bool _onboardingComplete = false;

  // Navigation
  int _currentTabIndex = 0;
  List<TopicData> _customTopics = [];

  // Scores
  int _totalScore = 0;
  int _streakDays = 0;
  int _learnedWordsCount = 0;

  // Getters
  String get userName => _userName;
  int get ageGroup => _ageGroup;
  String get avatarEmoji => _avatarEmoji;
  bool get onboardingComplete => _onboardingComplete;
  int get currentTabIndex => _currentTabIndex;
  int get totalScore => _totalScore;
  int get streakDays => _streakDays;
  int get learnedWordsCount => _learnedWordsCount;
  TtsService get ttsService => _ttsService;

  // Age group label
  String get ageGroupLabel {
    switch (_ageGroup) {
      case 0:
        return '3-5 tuổi';
      case 1:
        return '6-7 tuổi';
      case 2:
        return '8-10 tuổi';
      default:
        return '3-5 tuổi';
    }
  }

  // Topics for current age group
  List<TopicData> get currentTopics {
    final defaultTopics = VocabularyData.getTopicsForAgeGroup(_ageGroup);
    final customForAge = _customTopics.where((t) => t.ageGroup == _ageGroup).toList();
    return [...defaultTopics, ...customForAge];
  }

  // Learning path items
  List<LearningPathItem> get learningPath {
    final topics = currentTopics;
    return List.generate(topics.length, (index) {
      final progress = _storageService.getProgressHistory();
      final topicProgress = progress
          .where((p) => p['topic'] == topics[index].id)
          .toList();
      int completedLessons = topicProgress.length;
      return LearningPathItem(
        topicId: topics[index].id,
        topicName: topics[index].name,
        emoji: topics[index].emoji,
        totalLessons: 5, // 5 game types per topic
        completedLessons: completedLessons > 5 ? 5 : completedLessons,
        isLocked: index > 0 && completedLessons == 0 && _isTopicLocked(index),
        orderIndex: index,
      );
    });
  }

  bool _isTopicLocked(int index) {
    if (index == 0) return false;
    final topics = currentTopics;
    if (index >= topics.length) return true;
    final previousTopicProgress = _storageService
        .getProgressHistory()
        .where((p) => p['topic'] == topics[index - 1].id)
        .toList();
    return previousTopicProgress.isEmpty;
  }

  // Leaderboard (simulated with local data + fake data for demo)
  List<LeaderboardEntry> get leaderboard {
    List<LeaderboardEntry> entries = [
      LeaderboardEntry(
        name: _userName,
        avatarEmoji: _avatarEmoji,
        totalScore: _totalScore,
        rank: 0,
        streakDays: _streakDays,
      ),
      const LeaderboardEntry(name: 'Minh Anh', avatarEmoji: 'MA', totalScore: 2500, rank: 0, streakDays: 15),
      const LeaderboardEntry(name: 'Bao Long', avatarEmoji: 'BL', totalScore: 2200, rank: 0, streakDays: 12),
      const LeaderboardEntry(name: 'Thuy Linh', avatarEmoji: 'TL', totalScore: 1800, rank: 0, streakDays: 8),
      const LeaderboardEntry(name: 'Duc Huy', avatarEmoji: 'DH', totalScore: 1500, rank: 0, streakDays: 10),
      const LeaderboardEntry(name: 'Khanh Vy', avatarEmoji: 'KV', totalScore: 1200, rank: 0, streakDays: 6),
      const LeaderboardEntry(name: 'Gia Han', avatarEmoji: 'GH', totalScore: 900, rank: 0, streakDays: 5),
      const LeaderboardEntry(name: 'Tuan Kiet', avatarEmoji: 'TK', totalScore: 700, rank: 0, streakDays: 3),
    ];

    entries.sort((a, b) => b.totalScore.compareTo(a.totalScore));

    return List.generate(entries.length, (index) {
      return LeaderboardEntry(
        name: entries[index].name,
        avatarEmoji: entries[index].avatarEmoji,
        totalScore: entries[index].totalScore,
        rank: index + 1,
        streakDays: entries[index].streakDays,
      );
    });
  }

  // Weekly Report
  WeeklyReport get weeklyReport {
    final data = _storageService.getWeeklyReport();
    return WeeklyReport(
      totalSessions: data['sessions_count'] ?? 0,
      totalScore: data['total_score'] ?? 0,
      wordsLearned: _learnedWordsCount,
      accuracyRate: (data['accuracy'] ?? 0).toDouble(),
      minutesSpent: (data['sessions_count'] ?? 0) * 5,
      topicsCompleted: List<String>.from(data['topics'] ?? []),
      dailyActivity: {
        'T2': 15,
        'T3': 20,
        'T4': 10,
        'T5': 25,
        'T6': 18,
        'T7': 30,
        'CN': 22,
      },
      weekStartDate: DateTime.now().subtract(const Duration(days: 7)),
    );
  }

  // ============ ACTIONS ============

  Future<void> init() async {
    await _storageService.init();
    await _ttsService.init();
    _loadUserData();
  }

  void _loadUserData() {
    try {
      final profile = _storageService.getUserProfile();
      _userName = profile['name'] ?? 'Bạn nhỏ';
      _ageGroup = profile['age_group'] ?? 0;
      _avatarEmoji = profile['avatar_emoji'] ?? '';
      _onboardingComplete = profile['onboarding_complete'] ?? false;
      _totalScore = _storageService.getTotalScore();
      _streakDays = _storageService.getStreakDays();
      _learnedWordsCount = _storageService.getLearnedWordsCount();
      
      final localCustom = _storageService.getCustomTopics();
      _customTopics = localCustom.map((j) => TopicData.fromJson(j)).toList();
      
      notifyListeners();
    } catch (e) {
      // Load error - use defaults
    }
  }

  Future<void> completeOnboarding({
    required String name,
    required int ageGroup,
    required String avatarEmoji,
  }) async {
    _userName = name;
    _ageGroup = ageGroup;
    _avatarEmoji = avatarEmoji;
    _onboardingComplete = true;

    await _storageService.saveUserProfile(
      name: name,
      ageGroup: ageGroup,
      avatarEmoji: avatarEmoji,
    );

    notifyListeners();
  }

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  Future<void> saveGameResult({
    required String topic,
    required String game,
    required int score,
    required int totalQuestions,
    required int correctAnswers,
  }) async {
    await _storageService.saveProgress(
      topic: topic,
      game: game,
      score: score,
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
    );
    await _storageService.saveTotalScore(score);
    await _storageService.saveStreakDays();

    _totalScore = _storageService.getTotalScore();
    _streakDays = _storageService.getStreakDays();
    notifyListeners();
  }

  Future<void> markWordLearned(String word) async {
    await _storageService.markWordAsLearned(word);
    _learnedWordsCount = _storageService.getLearnedWordsCount();
    notifyListeners();
  }

  Future<void> speak(String text) async {
    await _ttsService.speak(text);
  }

  Future<void> speakSlow(String text) async {
    await _ttsService.speakSlow(text);
  }

  Future<void> addCustomTopic(TopicData topic) async {
    _customTopics.add(topic);
    await _storageService.saveCustomTopic(topic.toJson());
    notifyListeners();
  }
}
