# 🧃 Juicy - 과채류 분석 어플리케이션

**Juicy**는 딥러닝을 활용하여 과일과 채소를 이미지로 분석하고 분류하는 어플리케이션입니다.  
사용자는 카메라나 갤러리 이미지를 통해 과채류를 스캔하고, 영양 정보와 분류 결과를 손쉽게 확인할 수 있습니다.

---

## 📱 주요 기능

- 📷 과일/채소 이미지 인식
- 🧠 딥러닝 모델 기반 실시간 분류
- 🧾 식품명 및 영양 정보 제공
- 📊 섭취 기록 추적 기능 (개발 예정)

---

## 🏗️ 사용 기술

- **Flutter**: 크로스 플랫폼 앱 개발
- **TensorFlow Lite**: 모바일용 분류 모델
- **Python** (서버 처리 시)
- **Firebase** (로그인/DB, 선택사항)

---

## 🚀 실행 방법

1. 이 저장소를 클론합니다:
   ```bash
   git clone https://github.com/yunseok451/juicy.git
   cd juicy
   ```

2. 필요한 패키지를 설치합니다:
   ```bash
   flutter pub get
   ```

3. 모델 파일을 다운로드합니다:  
   [📥 best_float32.tflite 다운로드 (Google Drive)](https://drive.google.com/uc?id=1CTChAv8-NlVA-_aynyAF6feNHZz7bTl8)

   다운로드한 파일을 아래 위치에 넣어주세요:

   ```
   juicy_app/juice/assets/best_float32.tflite
   ```

4. 앱을 실행합니다:
   ```bash
   flutter run
   ```

---

## 🍇 Fruits & Vegetables Instance Segmentation (YOLOv8 기반)

**24종 과채류 인스턴스 세그멘테이션**을 위한 YOLOv8 프로젝트입니다.  
Roboflow에서 수집한 데이터셋을 기반으로 과채류의 정확한 위치 검출 및 분할(Segmentation)을 수행합니다.

---

### 📦 데이터셋

- **출처**: [Roboflow Dataset](https://app.roboflow.com/detection-gbrl8/instace/6)
- **클래스 수**: 총 24종

```python
CLASSES = [
    'Broccoli', 'Onion', 'Sweet Potato', 'apple', 'banana', 
    'beet', 'carrot', 'chili', 'cucumber', 'garlic', 
    'grape', 'kiwi', 'lemon', 'mango', 'melon', 
    'orange', 'peach', 'pineapple', 'pomegranate', 'potato',
    'pumpkin', 'strawberry', 'tomato', 'watermelon-fresh'
]
```

#### 📁 데이터 구조

```
/data/2/         # 초기 테스트 데이터  
/data/3/         # 확장 테스트 데이터  
/data/4/         # 추가 테스트 데이터  
/data/fruits/    # 최종 데이터셋  
```

---

### 🧰 Requirements

- Python 3.8+
- PyTorch
- Ultralytics YOLOv8
- Roboflow
- OpenCV
- NumPy
- Pandas

---

### ⚙️ 설치

```bash
git clone https://github.com/jms01121/fruits-segmentation.git
cd fruits-segmentation
pip install -r requirements.txt
```

---

### 🏋️‍♂️ Training Process

- 클래스 21 → 24종으로 확장
- Instance Segmentation 라벨 적용
- 데이터 증강 (Rotation, Flip, Mosaic)
- 다양한 데이터셋에 대해 성능 테스트 수행

---

### 📊 결과 지표

- Precision, Recall, mAP50, mAP50-95 그래프
- 24종 클래스 혼동 행렬
- 최종 에폭 기준 성능:
  - `box_loss`: [값]
  - `seg_loss`: [값]
  - `cls_loss`: [값]
  - `Precision`: [값]
  - `Recall`: [값]
  - `mAP50`: [값]
  - `mAP50-95`: [값]

---

## 🔮 Future Improvements

- 데이터셋 추가 확보
- 실시간 검출 시스템 구현
- 조명 변화 대응 정확도 향상
- 새로운 과채류 클래스 추가

---

## 📜 라이선스

MIT License

---

## 🙋‍♂️ Contact

- **Juicy App**: [@yunseok451](https://github.com/yunseok451)  
- **YOLOv8 프로젝트**: [@jms01121](https://github.com/jms01121)
