import 'dart:convert';
import 'dart:developer';
import 'package:dart_openai/dart_openai.dart';
import 'package:collection/collection.dart';

class PlantAIService {
  PlantAIService init() {
    try {
      OpenAI.apiKey = const String.fromEnvironment('OPENAI_API_KEY');
      OpenAI.showLogs = true;
      OpenAI.showResponsesLogs = true;
      return this;
    } catch (e) {
      log('Error initializing Plant AI service: ${e.toString()}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> identifyPlant(String base64Image) async {
    final systemMessage = '''
Analyze this plant image and provide detailed information:

Please provide:
1. Plant identification (species and common names)
2. Care requirements (water, light, soil, temperature)
3. Growth characteristics
4. Common issues and solutions
5. Special care instructions

Response must be a JSON object with:
- identification (object): Plant species and variety details
- care_guide (object): Detailed care instructions
- growth_info (object): Growth patterns and expectations
- common_issues (array): Potential problems and solutions
- special_notes (array): Additional important information
''';

    final messages = [
      OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(systemMessage),
          OpenAIChatCompletionChoiceMessageContentItemModel.imageUrl(
            base64Image,
          ),
        ],
        role: OpenAIChatMessageRole.user,
      ),
    ];

    try {
      final chat = await OpenAI.instance.chat.create(
        model: "gpt-4-vision-preview",
        messages: messages,
        responseFormat: {"type": "json_object"},
        seed: 42,
        temperature: 0.7,
        maxTokens: 1000,
      );

      if (chat.choices.isEmpty) {
        throw Exception('No response received from AI');
      }

      final content = chat.choices.first.message.content;
      if (content == null || content.isEmpty) {
        throw Exception('Empty response from AI');
      }

      final textItem = content.firstWhereOrNull(
            (item) => item.type == 'text' && item.text != null,
      );

      if (textItem?.text == null) {
        throw Exception('No valid text content in AI response');
      }

      return json.decode(textItem!.text!) as Map<String, dynamic>;
    } catch (e) {
      log('Error identifying plant: ${e.toString()}');
      return {
        'identification': {'error': 'Unable to identify plant'},
        'care_guide': {'error': 'Care guide unavailable'},
        'growth_info': {'error': 'Growth information unavailable'},
        'common_issues': ['Service temporarily unavailable'],
        'special_notes': ['Please try again later'],
      };
    }
  }

  Future<Map<String, dynamic>> getPlantCareSchedule(
      String plantName,
      Map<String, dynamic> careRequirements,
      ) async {
    final systemMessage = '''
Create a detailed care schedule for: $plantName

Care Requirements:
${jsonEncode(careRequirements)}

Please provide:
1. Watering schedule
2. Fertilizing timeline
3. Pruning and maintenance tasks
4. Seasonal care adjustments
5. Growth monitoring guidelines

Response must be a JSON object with:
- watering (object): Detailed watering schedule
- fertilizing (object): Fertilization timeline
- maintenance (array): Regular care tasks
- seasonal_care (object): Season-specific adjustments
- monitoring (object): Growth tracking guidelines
''';

    final messages = [
      OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(systemMessage),
        ],
        role: OpenAIChatMessageRole.user,
      ),
    ];

    try {
      final chat = await OpenAI.instance.chat.create(
        model: "gpt-4",
        messages: messages,
        responseFormat: {"type": "json_object"},
        seed: 42,
        temperature: 0.7,
        maxTokens: 1000,
      );

      if (chat.choices.isEmpty) {
        throw Exception('No response received from AI');
      }

      final content = chat.choices.first.message.content;
      if (content == null || content.isEmpty) {
        throw Exception('Empty response from AI');
      }

      final textItem = content.firstWhereOrNull(
            (item) => item.type == 'text' && item.text != null,
      );

      if (textItem?.text == null) {
        throw Exception('No valid text content in AI response');
      }

      return json.decode(textItem!.text!) as Map<String, dynamic>;
    } catch (e) {
      log('Error generating care schedule: ${e.toString()}');
      return {
        'watering': {'error': 'Unable to generate watering schedule'},
        'fertilizing': {'error': 'Fertilizing schedule unavailable'},
        'maintenance': ['Service temporarily unavailable'],
        'seasonal_care': {'error': 'Seasonal care guide unavailable'},
        'monitoring': {'error': 'Monitoring guidelines unavailable'},
      };
    }
  }

  Future<Map<String, dynamic>> getLightingRecommendations(
      String plantName,
      Map<String, dynamic> lightRequirements,
      ) async {
    final systemMessage = '''
Provide lighting recommendations for: $plantName

Light Requirements:
${jsonEncode(lightRequirements)}

Please provide:
1. Optimal light conditions
2. Best window orientations
3. Distance from light sources
4. Seasonal light adjustments
5. Signs of improper lighting

Response must be a JSON object with:
- optimal_conditions (object): Ideal lighting details
- placement (array): Specific placement recommendations
- distance_guide (object): Distance recommendations
- seasonal_adjustments (object): Seasonal changes
- warning_signs (array): Signs of lighting issues
''';

    final messages = [
      OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(systemMessage),
        ],
        role: OpenAIChatMessageRole.user,
      ),
    ];

    try {
      final chat = await OpenAI.instance.chat.create(
        model: "gpt-4",
        messages: messages,
        responseFormat: {"type": "json_object"},
        seed: 42,
        temperature: 0.7,
        maxTokens: 1000,
      );

      if (chat.choices.isEmpty) {
        throw Exception('No response received from AI');
      }

      final content = chat.choices.first.message.content;
      if (content == null || content.isEmpty) {
        throw Exception('Empty response from AI');
      }

      final textItem = content.firstWhereOrNull(
            (item) => item.type == 'text' && item.text != null,
      );

      if (textItem?.text == null) {
        throw Exception('No valid text content in AI response');
      }

      return json.decode(textItem!.text!) as Map<String, dynamic>;
    } catch (e) {
      log('Error generating lighting recommendations: ${e.toString()}');
      return {
        'optimal_conditions': {'error': 'Unable to determine optimal conditions'},
        'placement': ['Service temporarily unavailable'],
        'distance_guide': {'error': 'Distance guide unavailable'},
        'seasonal_adjustments': {'error': 'Seasonal adjustments unavailable'},
        'warning_signs': ['Please try again later'],
      };
    }
  }
}