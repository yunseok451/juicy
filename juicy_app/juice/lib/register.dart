import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'main_screen.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? _name;
  String? _selectedGender;
  String? _selectedYear;
  String? _selectedMonth;
  String? _selectedDay;
  String? _selectedCity;
  String? _selectedDistrict;
  String? _selectedSubdistrict;
  bool? _hasDiabetes;

  final TextEditingController _nameController = TextEditingController();

  Map<String, dynamic> regions = {};
  List<String> districtList = [];
  List<String> subdistrictList = [];

  final List<String> years = List.generate(100, (index) => (2023 - index).toString());
  final List<String> months = List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
  final List<String> days = List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));

  @override
  void initState() {
    super.initState();
    loadRegionsData();
  }

  Future<void> loadRegionsData() async {
    final String response = await rootBundle.loadString('assets/korea_regions.json');
    final data = json.decode(response);
    setState(() {
      regions = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('기본 정보', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                SizedBox(
                  height: 60,
                  child: TextField(
                    controller: _nameController,
                    onChanged: (value) {
                      setState(() {
                        _name = value; // _name 변수에 직접 할당
                      });
                    },
                    decoration: InputDecoration(
                      labelText: '이름',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      hintText: _name, // _name 변수 사용

                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text('성별', style: TextStyle(fontSize: 16)),
                    Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedGender = '여자';
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _selectedGender == '여자' ? Colors.green : Colors.grey),
                      ),
                      child: Text('여자', style: TextStyle(color: _selectedGender == '여자' ? Colors.green : Colors.grey)),
                    ),
                    SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedGender = '남자';
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _selectedGender == '남자' ? Colors.green : Colors.grey),
                      ),
                      child: Text('남자', style: TextStyle(color: _selectedGender == '남자' ? Colors.green : Colors.grey)),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: DropdownButtonFormField2(
                          decoration: InputDecoration(
                            labelText: '생년',
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.green, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.green, width: 1.5),
                            ),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                          ),
                          items: years.map((year) {
                            return DropdownMenuItem(value: year, child: Text(year));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedYear = value as String?;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: DropdownButtonFormField2(
                          decoration: InputDecoration(
                            labelText: '월',
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.green, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.green, width: 1.5),
                            ),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                          ),
                          items: months.map((month) {
                            return DropdownMenuItem(value: month, child: Text(month));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedMonth = value as String?;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: DropdownButtonFormField2(
                          decoration: InputDecoration(
                            labelText: '일',
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.green, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.green, width: 1.5),
                            ),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                          ),
                          items: days.map((day) {
                            return DropdownMenuItem(value: day, child: Text(day));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDay = value as String?;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text('세부 정보 - 혈당 관련 질환 여부', style: TextStyle(fontSize: 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _hasDiabetes = true;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _hasDiabetes == true ? Colors.green : Colors.grey),
                      ),
                      child: Text('예', style: TextStyle(color: _hasDiabetes == true ? Colors.green : Colors.grey)),
                    ),
                    SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _hasDiabetes = false;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _hasDiabetes == false ? Colors.green : Colors.grey),
                      ),
                      child: Text('아니요', style: TextStyle(color: _hasDiabetes == false ? Colors.green : Colors.grey)),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text('선택 입력', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                SizedBox(
                  height: 60,
                  child: DropdownButtonFormField2<String>(
                    decoration: InputDecoration(
                      labelText: '시/도',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.green, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.green, width: 1.5),
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                    ),
                    items: regions.keys.map((city) {
                      return DropdownMenuItem(value: city, child: Text(city));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCity = value;
                        _selectedDistrict = null;
                        _selectedSubdistrict = null;
                        districtList = regions[_selectedCity]?.keys.toList() ?? [];
                        subdistrictList = [];
                      });
                    },
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  height: 60,
                  child: DropdownButtonFormField2<String>(
                    decoration: InputDecoration(
                      labelText: '시/군/구',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.green, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.green, width: 1.5),
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                    ),
                    items: districtList.map((district) {
                      return DropdownMenuItem(value: district, child: Text(district));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDistrict = value;
                        _selectedSubdistrict = null;
                        subdistrictList = regions[_selectedCity]?[_selectedDistrict]?.cast<String>() ?? [];
                      });
                    },
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  height: 60,
                  child: DropdownButtonFormField2<String>(
                    decoration: InputDecoration(
                      labelText: '읍/면/동',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.green, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.green, width: 1.5),
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                    ),
                    items: subdistrictList.map((subdistrict) {
                      return DropdownMenuItem(value: subdistrict, child: Text(subdistrict));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSubdistrict = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '입력하신 주소 정보는 추후 이벤트 대상지역 선정에 활용됩니다.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(
                            city: _selectedCity ?? 'Unknown',
                            district: _selectedDistrict ?? 'Unknown',
                            subdistrict: _selectedSubdistrict ?? 'Unknown',
                            hasDiabetes: _hasDiabetes,
                            gender: _selectedGender ?? 'Unknown',
                            selectedYear: _selectedYear ?? 'Unknown',
                            selectedMonth: _selectedMonth ?? 'Unknown',
                            selectedDay: _selectedDay ?? 'Unknown',
                          ),
                        ),
                      );
                    },
                    child: Text('다음', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}