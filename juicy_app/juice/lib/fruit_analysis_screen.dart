import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_tts/flutter_tts.dart';
import 'food_data.dart';

class FruitAnalysisScreen extends StatefulWidget {
  final Function(Map<String, Map<String, int>>) onUpdateHistory;

  FruitAnalysisScreen({required this.onUpdateHistory});

  @override
  _FruitAnalysisScreenState createState() => _FruitAnalysisScreenState();
}

class _FruitAnalysisScreenState extends State<FruitAnalysisScreen> {
  late FlutterVision vision;
  late FlutterTts flutterTts;
  String result = '결과 없음';
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageData;
  bool isLoading = false;

  Map<String, int> classCounts = {};

  @override
  void initState() {
    super.initState();
    initVision();
    flutterTts = FlutterTts();
  }

  Future<void> initVision() async {
    vision = FlutterVision();
    await vision.loadYoloModel(
      labels: 'assets/labels.txt',
      modelPath: 'assets/best_float32.tflite',
      modelVersion: "yolov8seg",
      quantization: false,
      numThreads: 1,
      useGpu: false,
    );
  }

  Future<void> runModelOnImage(Uint8List byteData) async {
    setState(() {
      isLoading = true;
      result = 'Loading...';
    });

    final image = img.decodeImage(byteData)!;
    final results = await vision.yoloOnImage(
      bytesList: byteData,
      imageHeight: 640,
      imageWidth: 640,
      iouThreshold: 0.7,
      //confThreshold: 0.6,
      classThreshold: 0.6,
    );

    Map<String, int> detectedClassCounts = {};
    for (var result in results) {
      String detectedClass = result['tag'];
      detectedClassCounts.update(
        detectedClass,
            (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    setState(() {
      _imageData = byteData;
      classCounts = detectedClassCounts;
      result = detectedClassCounts.entries.map((e) => '${e.key}: ${e.value}').join(', ');
      isLoading = false;
    });

    String today = DateTime.now().toIso8601String().split('T')[0];
    print('Detected fruits: $detectedClassCounts');
    widget.onUpdateHistory({today: detectedClassCounts});
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List byteData = await image.readAsBytes();
      await runModelOnImage(byteData);
    }
  }

  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final Uint8List byteData = await image.readAsBytes();
      await runModelOnImage(byteData);
    }
  }

  Future<void> readNutritionInfo(String nutritionInfo) async {
    await flutterTts.setLanguage("ko-KR");
    await flutterTts.setSpeechRate(0.8);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(nutritionInfo);
  }

