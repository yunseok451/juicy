# Fruits & Vegetables Instance Segmentation with YOLOv8

## Overview
YOLOv8을 활용한 24종 과채류 인스턴스 세그멘테이션 프로젝트입니다. Roboflow에서 수집한 데이터셋을 기반으로 과채류의 정확한 위치 검출 및 세그멘테이션을 수행합니다.

## Dataset
- **데이터 출처**: [Roboflow - Instance Segmentation Dataset](https://app.roboflow.com/detection-gbrl8/instace/6)
- **클래스 수**: 24개 과채류
- **검출 대상**:
  ```python
  CLASSES = [
      'Broccoli', 'Onion', 'Sweet Potato', 'apple', 'banana', 
      'beet', 'carrot', 'chili', 'cucumber', 'garlic', 
      'grape', 'kiwi', 'lemon', 'mango', 'melon', 
      'orange', 'peach', 'pineapple', 'pomegranate', 'potato',
      'pumpkin', 'strawberry', 'tomato', 'watermelon-fresh'
  ]

### 데이터 구조:

/data/2/ - 초기 테스트 데이터
/data/3/ - 확장 테스트 데이터
/data/4/ - 추가 테스트 데이터
/data/fruits/ - 최종 데이터셋



## Requirements

Python 3.8+
PyTorch
Ultralytics YOLOv8
Roboflow
OpenCV
Numpy
Pandas

## Installation
git clone https://github.com/jms01121/fruits-segmentation.git
cd fruits-segmentation
pip install -r requirements.txt

## Training Process
초기 21개 클래스에서 24개 클래스로 확장
Instance Segmentation 라벨링 적용
데이터 증강 기법 적용:

Rotation
Flip
Mosaic


다양한 데이터셋 구성으로 성능 테스트 진행

Results
Training Metrics
Show Image

학습 과정에서의 Precision, Recall, mAP50, mAP50-95 변화를 보여주는 그래프입니다.

Confusion Matrix
Show Image

24개 클래스에 대한 예측 결과를 보여주는 혼동 행렬입니다.

Performance Metrics
마지막 에폭 기준 성능 지표:
bashCopybox_loss: [값]
seg_loss: [값]
cls_loss: [값]
Precision: [값]
Recall: [값]
mAP50: [값]
mAP50-95: [값]
Validation Results
Show Image

검증 데이터셋에 대한 예측 결과 샘플입니다.

Future Improvements

데이터셋 추가 확보
모델 성능 개선
실시간 검출 시스템 구현
다양한 조명 환경에서의 정확도 향상
새로운 과채류 클래스 추가

## License
MIT License
Contact

GitHub: jms01121