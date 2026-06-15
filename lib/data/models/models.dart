class VocabularyWord {
  final String english;
  final String vietnamese;
  final String emoji;
  final String topic;
  final int ageGroup; // 0: 3-5, 1: 6-7, 2: 8-10

  const VocabularyWord({
    required this.english,
    required this.vietnamese,
    required this.emoji,
    required this.topic,
    required this.ageGroup,
  });

  Map<String, dynamic> toJson() {
    return {
      'english': english,
      'vietnamese': vietnamese,
      'emoji': emoji,
      'topic': topic,
      'ageGroup': ageGroup,
    };
  }

  factory VocabularyWord.fromJson(Map<String, dynamic> json) {
    return VocabularyWord(
      english: json['english'] as String? ?? '',
      vietnamese: json['vietnamese'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '⭐',
      topic: json['topic'] as String? ?? '',
      ageGroup: (json['ageGroup'] as num?)?.toInt() ?? 0,
    );
  }
}

class TopicData {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final int ageGroup;
  final List<VocabularyWord> words;
  final int difficulty; // 1-3

  const TopicData({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.ageGroup,
    required this.words,
    this.difficulty = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'description': description,
      'ageGroup': ageGroup,
      'words': words.map((w) => w.toJson()).toList(),
      'difficulty': difficulty,
    };
  }

  factory TopicData.fromJson(Map<String, dynamic> json) {
    var wordsList = json['words'] as List? ?? [];
    return TopicData(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '📚',
      description: json['description'] as String? ?? '',
      ageGroup: (json['ageGroup'] as num?)?.toInt() ?? 0,
      words: wordsList.map((w) => VocabularyWord.fromJson(Map<String, dynamic>.from(w as Map))).toList(),
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
    );
  }
}

class GameResult {
  final String gameType;
  final String topicId;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final Duration timeTaken;
  final DateTime playedAt;

  const GameResult({
    required this.gameType,
    required this.topicId,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeTaken,
    required this.playedAt,
  });

  double get accuracy =>
      totalQuestions > 0 ? correctAnswers / totalQuestions * 100 : 0;
  int get stars {
    if (accuracy >= 90) return 3;
    if (accuracy >= 70) return 2;
    if (accuracy >= 50) return 1;
    return 0;
  }
}

class LeaderboardEntry {
  final String name;
  final String avatarEmoji;
  final int totalScore;
  final int rank;
  final int streakDays;

  const LeaderboardEntry({
    required this.name,
    required this.avatarEmoji,
    required this.totalScore,
    required this.rank,
    required this.streakDays,
  });
}

class LearningPathItem {
  final String topicId;
  final String topicName;
  final String emoji;
  final int totalLessons;
  final int completedLessons;
  final bool isLocked;
  final int orderIndex;

  const LearningPathItem({
    required this.topicId,
    required this.topicName,
    required this.emoji,
    required this.totalLessons,
    required this.completedLessons,
    required this.isLocked,
    required this.orderIndex,
  });

  double get progress =>
      totalLessons > 0 ? completedLessons / totalLessons : 0;
  bool get isCompleted => completedLessons >= totalLessons;
}

class WeeklyReport {
  final int totalSessions;
  final int totalScore;
  final int wordsLearned;
  final double accuracyRate;
  final int minutesSpent;
  final List<String> topicsCompleted;
  final Map<String, int> dailyActivity; // day -> minutes
  final DateTime weekStartDate;

  const WeeklyReport({
    required this.totalSessions,
    required this.totalScore,
    required this.wordsLearned,
    required this.accuracyRate,
    required this.minutesSpent,
    required this.topicsCompleted,
    required this.dailyActivity,
    required this.weekStartDate,
  });
}
