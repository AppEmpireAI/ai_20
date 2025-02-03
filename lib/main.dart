import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_20/core/bloc/plant_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ai_20/core/services/ai_service.dart';
import 'package:ai_20/core/bloc/onboarding_bloc.dart';
import 'package:ai_20/core/models/onboarding_state.dart';
import 'package:ai_20/core/models/plant_data_models.dart';
import 'package:ai_20/core/constants/theme/app_theme.dart';
import 'package:ai_20/features/main/pages/settings_screen.dart';
import 'package:ai_20/features/main/pages/onboarding_screen.dart';
import 'package:ai_20/features/main/pages/plant_catalog_screen.dart';
// import 'package:ai_20/features/main/pages/growth_journal_screen.dart';
import 'package:ai_20/features/main/pages/plant_recognition_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(PlantAdapter());
  Hive.registerAdapter(GrowthEntryAdapter());
  Hive.registerAdapter(WateringScheduleAdapter());
  Hive.registerAdapter(PlantIdentificationAdapter());
  Hive.registerAdapter(PlantCareGuideAdapter());
  Hive.registerAdapter(PlantGrowthInfoAdapter());
  Hive.registerAdapter(PlantIssueAdapter());
  Hive.registerAdapter(LightingRecommendationsAdapter());
  Hive.registerAdapter(OptimalConditionsAdapter());
  Hive.registerAdapter(DistanceGuideAdapter());
  Hive.registerAdapter(SeasonalAdjustmentsAdapter());
  Hive.registerAdapter(OnboardingStateAdapter());

  final plantBox = await Hive.openBox<Plant>('plants');
  final onboardingBox = await Hive.openBox<OnboardingState>('onboarding');

  final aiService = PlantAIService().init();

  runApp(MyApp(
    plantBox: plantBox,
    onboardingBox: onboardingBox,
    aiService: aiService,
  ));
}

class MyApp extends StatelessWidget {
  final Box<Plant> plantBox;
  final Box<OnboardingState> onboardingBox;
  final PlantAIService aiService;

  const MyApp({
    super.key,
    required this.plantBox,
    required this.onboardingBox,
    required this.aiService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PlantBloc(
            plantBox: plantBox,
            aiService: aiService,
          )..add(LoadPlants()),
        ),
        BlocProvider(
          create: (context) => OnboardingBloc(
            onboardingBox: onboardingBox,
          ),
        ),
      ],
      child: CupertinoApp(
        title: 'My green corner',
        debugShowCheckedModeBanner: false,
        theme: const CupertinoThemeData(
          primaryColor: AppTheme.primaryGreen,
          scaffoldBackgroundColor: AppTheme.backgroundLight,
          textTheme: CupertinoTextThemeData(
            primaryColor: AppTheme.textDark,
          ),
        ),
        home: BlocBuilder<OnboardingBloc, OnboardingStatus>(
          builder: (context, state) {
            if (state is OnboardingInitial) {
              context.read<OnboardingBloc>().add(CheckOnboardingStatus());
              return const CupertinoActivityIndicator();
            }

            if (state is OnboardingRequired) {
              return const OnboardingScreen();
            }
            return const MainScreen();
          },
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: AppTheme.backgroundLight,
        activeColor: AppTheme.primaryGreen,
        inactiveColor: AppTheme.textLight,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.house_fill,
              size: 20,
            ),
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.camera_fill,
              size: 20,
            ),
            label: 'Recognize',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     CupertinoIcons.chart_bar_fill,
          //     size: 20,
          //   ),
          //   label: 'Journal',
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.settings,
              size: 20,
            ),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (context) {
            switch (index) {
              case 0:
                return const PlantCatalogScreen();
              case 1:
                return const PlantRecognitionScreen();
              case 2:
                return const SettingsScreen();
              // return const GrowthJournalScreen();
              // case 3:
              //   return const SettingsScreen();
              default:
                return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}


// dart run build_runner watch     
// flutter build apk --split-per-abi