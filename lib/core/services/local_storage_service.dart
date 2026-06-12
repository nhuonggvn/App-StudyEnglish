import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  bool _isInitialized = false;

  // Box names
  static const String userBox = 'user_box';
  static const String progressBox = 'progress_box';
  static const String scoresBox = 'scores_box';
  static const String leaderboardBox = 'leaderboard_box';
  static const String vocabularyBox = 'vocabulary_box';

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await Hive.initFlutter();
      await Hive.openBox(userBox);
      await Hive.openBox(progressBox);
      await Hive.openBox(scoresBox);
      await Hive.openBox(leaderboardBox);
      await Hive.openBox(vocabularyBox);
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
    }
  }

  // User Profile
  Future<void> saveUserProfile({
    required String name,
    required int ageGroup,
    String? avatarEmoji,
  }) async {
    try {
      final box = Hive.box(userBox);
      await box.put('name', name);
      await box.put('age_group', ageGroup);
      await box.put('avatar_emoji', avatarEmoji ?? '');
      await box.put('created_at', DateTime.now().toIso8601String());
      await box.put('onboarding_complete', true);
    } catch (e) {
      // Storage error
    }
  }

  Map<String, dynamic> getUserProfile() {
    try {
      final box = Hive.box(userBox);
      return {
        'name': box.get('name', defaultValue: 'Ban nho'),
        'age_group': box.get('age_group', defaultValue: 0),
        'avatar_emoji': box.get('avatar_emoji', defaultValue: ''),
        'created_at': box.get('created_at', defaultValue: ''),
        'onboarding_complete':
            box.get('onboarding_complete', defaultValue: false),
      };
    } catch (e) {
      return {
        'name': 'Ban nho',
        'age_group': 0,
        'avatar_emoji': '',
        'created_at': '',
        'onboarding_complete': false,
      };
    }
  }

  bool isOnboardingComplete() {
    try {
      final box = Hive.box(userBox);
      return box.get('onboarding_complete', defaultValue: false);
    } catch (e) {
      return false;
    }
  }

  // Progress Tracking
  Future<void> saveProgress({
    required String topic,
    required String game,
    required int score,
    required int totalQuestions,
    required int correctAnswers,
  }) async {
    try {
      final box = Hive.box(progressBox);
      final String key =
          '${topic}_${game}_${DateTime.now().toIso8601String()}';
      await box.put(key, {
        'topic': topic,
        'game': game,
        'score': score,
        'total_questions': totalQuestions,
        'correct_answers': correctAnswers,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Progress save error
    }
  }

  List<Map<String, dynamic>> getProgressHistory() {
    try {
      final box = Hive.box(progressBox);
      List<Map<String, dynamic>> history = [];
      for (var key in box.keys) {
        final value = box.get(key);
        if (value is Map) {
          history.add(Map<String, dynamic>.from(value));
        }
      }
      history.sort((a, b) {
        final aTime = a['timestamp'] as String? ?? '';
        final bTime = b['timestamp'] as String? ?? '';
        return bTime.compareTo(aTime);
      });
      return history;
    } catch (e) {
      return [];
    }
  }

  // Weekly Report Data
  Map<String, dynamic> getWeeklyReport() {
    try {
      final history = getProgressHistory();
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));

      final weeklyData = history.where((item) {
        final timestamp = DateTime.tryParse(item['timestamp'] ?? '');
        return timestamp != null && timestamp.isAfter(weekAgo);
      }).toList();

      int totalScore = 0;
      int totalQuestions = 0;
      int totalCorrect = 0;
      int sessionsCount = weeklyData.length;
      Set<String> topicsLearned = {};

      for (var item in weeklyData) {
        totalScore += (item['score'] as int?) ?? 0;
        totalQuestions += (item['total_questions'] as int?) ?? 0;
        totalCorrect += (item['correct_answers'] as int?) ?? 0;
        topicsLearned.add(item['topic']?.toString() ?? '');
      }

      double accuracy =
          totalQuestions > 0 ? (totalCorrect / totalQuestions * 100) : 0;

      return {
        'total_score': totalScore,
        'total_questions': totalQuestions,
        'total_correct': totalCorrect,
        'sessions_count': sessionsCount,
        'topics_count': topicsLearned.length,
        'accuracy': accuracy.round(),
        'topics': topicsLearned.toList(),
      };
    } catch (e) {
      return {
        'total_score': 0,
        'total_questions': 0,
        'total_correct': 0,
        'sessions_count': 0,
        'topics_count': 0,
        'accuracy': 0,
        'topics': <String>[],
      };
    }
  }

  // Scores & Leaderboard
  Future<void> saveTotalScore(int score) async {
    try {
      final box = Hive.box(scoresBox);
      int currentScore = box.get('total_score', defaultValue: 0);
      await box.put('total_score', currentScore + score);
    } catch (e) {
      // Score save error
    }
  }

  int getTotalScore() {
    try {
      final box = Hive.box(scoresBox);
      return box.get('total_score', defaultValue: 0);
    } catch (e) {
      return 0;
    }
  }

  Future<void> saveStreakDays() async {
    try {
      final box = Hive.box(scoresBox);
      String lastPlayDate =
          box.get('last_play_date', defaultValue: '');
      String today = DateTime.now().toIso8601String().substring(0, 10);

      if (lastPlayDate == today) return;

      int streak = box.get('streak_days', defaultValue: 0);
      if (lastPlayDate.isNotEmpty) {
        final lastDate = DateTime.tryParse(lastPlayDate);
        final todayDate = DateTime.now();
        if (lastDate != null) {
          final difference = todayDate.difference(lastDate).inDays;
          if (difference == 1) {
            streak += 1;
          } else if (difference > 1) {
            streak = 1;
          }
        }
      } else {
        streak = 1;
      }

      await box.put('streak_days', streak);
      await box.put('last_play_date', today);
    } catch (e) {
      // Streak save error
    }
  }

  int getStreakDays() {
    try {
      final box = Hive.box(scoresBox);
      return box.get('streak_days', defaultValue: 0);
    } catch (e) {
      return 0;
    }
  }

  // Learned words tracking
  Future<void> markWordAsLearned(String word) async {
    try {
      final box = Hive.box(vocabularyBox);
      await box.put(word.toLowerCase(), {
        'word': word,
        'learned_at': DateTime.now().toIso8601String(),
        'review_count': 0,
      });
    } catch (e) {
      // Word save error
    }
  }

  int getLearnedWordsCount() {
    try {
      final box = Hive.box(vocabularyBox);
      return box.length;
    } catch (e) {
      return 0;
    }
  }

  // Settings
  Future<void> saveSetting(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      }
    } catch (e) {
      // Setting save error
    }
  }

  Future<dynamic> getSetting(String key, {dynamic defaultValue}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.get(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }
}
