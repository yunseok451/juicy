import 'package:flutter/material.dart';
import 'food_data.dart';
import 'fruit_analysis_history_screen.dart';
import 'daily_intake_screen.dart';
import 'bmi_history_screen.dart';
import 'register.dart';
import 'bmi_calculator_screen.dart';

class MyPageScreen extends StatelessWidget {
  final String city;
  final String district;
  final String subdistrict;
  final String name;
  final List<BmiRecord> bmiHistory;
  final Map<String, Map<String, int>> fruitAnalysisHistory;
  final Map<String, int> consumedFood;
  final String gender;
  final String ageGroup;
  final Function(Map<String, int>) onUpdateConsumedFood;  // 추가된 콜백

  MyPageScreen({
    required this.city,
    required this.district,
    required this.subdistrict,
    this.name = '홍길동',
    required this.bmiHistory,
    required this.fruitAnalysisHistory,
    required this.consumedFood,
    required this.gender,
    required this.ageGroup,
    required this.onUpdateConsumedFood,  // 추가
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
                SizedBox(height: 8),
                Text(
                  name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  '$city, $district, $subdistrict',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('섭취량 분석 기록'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DailyIntakeScreen(
                    gender: gender,
                    ageGroup: ageGroup,
                    consumedFood: consumedFood,
                    fruitAnalysisHistory: fruitAnalysisHistory,
                    onUpdateConsumedFood: onUpdateConsumedFood,  // 콜백 전달
                  ),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.analytics),
            title: Text('과채류 분석 내역'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FruitAnalysisHistoryScreen(
                    fruitAnalysisHistory: fruitAnalysisHistory,
                  ),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.fitness_center),
            title: Text('BMI 변화 기록'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BmiHistoryScreen(bmiHistory: bmiHistory),
                ),
              );
            },
          ),
          Divider(),

          SizedBox(height: 20),
          Text('설정', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('알림 설정'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // 알림 설정 페이지
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('테마 설정'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // 테마 설정 페이지
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('언어 설정'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // 언어 설정 페이지
            },
          ),
          Divider(),

          SizedBox(height: 20),
          Text('기타', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('도움말 및 고객지원'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // 고객 지원 페이지
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('약관 및 개인정보처리방침'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // 약관 페이지
            },
          ),
          Divider(),

          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text('로그아웃', style: TextStyle(color: Colors.red)),
            onTap: () {
              // 로그아웃 기능
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('계정 탈퇴', style: TextStyle(color: Colors.red)),
            onTap: () {
              // 계정 탈퇴 기능
            },
          ),
        ],
      ),
    );
  }
}