import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:ai_20/core/models/plant_data_models.dart';

var logger = Logger();

const String model = "gpt-4o";
const String apiUrl = 'https://api.openai.com/v1/chat/completions';
String openAI = "";

class PlantAIService {
  PlantAIService init() {
    return this;
  }

  Future<Map<String, dynamic>> identifyPlant(String base64Image) async {
    final formattedBase64 = 'data:image/jpeg;base64,$base64Image';

    try {
      final requestBody = json.encode({
        "model": model,
        "messages": [
          {
            "role": "user",
            "content": [
              {
                "type": "text",
                "text":
                    """Analyze this plant image and provide details in the following exact JSON format:
                  {
                    "identification": {
                      "species": "Scientific name",
                      "commonNames": ["Common name 1", "Common name 2"],
                      "confidence": 0.95
                    },
                    "careGuide": {
                      "water": "Detailed watering instructions",
                      "light": "Light requirements",
                      "soil": "Soil requirements",
                      "temperature": "Temperature range and requirements"
                    },
                    "growthInfo": {
                      "growthRate": "Description of growth speed",
                      "height": "Expected height range",
                      "spread": "Expected spread range"
                    },
                    "commonIssues": [
                      {
                        "issue": "Problem name",
                        "solution": "How to solve it"
                      }
                    ],
                    "specialNotes": [
                      "Important care note 1",
                      "Important care note 2"
                    ]
                      "lightingRecommendations": {
                        "optimal_conditions": {
                          "light_type": "What type of light is best (e.g., direct, indirect)",
                          "light_intensity": "What level of light intensity is recommended (e.g., low, medium, high)",
                          "duration": "How many hours of light per day"
                        },
                        "placement": [
                          "What placement/positioning of the plant is ideal (e.g., near a south-facing window)"
                        ],
                        "distance_guide": {
                          "minimum_distance": "Minimum distance from light source",
                          "maximum_distance": "Maximum distance from light source"
                        },
                        "seasonal_adjustments": {
                          "spring": "Spring adjustments",
                          "summer": "Summer adjustments",
                          "fall": "Fall adjustments",
                          "winter": "Winter adjustments"
                        },
                        "warning_signs": [
                          "Signs the plant is not receiving enough light or receiving too much"
                        ]
                      }
                  }"""
              },
              {
                "type": "image_url",
                "image_url": {
                  "url": formattedBase64,
                  "detail": "high",
                },
              },
            ]
          }
        ],
        "max_tokens": 1000,
        "temperature": 0.7,
        "response_format": {"type": "json_object"},
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAI',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        logger.d('Full response: $responseData');

        final contentString = responseData['choices'][0]['message']['content'];
        logger.d('Content string: $contentString');

        try {
          final Map<String, dynamic> parsedContent = json.decode(contentString);
          logger.d('Parsed content: $parsedContent');

          _validateIdentificationResponse(parsedContent);

          return parsedContent;
        } catch (e) {
          logger.e('Error parsing content: $e');
          throw FormatException('Invalid JSON format in response content');
        }
      } else {
        logger.e('API Error: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Failed to communicate with OpenAI: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error communicating with OpenAI: $e');
      return _getDefaultResponse();
    }
  }

  Future<Map<String, dynamic>> getPlantCareSchedule(
      String plantName, PlantCareGuide careGuide) async {
    try {
      final requestBody = json.encode({
        "model": model,
        "messages": [
          {
            "role": "user",
            "content": """Create a detailed care schedule for: $plantName

        Current Care Guide:
        ${jsonEncode(careGuide)}

        Provide a detailed schedule in the following exact JSON format:
        {
          "wateringSchedule": {
            "frequencyDays": 7,
            "season": "all",
            "adjustments": {
              "summer": { "frequencyDays": 5, "notes": "Increase watering in hot weather" },
              "winter": { "frequencyDays": 10, "notes": "Reduce watering in dormancy" }
            }
          },
          "fertilizingSchedule": {
            "frequency": "How often to fertilize",
            "fertilizer": {
              "type": "Recommended fertilizer type",
              "npkRatio": "Recommended NPK ratio",
              "application": "How to apply"
            },
            "seasonalAdjustments": {
              "spring": "Spring fertilizing instructions",
              "summer": "Summer fertilizing instructions",
              "fall": "Fall fertilizing instructions",
              "winter": "Winter fertilizing instructions"
            }
          },
          "maintenanceTasks": [
            {
              "task": "Task name",
              "frequency": "How often",
              "instructions": "Detailed instructions",
              "season": "When to perform this task",
              "importance": "high/medium/low"
            }
          ],
          "growthMonitoring": {
            "checkFrequency": "How often to check growth",
            "measurementPoints": [
              "What to measure/check"
            ],
            "expectedGrowth": {
              "spring": "Expected spring growth rate",
              "summer": "Expected summer growth rate",
              "fall": "Expected fall growth rate",
              "winter": "Expected winter growth rate"
            }
          }

        }"""
          }
        ],
        "max_tokens": 1000,
        "temperature": 0.7,
        "response_format": {"type": "json_object"},
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAI',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        logger.d('Full response: $responseData');

        final contentString = responseData['choices'][0]['message']['content'];
        logger.d('Content string: $contentString');

        try {
          final Map<String, dynamic> parsedContent = json.decode(contentString);
          logger.d('Parsed content: $parsedContent');

          _validateCareScheduleResponse(parsedContent);

          return parsedContent;
        } catch (e) {
          logger.e('Error parsing care schedule content: $e');
          throw FormatException(
              'Invalid JSON format in care schedule response');
        }
      } else {
        logger.e('API Error: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Failed to communicate with OpenAI: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error generating care schedule: $e');
      return _getDefaultCareSchedule();
    }
  }

  void _validateCareScheduleResponse(Map<String, dynamic> response) {
    if (!response.containsKey('wateringSchedule') ||
        !response.containsKey('fertilizingSchedule') ||
        !response.containsKey('maintenanceTasks') ||
        !response.containsKey('growthMonitoring')) {
      throw FormatException(
          'Missing required top-level keys in care schedule response');
    }

    final wateringSchedule = response['wateringSchedule'];
    if (!wateringSchedule.containsKey('frequencyDays') ||
        !wateringSchedule.containsKey('season') ||
        !wateringSchedule.containsKey('adjustments')) {
      throw FormatException('Invalid wateringSchedule object structure');
    }

    final fertilizingSchedule = response['fertilizingSchedule'];
    if (!fertilizingSchedule.containsKey('frequency') ||
        !fertilizingSchedule.containsKey('fertilizer') ||
        !fertilizingSchedule.containsKey('seasonalAdjustments')) {
      throw FormatException('Invalid fertilizingSchedule object structure');
    }

    if (!(response['maintenanceTasks'] is List)) {
      throw FormatException('maintenanceTasks must be an array');
    }

    final growthMonitoring = response['growthMonitoring'];
    if (!growthMonitoring.containsKey('checkFrequency') ||
        !growthMonitoring.containsKey('measurementPoints') ||
        !growthMonitoring.containsKey('expectedGrowth')) {
      throw FormatException('Invalid growthMonitoring object structure');
    }
  }

  Map<String, dynamic> _getDefaultCareSchedule() {
    return {
      "wateringSchedule": {
        "frequencyDays": 7,
        "season": "all",
        "adjustments": {
          "summer": {"frequencyDays": 7, "notes": "Information unavailable"},
          "winter": {"frequencyDays": 7, "notes": "Information unavailable"}
        }
      },
      "fertilizingSchedule": {
        "frequency": "Information unavailable",
        "fertilizer": {
          "type": "Information unavailable",
          "npkRatio": "Information unavailable",
          "application": "Information unavailable"
        },
        "seasonalAdjustments": {
          "spring": "Information unavailable",
          "summer": "Information unavailable",
          "fall": "Information unavailable",
          "winter": "Information unavailable"
        }
      },
      "maintenanceTasks": [
        {
          "task": "Service Unavailable",
          "frequency": "Information unavailable",
          "instructions": "Please try again later",
          "season": "all",
          "importance": "medium"
        }
      ],
      "growthMonitoring": {
        "checkFrequency": "Information unavailable",
        "measurementPoints": ["Information unavailable"],
        "expectedGrowth": {
          "spring": "Information unavailable",
          "summer": "Information unavailable",
          "fall": "Information unavailable",
          "winter": "Information unavailable"
        }
      }
    };
  }

  void _validateIdentificationResponse(Map<String, dynamic> response) {
    if (!response.containsKey('identification') ||
        !response.containsKey('careGuide') ||
        !response.containsKey('growthInfo') ||
        !response.containsKey('commonIssues') ||
        !response.containsKey('specialNotes')) {
      throw FormatException('Missing required top-level keys in response');
    }

    final identification = response['identification'];
    if (!identification.containsKey('species') ||
        !identification.containsKey('commonNames') ||
        !identification.containsKey('confidence')) {
      throw FormatException('Invalid identification object structure');
    }

    final careGuide = response['careGuide'];
    if (!careGuide.containsKey('water') ||
        !careGuide.containsKey('light') ||
        !careGuide.containsKey('soil') ||
        !careGuide.containsKey('temperature')) {
      throw FormatException('Invalid careGuide object structure');
    }

    final growthInfo = response['growthInfo'];
    if (!growthInfo.containsKey('growthRate') ||
        !growthInfo.containsKey('height') ||
        !growthInfo.containsKey('spread')) {
      throw FormatException('Invalid growthInfo object structure');
    }
  }

  Map<String, dynamic> _getDefaultResponse() {
    return {
      "identification": {
        "species": "Unknown Species",
        "commonNames": ["Unknown Plant"],
        "confidence": 0.0
      },
      "careGuide": {
        "water": "Information unavailable",
        "light": "Information unavailable",
        "soil": "Information unavailable",
        "temperature": "Information unavailable"
      },
      "growthInfo": {
        "growthRate": "Information unavailable",
        "height": "Information unavailable",
        "spread": "Information unavailable"
      },
      "commonIssues": [
        {"issue": "Service Unavailable", "solution": "Please try again later"}
      ],
      "specialNotes": [
        "Plant identification service is temporarily unavailable"
      ]
    };
  }

  Future<Map<String, dynamic>> getLightingRecommendations(
    String plantName,
    LightingRecommendations lightRequirements,
  ) async {
    try {
      final requestBody = json.encode({
        "model": model,
        "messages": [
          {
            "role": "user",
            "content": """Provide lighting recommendations for: $plantName

Light Requirements:
${jsonEncode(lightRequirements)}

Please provide the following in the exact JSON format:
{
  "optimal_conditions": {
    "light_type": "What type of light is best (e.g., direct, indirect)",
    "light_intensity": "What level of light intensity is recommended (e.g., low, medium, high)",
    "duration": "How many hours of light per day"
  },
  "placement": [
    "What placement/positioning of the plant is ideal (e.g., near a south-facing window)"
  ],
  "distance_guide": {
    "minimum_distance": "Minimum distance from light source",
    "maximum_distance": "Maximum distance from light source"
  },
  "seasonal_adjustments": {
    "spring": "Spring adjustments",
    "summer": "Summer adjustments",
    "fall": "Fall adjustments",
    "winter": "Winter adjustments"
  },
  "warning_signs": [
    "Signs the plant is not receiving enough light or receiving too much"
  ]
}"""
          }
        ],
        "max_tokens": 1000,
        "temperature": 0.7,
        "response_format": {"type": "json_object"},
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAI',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        logger.d('Full response: $responseData');

        final contentString = responseData['choices'][0]['message']['content'];
        logger.d('Content string: $contentString');

        try {
          final Map<String, dynamic> parsedContent = json.decode(contentString);
          logger.d('Parsed content: $parsedContent');

          _validateLightingRecommendationsResponse(parsedContent);

          return parsedContent;
        } catch (e) {
          logger.e('Error parsing lighting recommendations content: $e');
          throw FormatException(
              'Invalid JSON format in lighting recommendations response');
        }
      } else {
        logger.e('API Error: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Failed to communicate with OpenAI: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error generating lighting recommendations: $e');
      return {
        'optimal_conditions': {
          'light_type': 'Information unavailable',
          'light_intensity': 'Information unavailable',
          'duration': 'Information unavailable',
        },
        'placement': ['Service temporarily unavailable'],
        'distance_guide': {
          'minimum_distance': 'Information unavailable',
          'maximum_distance': 'Information unavailable',
        },
        'seasonal_adjustments': {
          'spring': 'Information unavailable',
          'summer': 'Information unavailable',
          'fall': 'Information unavailable',
          'winter': 'Information unavailable',
        },
        'warning_signs': ['Please try again later'],
      };
    }
  }

  void _validateLightingRecommendationsResponse(Map<String, dynamic> response) {
    if (!response.containsKey('optimal_conditions') ||
        !response.containsKey('placement') ||
        !response.containsKey('distance_guide') ||
        !response.containsKey('seasonal_adjustments') ||
        !response.containsKey('warning_signs')) {
      throw FormatException(
          'Missing required top-level keys in lighting recommendations response');
    }

    final optimalConditions = response['optimal_conditions'];
    if (!optimalConditions.containsKey('light_type') ||
        !optimalConditions.containsKey('light_intensity') ||
        !optimalConditions.containsKey('duration')) {
      throw FormatException('Invalid optimal_conditions object structure');
    }

    if (!(response['placement'] is List)) {
      throw FormatException('placement must be an array');
    }

    final distanceGuide = response['distance_guide'];
    if (!distanceGuide.containsKey('minimum_distance') ||
        !distanceGuide.containsKey('maximum_distance')) {
      throw FormatException('Invalid distance_guide object structure');
    }

    final seasonalAdjustments = response['seasonal_adjustments'];
    if (!seasonalAdjustments.containsKey('spring') ||
        !seasonalAdjustments.containsKey('summer') ||
        !seasonalAdjustments.containsKey('fall') ||
        !seasonalAdjustments.containsKey('winter')) {
      throw FormatException('Invalid seasonal_adjustments object structure');
    }

    if (!(response['warning_signs'] is List)) {
      throw FormatException('warning_signs must be an array');
    }
  }
}
