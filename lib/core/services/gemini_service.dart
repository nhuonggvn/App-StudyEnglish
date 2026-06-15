import 'dart:convert';
import 'dart:io';
import '../../data/models/models.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  /// Gọi Gemini API để phân tích văn bản tiếng Anh và trích xuất từ vựng
  Future<List<VocabularyWord>> generateVocabularyFromText({
    required String text,
    required String apiKey,
    required String topicId,
    required int ageGroup,
  }) async {
    final client = HttpClient();
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey',
    );

    try {
      final request = await client.postUrl(url);
      request.headers.contentType = ContentType.json;

      // Xây dựng System Prompt ngầm cực kỳ chặt chẽ để AI không trả về rác markdown
      final systemInstruction =
          'You are an educational assistant for a children\'s English learning app called StudyEnglish. '
          'Your task is to analyze the provided English text and extract key vocabulary words (between 5 and 10 words) '
          'suitable for children. For each word, translate it to Vietnamese with correct Vietnamese diacritics (dấu tiếng Việt đầy đủ), '
          'assign a single, highly relevant animal or object emoji, and specify the topic ID. '
          'The response MUST be a valid JSON array matching this schema exactly: '
          '[\n'
          '  {\n'
          '    "english": "Word in English",\n'
          '    "vietnamese": "Nghĩa tiếng Việt có dấu",\n'
          '    "emoji": "🍎",\n'
          '    "topic": "$topicId"\n'
          '  }\n'
          ']\n'
          'Do NOT wrap the response in ```json ``` markdown code blocks. Do NOT include any explanations, introduction, or text outside the JSON array. Output raw JSON only.';

      final requestBody = jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text': '$systemInstruction\n\nAnalyze this text and output the JSON list of vocabulary words:\n$text'
              }
            ]
          }
        ],
        'generationConfig': {
          'responseMimeType': 'application/json',
        }
      });

      request.write(requestBody);
      final response = await request.close();

      if (response.statusCode != 200) {
        throw HttpException('Yêu cầu thất bại với mã lỗi: ${response.statusCode}');
      }

      final responseBody = await response.transform(utf8.decoder).join();
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

      // Trích xuất text phản hồi từ cấu trúc Gemini API response
      final String candidatesText = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
      
      // Parse chuỗi JSON văn bản thô nhận được thành danh sách VocabularyWord
      final List<dynamic> parsedList = jsonDecode(_cleanJsonString(candidatesText));
      
      return parsedList.map((item) {
        final map = Map<String, dynamic>.from(item);
        // Bổ sung các trường cần thiết của VocabularyWord
        map['topic'] = topicId;
        map['ageGroup'] = ageGroup;
        return VocabularyWord.fromJson(map);
      }).toList();

    } catch (e) {
      rethrow;
    } finally {
      client.close();
    }
  }

  /// Hàm hỗ trợ làm sạch chuỗi JSON phòng hờ AI vẫn trả về khối ```json ```
  String _cleanJsonString(String rawText) {
    var cleaned = rawText.trim();
    if (cleaned.startsWith('```')) {
      // Loại bỏ khối ```json ở đầu
      cleaned = cleaned.replaceFirst(RegExp(r'^```(json)?'), '');
      // Loại bỏ khối ``` ở cuối
      cleaned = cleaned.replaceFirst(RegExp(r'```$'), '');
    }
    return cleaned.trim();
  }
}
