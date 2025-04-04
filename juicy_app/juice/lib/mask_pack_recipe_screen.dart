import 'package:flutter/material.dart';

class MaskPackRecipeScreen extends StatefulWidget {
  final Map<String, Map<String, int>> fruitAnalysisHistory;
  final Function(Map<String, Map<String, int>>) onUpdateFruitAnalysis;

  MaskPackRecipeScreen({
    required this.fruitAnalysisHistory,
    required this.onUpdateFruitAnalysis,
  });

  @override
  _MaskPackRecipeScreenState createState() => _MaskPackRecipeScreenState();
}

class _MaskPackRecipeScreenState extends State<MaskPackRecipeScreen> {
  final Map<String, String> _nameMapping = {
    'Apple': '사과',
    'Cucumber': '오이',
    'Carrot': '당근',
    'Kale': '케일',
    'Banana': '바나나',
    'Orange': '오렌지',
    'Strawberry': '딸기',
    'Kiwi': '키위',
    'Lemon': '레몬',
    'Avocado': '아보카도',
    'Tomato': '토마토',
    'Pomegranate': '석류',
  };

  final Map<String, Map<String, String>> _recipes = {
    '사과': {
      'recipe': '1. 사과 착즙 후 남은 찌꺼기를 곱게 으깨주세요\n2. 꿀 1큰술을 섞어주세요\n3. 얼굴에 15분간 도포해주세요',
      'effect': '비타민C가 풍부하여 미백효과가 있으며, 피부결 개선에 도움을 줍니다.',
      'caution': '민감성 피부는 사용 전 패치테스트를 해주세요.',
    },
    '오이': {
      'recipe': '1. 오이 착즙 후 남은 찌꺼기를 곱게 갈아주세요\n2. 녹차가루 1/2티스푼을 섞어주세요\n3. 얼굴에 20분간 도포해주세요',
      'effect': '수분 공급과 진정 효과가 뛰어나며, 피부 쿨링에 좋습니다.',
      'caution': '차갑게 보관했다가 사용하면 효과가 더 좋습니다.',
    },
    '당근': {
      'recipe': '1. 당근 착즙 후 남은 찌꺼기를 곱게 갈아주세요\n2. 요구르트 1큰술을 섞어주세요\n3. 얼굴에 15분간 도포해주세요',
      'effect': '비타민A가 풍부하여 피부 재생과 탄력에 도움을 줍니다.',
      'caution': '햇빛에 민감해질 수 있으니 자외선 차단제를 꼭 발라주세요.',
    },
    '케일': {
      'recipe': '1. 케일 착즙 후 남은 찌꺼기를 곱게 갈아주세요\n2. 알로에 젤 1큰술을 섞어주세요\n3. 얼굴에 10분간 도포해주세요',
      'effect': '항산화 성분이 풍부하여 피부 노화 방지에 좋습니다.',
      'caution': '피부가 건조한 경우 사용 시간을 줄여주세요.',
    },
  };

  Map<String, Map<String, String>> _relevantRecipes = {};

  @override
  void initState() {
    super.initState();
    _filterRelevantRecipes();
  }

  @override
  void didUpdateWidget(covariant MaskPackRecipeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _filterRelevantRecipes();
  }

  void _filterRelevantRecipes() {
    String today = DateTime.now().toIso8601String().split('T')[0];
    Map<String, Map<String, String>> newRecipes = {};

    Map<String, int> todaysFruits = widget.fruitAnalysisHistory[today] ?? {};

    todaysFruits.forEach((fruitName, count) {
      String koreanName = _nameMapping[fruitName] ?? fruitName;
      if (_recipes.containsKey(koreanName)) {
        newRecipes[koreanName] = _recipes[koreanName]!;
      }
    });

    setState(() {
      _relevantRecipes = newRecipes;
    });
  }

  void _deleteRecipe(String fruitName) {
    String today = DateTime.now().toIso8601String().split('T')[0];
    Map<String, Map<String, int>> newHistory = Map.from(widget.fruitAnalysisHistory);

    if (newHistory.containsKey(today)) {
      String? englishName = _nameMapping.entries
          .firstWhere((entry) => entry.value == fruitName)
          .key;

      var todaysFruits = Map<String, int>.from(newHistory[today]!);
      todaysFruits.remove(englishName);

      if (todaysFruits.isEmpty) {
        newHistory.remove(today);
      } else {
        newHistory[today] = todaysFruits;
      }

      widget.onUpdateFruitAnalysis(newHistory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _relevantRecipes.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.spa_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              '오늘 탐지된 과일이 없습니다.\n과일을 분석해보세요!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      )
          : CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '착즙 후 남은 찌꺼기로\n만드는 마스크팩 레시피',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '각 과일의 영양성분을 피부에 직접 전달해보세요',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                String fruitName = _relevantRecipes.keys.elementAt(index);
                Map<String, String> recipeData = _relevantRecipes[fruitName]!;

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                fruitName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                              onPressed: () => _deleteRecipe(fruitName),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          '🌿 레시피',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          recipeData['recipe']!,
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '✨ 효과',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          recipeData['effect']!,
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '⚠️ 주의사항',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[400],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          recipeData['caution']!,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.red[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: _relevantRecipes.length,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
        ],
      ),
    );
  }
}