import 'package:ai_20/core/bloc/plant_bloc.dart';
import 'package:ai_20/core/constants/theme/app_theme.dart';
import 'package:ai_20/core/models/plant_data_models.dart';
import 'package:ai_20/core/services/ai_service.dart';
import 'package:ai_20/features/main/pages/plant_catalog_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(PlantAdapter());
  Hive.registerAdapter(GrowthEntryAdapter());
  Hive.registerAdapter(WateringScheduleAdapter());

  final plantBox = await Hive.openBox<Plant>('plants');
  final aiService = PlantAIService().init();

  runApp(MyApp(
    plantBox: plantBox,
    aiService: aiService,
  ));
}

class MyApp extends StatelessWidget {
  final Box<Plant> plantBox;
  final PlantAIService aiService;

  const MyApp({
    super.key,
    required this.plantBox,
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
      ],
      child: CupertinoApp(
        title: 'Мой зелёный уголок',
        theme: const CupertinoThemeData(
          primaryColor: AppTheme.primaryGreen,
          scaffoldBackgroundColor: AppTheme.backgroundLight,
          textTheme: CupertinoTextThemeData(
            primaryColor: AppTheme.textDark,
          ),
        ),
        home: const MainScreen(),
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
            icon: Icon(CupertinoIcons.house_fill),
            label: 'Каталог',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.camera_fill),
            label: 'Распознать',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_bar_fill),
            label: 'Журнал',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Настройки',
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
                return const PlantCatalogScreen(); //PlantRecognitionScreen
              case 2:
                return const PlantCatalogScreen(); //GrowthJournalScreen
              case 3:
                return const PlantCatalogScreen(); //SettingsScreen
              default:
                return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}