  void showClassWiseFoodDataDialog() async {
    final nutritionText = StringBuffer('탐지된 과일의 영양 성분을 알려드리겠습니다. ');

    await flutterTts.setLanguage("ko-KR");
    await flutterTts.setSpeechRate(0.8);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    for (var entry in classCounts.entries) {
      final foodName = entry.key;
      final count = entry.value;
      final foodNutrients = foodData.firstWhere(
            (item) => item['name'].toString().toLowerCase() == foodName.toLowerCase(),
        orElse: () => {},
      );

      if (foodNutrients.isNotEmpty) {
        final totalEnergy = (foodNutrients['energy'] ?? 0) * count;
        final totalProtein = (foodNutrients['protein'] ?? 0) * count;
        final totalCarbs = (foodNutrients['carbs'] ?? 0) * count;
        final totalFat = (foodNutrients['fat'] ?? 0) * count;
        final totalWater = (foodNutrients['water'] ?? 0) * count;
        final totalSugar = (foodNutrients['sugar'] ?? 0) * count;
        final totalVitaminA = (foodNutrients['vitaminA'] ?? 0) * count;
        final totalVitaminB6 = (foodNutrients['vitaminB6'] ?? 0) * count;
        final totalVitaminC = (foodNutrients['vitaminC'] ?? 0) * count;
        final totalPotassium = (foodNutrients['potassium'] ?? 0) * count;
        final totalMagnesium = (foodNutrients['magnesium'] ?? 0) * count;
        final totalDietaryFiber = (foodNutrients['dietaryFiber'] ?? 0) * count;
        final totalAsh = (foodNutrients['ash'] ?? 0) * count;

        nutritionText.write('$foodName ${count}개의 영양 성분은 ');
        nutritionText.write('칼로리 ${totalEnergy.toStringAsFixed(1)} 킬로칼로리, ');
        nutritionText.write('수분 ${totalWater.toStringAsFixed(1)} 그램, ');
        nutritionText.write('단백질 ${totalProtein.toStringAsFixed(1)} 그램, ');
        nutritionText.write('지방 ${totalFat.toStringAsFixed(1)} 그램, ');
        nutritionText.write('탄수화물 ${totalCarbs.toStringAsFixed(1)} 그램, ');
        nutritionText.write('당류 ${totalSugar.toStringAsFixed(1)} 그램, ');
        nutritionText.write('식이섬유 ${totalDietaryFiber.toStringAsFixed(1)} 그램, ');
        nutritionText.write('비타민 A ${totalVitaminA.toStringAsFixed(1)} 마이크로그램, ');
        nutritionText.write('비타민 B6 ${totalVitaminB6.toStringAsFixed(3)} 밀리그램, ');
        nutritionText.write('비타민 C ${totalVitaminC.toStringAsFixed(1)} 밀리그램, ');
        nutritionText.write('칼륨 ${totalPotassium.toStringAsFixed(1)} 밀리그램, ');
        nutritionText.write('마그네슘 ${totalMagnesium.toStringAsFixed(1)} 밀리그램, ');
        nutritionText.write('회분 ${totalAsh.toStringAsFixed(1)} 그램입니다. ');
      }
    }

    await flutterTts.speak(nutritionText.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('과채류별 영양 성분 정보'),
          content: SingleChildScrollView(
            child: ListBody(
              children: classCounts.entries.map((entry) {
                final foodName = entry.key;
                final count = entry.value;
                final foodNutrients = foodData.firstWhere(
                      (item) => item['name'].toString().toLowerCase() == foodName.toLowerCase(),
                  orElse: () => {},
                );

                if (foodNutrients.isNotEmpty) {
                  final totalEnergy = (foodNutrients['energy'] ?? 0) * count;
                  final totalProtein = (foodNutrients['protein'] ?? 0) * count;
                  final totalCarbs = (foodNutrients['carbs'] ?? 0) * count;
                  final totalFat = (foodNutrients['fat'] ?? 0) * count;
                  final totalWater = (foodNutrients['water'] ?? 0) * count;
                  final totalSugar = (foodNutrients['sugar'] ?? 0) * count;
                  final totalVitaminA = (foodNutrients['vitaminA'] ?? 0) * count;
                  final totalVitaminB6 = (foodNutrients['vitaminB6'] ?? 0) * count;
                  final totalVitaminC = (foodNutrients['vitaminC'] ?? 0) * count;
                  final totalPotassium = (foodNutrients['potassium'] ?? 0) * count;
                  final totalMagnesium = (foodNutrients['magnesium'] ?? 0) * count;
                  final totalDietaryFiber = (foodNutrients['dietaryFiber'] ?? 0) * count;
                  final totalAsh = (foodNutrients['ash'] ?? 0) * count;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$foodName:'),
                      Text('  칼로리: ${totalEnergy.toStringAsFixed(1)} kcal'),
                      Text('  수분: ${totalWater.toStringAsFixed(1)} g'),
                      Text('  단백질: ${totalProtein.toStringAsFixed(2)} g'),
                      Text('  지방: ${totalFat.toStringAsFixed(2)} g'),
                      Text('  탄수화물: ${totalCarbs.toStringAsFixed(2)} g'),
                      Text('  당류: ${totalSugar.toStringAsFixed(2)} g'),
                      Text('  식이섬유: ${totalDietaryFiber.toStringAsFixed(2)} g'),
                      Text('  비타민 A: ${totalVitaminA.toStringAsFixed(1)} μg'),
                      Text('  비타민 B6: ${totalVitaminB6.toStringAsFixed(3)} mg'),
                      Text('  비타민 C: ${totalVitaminC.toStringAsFixed(1)} mg'),
                      Text('  칼륨: ${totalPotassium.toStringAsFixed(1)} mg'),
                      Text('  마그네슘: ${totalMagnesium.toStringAsFixed(1)} mg'),
                      Text('  회분: ${totalAsh.toStringAsFixed(2)} g'),
                      SizedBox(height: 10),
                    ],
                  );
                } else {
                  return SizedBox.shrink();
                }
              }).toList(),
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text('닫기'),
              onPressed: () {
                flutterTts.stop();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('다시 듣기'),
              onPressed: () async {
                await flutterTts.stop();
                await flutterTts.speak(nutritionText.toString());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (_imageData != null)
            Expanded(
              flex: 3,
              child: Image.memory(
                _imageData!,
                fit: BoxFit.contain,
              ),
            )
          else
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.grey[100],
                child: Center(child: Text('이미지를 선택하거나 촬영하세요')),
              ),
            ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLoading ? 'Loading...' : result,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: pickImageFromGallery,
                        child: Text('이미지 선택', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: pickImageFromCamera,
                        child: Text('카메라 촬영', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                  if (_imageData != null) ...[
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: showClassWiseFoodDataDialog,
                      child: Text('영양성분 보기', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}