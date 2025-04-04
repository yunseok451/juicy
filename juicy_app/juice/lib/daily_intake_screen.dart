import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'food_data.dart';
import 'fruit_analysis_screen.dart';

class DailyIntakeScreen extends StatefulWidget {
  final Map<String, int> consumedFood;
  final Map<String, Map<String, int>> fruitAnalysisHistory;
  final String gender;
  final String ageGroup;
  final Function(Map<String, int>) onUpdateConsumedFood;

  DailyIntakeScreen({
    Key? key,
    required this.consumedFood,
    required this.fruitAnalysisHistory,
    required this.gender,
    required this.ageGroup,
    required this.onUpdateConsumedFood,
  }) : super(key: key);

  @override
  _DailyIntakeScreenState createState() => _DailyIntakeScreenState();
}

class _DailyIntakeScreenState extends State<DailyIntakeScreen> {
  late Map<String, int> _localConsumedFood;
  Map<String, double> accumulatedNutrients = {
    "칼로리": 0.0,
    "수분": 0.0,
    "탄수화물": 0.0,
    "당류": 0.0,
    "지방": 0.0,
    "단백질": 0.0,
    "회분": 0.0,
    "식이섬유": 0.0,
    "비타민A": 0.0,
    "비타민B6": 0.0,
    "비타민C": 0.0,
    "칼륨": 0.0,
    "마그네슘": 0.0,
  };

  @override
  void initState() {
    super.initState();
    _localConsumedFood = Map.from(widget.consumedFood);
    _updateAccumulatedNutrients();
  }

