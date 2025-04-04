import 'package:flutter/material.dart';
import 'my_page_screen.dart';
import 'bmi_calculator_screen.dart';
import 'fruit_analysis_screen.dart';
import 'mask_pack_recipe_screen.dart';
import 'daily_intake_screen.dart';

class MainScreen extends StatefulWidget {
  final String? city; // nullable
  final String gender;
  final String selectedYear;
  final String selectedMonth;
  final String selectedDay;
  final String? district; // nullable
  final String? subdistrict; // nullable
  final bool? hasDiabetes;

  MainScreen({
    this.city, // 선택적 필드
    this.district, // 선택적 필드
    this.subdistrict, // 선택적 필드
    required this.gender, // 필수 필드
    required this.selectedYear, // 필수 필드
    required this.selectedMonth, // 필수 필드
    required this.selectedDay, // 필수 필드
    this.hasDiabetes, // 선택적 필드
  });

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, int> consumedFoodData = {};
  List<BmiRecord> bmiHistory = [];
  Map<String, Map<String, int>> fruitAnalysisHistory = {};
  int _dailyIntakeKey = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        if (_tabController.index == 0) {  // DailyIntakeScreen의 탭 인덱스
          _dailyIntakeKey++;
          print('Tab changed to DailyIntakeScreen, new key: $_dailyIntakeKey');
        }
      });
    }
  }

  void _updateConsumedFood(Map<String, int> updatedFood) {
    setState(() {
      consumedFoodData = updatedFood;
      _dailyIntakeKey++;
      print('MainScreen - Updated consumedFood: $consumedFoodData');
      print('MainScreen - New daily intake key: $_dailyIntakeKey');
    });
  }

  void _updateFruitAnalysisHistory(Map<String, Map<String, int>> newHistory) {
    String today = DateTime.now().toIso8601String().split('T')[0];
    setState(() {
      newHistory.forEach((key, value) {
        if (fruitAnalysisHistory.containsKey(key)) {
          fruitAnalysisHistory[key]!.addAll(value);
        } else {
          fruitAnalysisHistory[key] = value;
        }

        if (key == today) {
          value.forEach((fruitName, count) {
            consumedFoodData.update(
              fruitName,
                  (existingCount) => existingCount + count,
              ifAbsent: () => count,
            );
          });
        }
      });
      _dailyIntakeKey++;
      print('MainScreen - Updated fruitAnalysisHistory: $fruitAnalysisHistory');
      print('MainScreen - Updated consumedFoodData: $consumedFoodData');
      print('MainScreen - New daily intake key: $_dailyIntakeKey');
    });
  }

  void _updateBmiHistory(List<BmiRecord> updatedHistory) {
    setState(() {
      bmiHistory = updatedHistory;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ageGroup = _calculateAgeGroup(widget.selectedYear);

    final dailyIntakeScreen = DailyIntakeScreen(
      key: ValueKey('daily-intake-$_dailyIntakeKey'),
      consumedFood: Map<String, int>.from(consumedFoodData),
      fruitAnalysisHistory: Map<String, Map<String, int>>.from(fruitAnalysisHistory),
      gender: widget.gender,
      ageGroup: ageGroup,
      onUpdateConsumedFood: _updateConsumedFood,
    );

    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: [
          dailyIntakeScreen,
          MaskPackRecipeScreen(
            fruitAnalysisHistory: fruitAnalysisHistory,
            onUpdateFruitAnalysis: (newHistory) {
              _updateFruitAnalysisHistory(newHistory);
            },
          ),
          FruitAnalysisScreen(
            onUpdateHistory: (newHistory) {
              _updateFruitAnalysisHistory(newHistory);
              setState(() {
                _dailyIntakeKey++;
              });
            },
          ),
          MyPageScreen(
            city: widget.city ?? 'Unknown', // 기본값 제공
            district: widget.district ?? 'Unknown', // 기본값 제공
            subdistrict: widget.subdistrict ?? 'Unknown', // 기본값 제공
            gender: widget.gender,
            ageGroup: ageGroup,
            name: '홍길동',
            bmiHistory: bmiHistory,
            fruitAnalysisHistory: fruitAnalysisHistory,
            consumedFood: consumedFoodData,
            onUpdateConsumedFood: _updateConsumedFood,
          ),
          BmiCalculatorScreen(
            bmiHistory: List.from(bmiHistory),
            onUpdate: _updateBmiHistory,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.green,
        child: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          labelPadding: EdgeInsets.symmetric(horizontal: 0),
          tabs: [
            Tab(icon: Icon(Icons.bar_chart, size: 24), text: '섭취량'),
            Tab(icon: Icon(Icons.spa, size: 24), text: '팩레시피'),
            Tab(icon: Icon(Icons.analytics, size: 24), text: '분석'),
            Tab(icon: Icon(Icons.person, size: 24), text: 'MY'),
            Tab(icon: Icon(Icons.fitness_center, size: 24), text: 'BMI'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }
}

String _calculateAgeGroup(String birthYear) {
  final currentYear = DateTime.now().year;
  final age = currentYear - int.parse(birthYear);
  if (age < 10) return '0~9';
  if (age < 20) return '10~19';
  if (age < 30) return '20~29';
  if (age < 40) return '30~39';
  if (age < 50) return '40~49';
  if (age < 60) return '50~59';
  if (age < 70) return '60~69';
  if (age < 80) return '70~79';
  return '80 이상';
}