  @override
  void didUpdateWidget(DailyIntakeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.consumedFood != oldWidget.consumedFood) {
      _localConsumedFood = Map.from(widget.consumedFood);
      _updateAccumulatedNutrients();
      print('DailyIntakeScreen - Widget updated with new data: ${widget.consumedFood}');
    }
  }

  void onFruitDetected(Map<String, Map<String, int>> detectedFruits) {
    print('DailyIntakeScreen - Received detected fruits: $detectedFruits');
    String today = DateTime.now().toIso8601String().split('T')[0];
    if (detectedFruits.containsKey(today)) {
      setState(() {
        detectedFruits[today]!.forEach((fruitName, count) {
          _localConsumedFood.update(
            fruitName,
                (existingCount) => existingCount + count,
            ifAbsent: () => count,
          );
        });
        widget.onUpdateConsumedFood(_localConsumedFood);
        print('DailyIntakeScreen - Updated localConsumedFood: $_localConsumedFood');
        _updateAccumulatedNutrients();
      });
    }
  }

  void _updateAccumulatedNutrients() {
    print('DailyIntakeScreen - Updating accumulated nutrients...');
    setState(() {
      accumulatedNutrients = {
        "칼로리": 0.0,
        "수분": 0.0,
        "탄수화물": 0.0,
        "당류": 0.0,
        "지방": 0.0,
        "단백질": 0.0,
        "회분": 0.0,
        "식이섬유": 0.0,
        "비타민A": 0.0,
        "비타민B6": 0.0,
        "비타민C": 0.0,
        "칼륨": 0.0,
        "마그네슘": 0.0,
      };
      _localConsumedFood.forEach((foodName, count) {
        print('DailyIntakeScreen - Processing food: $foodName, count: $count');
        final foodNutrients = foodData.firstWhere(
              (item) => item['name'].toString().toLowerCase() == foodName.toLowerCase(),
          orElse: () => {},
        );

        if (foodNutrients.isNotEmpty) {
          accumulatedNutrients.update("칼로리", (value) => value + (foodNutrients['energy'] ?? 0) * count);
          accumulatedNutrients.update("수분", (value) => value + (foodNutrients['water'] ?? 0) * count);
          accumulatedNutrients.update("탄수화물", (value) => value + (foodNutrients['carbs'] ?? 0) * count);
          accumulatedNutrients.update("당류", (value) => value + (foodNutrients['sugar'] ?? 0) * count);
          accumulatedNutrients.update("지방", (value) => value + (foodNutrients['fat'] ?? 0) * count);
          accumulatedNutrients.update("단백질", (value) => value + (foodNutrients['protein'] ?? 0) * count);
          accumulatedNutrients.update("회분", (value) => value + (foodNutrients['ash'] ?? 0) * count);
          accumulatedNutrients.update("식이섬유", (value) => value + (foodNutrients['dietaryFiber'] ?? 0) * count);
          accumulatedNutrients.update("비타민A", (value) => value + (foodNutrients['vitaminA'] ?? 0) * count);
          accumulatedNutrients.update("비타민B6", (value) => value + (foodNutrients['vitaminB6'] ?? 0) * count);
          accumulatedNutrients.update("비타민C", (value) => value + (foodNutrients['vitaminC'] ?? 0) * count);
          accumulatedNutrients.update("칼륨", (value) => value + (foodNutrients['potassium'] ?? 0) * count);
          accumulatedNutrients.update("마그네슘", (value) => value + (foodNutrients['magnesium'] ?? 0) * count);
        }
      });

      print('DailyIntakeScreen - Updated nutrients: $accumulatedNutrients');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('일일 섭취량 분석'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '섭취된 영양소 그래프',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildCircularIndicators(),
            SizedBox(height: 40),
            Divider(),
            Text(
              '섭취된 음식 상세 정보',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildConsumedFoodDetails(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildConsumedFoodDetails() {
    return _localConsumedFood.entries.map((entry) {
      final foodName = entry.key;
      final count = entry.value;
      final foodNutrients = foodData.firstWhere(
            (item) => item['name'].toString().toLowerCase() == foodName.toLowerCase(),
        orElse: () => {},
      );

      if (foodNutrients.isNotEmpty) {
        final totalEnergy = (foodNutrients['energy'] ?? 0) * count;
        final totalWater = (foodNutrients['water'] ?? 0) * count;
        final totalProtein = (foodNutrients['protein'] ?? 0) * count;
        final totalFat = (foodNutrients['fat'] ?? 0) * count;
        final totalCarbs = (foodNutrients['carbs'] ?? 0) * count;
        final totalSugar = (foodNutrients['sugar'] ?? 0) * count;
        final totalAsh = (foodNutrients['ash'] ?? 0) * count;
        final totalFiber = (foodNutrients['dietaryFiber'] ?? 0) * count;
        final totalVitaminA = (foodNutrients['vitaminA'] ?? 0) * count;
        final totalVitaminB6 = (foodNutrients['vitaminB6'] ?? 0) * count;
        final totalVitaminC = (foodNutrients['vitaminC'] ?? 0) * count;
        final totalPotassium = (foodNutrients['potassium'] ?? 0) * count;
        final totalMagnesium = (foodNutrients['magnesium'] ?? 0) * count;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$foodName: $count개'),
            Text('  칼로리: ${totalEnergy.toStringAsFixed(1)} kcal'),
            Text('  수분: ${totalWater.toStringAsFixed(1)} g'),
            Text('  단백질: ${totalProtein.toStringAsFixed(2)} g'),
            Text('  지방: ${totalFat.toStringAsFixed(2)} g'),
            Text('  탄수화물: ${totalCarbs.toStringAsFixed(2)} g'),
            Text('  당류: ${totalSugar.toStringAsFixed(2)} g'),
            Text('  식이섬유: ${totalFiber.toStringAsFixed(2)} g'),
            Text('  회분: ${totalAsh.toStringAsFixed(2)} g'),
            Text('  비타민 A: ${totalVitaminA.toStringAsFixed(1)} μg'),
            Text('  비타민 B6: ${totalVitaminB6.toStringAsFixed(3)} mg'),
            Text('  비타민 C: ${totalVitaminC.toStringAsFixed(1)} mg'),
            Text('  칼륨: ${totalPotassium.toStringAsFixed(1)} mg'),
            Text('  마그네슘: ${totalMagnesium.toStringAsFixed(1)} mg'),
            SizedBox(height: 10),
          ],
        );
      } else {
        return Text('$foodName: $count개');
      }
    }).toList();
  }

  final Map<String, Map<String, dynamic>> recommendedIntake = {
    "남": {
      "6~8": {"칼로리": 1600, "탄수화물": 130, "지방": 70, "단백질": 35, "수분": 1700},
      "9~11": {"칼로리": 1900, "탄수화물": 130, "지방": 100, "단백질": 50, "수분": 2000},
      "12~14": {"칼로리": 2400, "탄수화물": 130, "지방": 120, "단백질": 60, "수분": 2400},
      "15~19": {"칼로리": 2700, "탄수화물": 130, "지방": 135, "단백질": 65, "수분": 2700},
      "20~29": {"칼로리": 2600, "탄수화물": 130, "지방": 130, "단백질": 65, "수분": 2700},
      "30~49": {"칼로리": 2400, "탄수화물": 130, "지방": 120, "단백질": 60, "수분": 2500},
      "50~64": {"칼로리": 2200, "탄수화물": 130, "지방": 120, "단백질": 60, "수분": 2300},
      "65~74": {"칼로리": 2000, "탄수화물": 130, "지방": 120, "단백질": 60, "수분": 2100},
      "75 이상": {"칼로리": 2000, "탄수화물": 130, "지방": 120, "단백질": 60, "수분": 2100},
    },
    "여": {
      "6~8": {"칼로리": 1500, "탄수화물": 130, "지방": 70, "단백질": 35, "수분": 1600},
      "9~11": {"칼로리": 1700, "탄수화물": 130, "지방": 90, "단백질": 45, "수분": 1800},
      "12~14": {"칼로리": 2000, "탄수화물": 130, "지방": 110, "단백질": 55, "수분": 2000},
      "15~19": {"칼로리": 2000, "탄수화물": 130, "지방": 110, "단백질": 55, "수분": 2100},
      "20~29": {"칼로리": 2100, "탄수화물": 130, "지방": 110, "단백질": 55, "수분": 2100},
      "30~49": {"칼로리": 1900, "탄수화물": 130, "지방": 100, "단백질": 50, "수분": 2000},
      "50~64": {"칼로리": 1800, "탄수화물": 130, "지방": 100, "단백질": 50, "수분": 1800},
      "65~74": {"칼로리": 1600, "탄수화물": 130, "지방": 100, "단백질": 50, "수분": 1700},
      "75 이상": {"칼로리": 1600, "탄수화물": 130, "지방": 100, "단백질": 50, "수분": 1700},
    }
  };

  Widget _buildCircularIndicators() {
    final recommended = recommendedIntake[widget.gender]?[widget.ageGroup] ?? {
      "칼로리": 2000.0,
      "탄수화물": 300.0,
      "지방": 70.0,
      "단백질": 50.0,
      "수분": 3000.0,
      "비타민A": 700.0,
      "비타민B6": 1.5,
      "비타민C": 100.0,
      "칼륨": 3500.0,
      "마그네슘": 370.0,
      "식이섬유": 25.0
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _buildCircularIndicator('칼로리', accumulatedNutrients['칼로리'] ?? 0, recommended['칼로리'] ?? 2000),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildCircularIndicator('단백질', accumulatedNutrients['단백질'] ?? 0, recommended['단백질'] ?? 50),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _buildCircularIndicator('탄수화물', accumulatedNutrients['탄수화물'] ?? 0, recommended['탄수화물'] ?? 300),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildCircularIndicator('지방', accumulatedNutrients['지방'] ?? 0, recommended['지방'] ?? 70),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _buildCircularIndicator('식이섬유', accumulatedNutrients['식이섬유'] ?? 0, recommended['식이섬유'] ?? 25),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildCircularIndicator('비타민A', accumulatedNutrients['비타민A'] ?? 0, recommended['비타민A'] ?? 700),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _buildCircularIndicator('비타민C', accumulatedNutrients['비타민C'] ?? 0, recommended['비타민C'] ?? 100),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildCircularIndicator('칼륨', accumulatedNutrients['칼륨'] ?? 0, recommended['칼륨'] ?? 3500),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _buildCircularIndicator('마그네슘', accumulatedNutrients['마그네슘'] ?? 0, recommended['마그네슘'] ?? 370),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildCircularIndicator('수분', accumulatedNutrients['수분'] ?? 0, recommended['수분'] ?? 3000),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircularIndicator(String nutrient, double consumed, double recommended) {
    double percentage = (consumed / recommended).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$nutrient: ${consumed.toStringAsFixed(1)} / ${recommended.toStringAsFixed(1)}'),
        SizedBox(height: 10),
        Center(
          child: CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 13.0,
            animation: true,
            percent: percentage,
            center: Text(
              "${(percentage * 100).toStringAsFixed(1)}%",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: _getColorForPercentage(percentage),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Color _getColorForPercentage(double percentage) {
    int red = (255 * (1 - percentage)).toInt();
    int green = (255 * percentage).toInt();
    return Color.fromARGB(255, red, green, 0);
  }
}