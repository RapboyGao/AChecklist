# AChecklist

강력하고 유연한 Swift용 체크리스트 관리 라이브러리입니다.

## Languages / 언어
- [English](README.md)
- [中文](README_zh.md)
- [日本語](README_ja.md)
- [한국어](README_ko.md) (현재 페이지)

## 개요

AChecklist는 상호 배타적인 섹션, 만료 시간 및 상세한 상태 관리를 포함한 고급 기능을 가진 체크리스트를 생성하고 관리하기 위한 강력한 프레임워크를 제공하는 Swift 패키지입니다. iOS, macOS, tvOS 및 watchOS 애플리케이션에서 사용하도록 설계되었습니다.

## 주요 기능

- **계층적 구조**：섹션과 항목으로 체크리스트를 구성
- **상호 배타성**：한 번에 하나만 선택할 수 있는 상호 배타적인 섹션 정의
- **상태 관리**：색상 코딩으로 완료 상태를 추적하고 시각화
- **만료 시간**：설정 가능한 기간 후에 항목이 만료되도록 설정
- **암호화 저장**：체크리스트 데이터를 암호화로 보호
- **국제화 지원**：국제화를 위한 기본 지원
- **크로스 플랫폼**：모든 Apple 플랫폼에서 작동

## 설치

### Swift Package Manager

Swift Package Manager를 사용하여 AChecklist를 프로젝트에 통합하려면 `Package.swift` 파일에 다음을 추가하세요：

```swift
dependencies: [
    .package(url: "https://github.com/RapboyGao/AChecklist.git", branch: "main")
]
```

그런 다음, AChecklist를 타겟의 종속성으로 추가합니다：

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["AChecklist"]
    )
]
```

## 사용 방법

### 단순 체크리스트 생성

```swift
import AChecklist

// 섹션과 항목을 포함한 체크리스트 생성
let checklist = AChecklist(
    name: "일일 작업",
    sections: [
        AChecklistSection(
            name: "아침 루틴",
            items: [
                AChecklistItem(title: "일어나기", detail: "오전 7시"),
                AChecklistItem(title: "운동", detail: "30분"),
                AChecklistItem(title: "아침 식사", detail: "단백질과 과일")
            ]
        ),
        AChecklistSection(
            name: "저녁 작업",
            items: [
                AChecklistItem(title: "저녁 식사", detail: "건강한 식사"),
                AChecklistItem(title: "독서", detail: "30페이지")
            ]
        )
    ]
)
```

### 상호 배타적인 섹션 사용

상호 배타 기능을 사용하면 한 번에 하나만 선택할 수 있는 섹션을 생성할 수 있습니다：

```swift
// 상호 배타적인 섹션을 포함한 체크리스트 생성
var checklist = AChecklist(
    name: "교통 수단 선택",
    sections: [
        AChecklistSection(
            name: "자동차",
            items: [
                AChecklistItem(title: "엔진 시동"),
                AChecklistItem(title: "안전벨트 착용")
            ]
        ).mutating { $0.isMutualExclusion = true },
        AChecklistSection(
            name: "대중교통",
            items: [
                AChecklistItem(title: "시간표 확인"),
                AChecklistItem(title: "티켓 구매")
            ]
        ).mutating { $0.isMutualExclusion = true },
        AChecklistSection(
            name: "자전거",
            items: [
                AChecklistItem(title: "타이어 확인"),
                AChecklistItem(title: "헬멧 착용")
            ]
        ).mutating { $0.isMutualExclusion = true }
    ]
)
```

### 항목 체크 및 해제

```swift
// 항목에 체크 표시
checklist.sections[0].items[0].isChecked = true

// 항목 상태 전환
checklist.sections[0].items[1].toggle()

// 섹션 내의 모든 항목에 체크 표시
checklist.sections[1].status = .checked

// 전체 체크리스트 상태 가져오기
let status = checklist.status // .unchecked, .partiallyChecked, 또는 .checked
```

### 만료 시간

```swift
// 사용자 정의 만료 시간을 가진 항목 생성
var item = AChecklistItem(title: "약 복용")
item.expiresAfter = DateComponents(hour: 4)

// 항목이 만료되었는지 확인
let isExpired = item.isExpired(now: Date())
```

## 주요 구성 요소

### AChecklist
섹션과 항목을 구성하기 위한 주요 컨테이너입니다.

### AChecklistSection
관련된 체크 항목 그룹으로, 상호 배타적으로 설정할 수 있습니다.

### AChecklistItem
제목, 세부 정보, 완료 상태 및 만료 설정이 포함된 개별 작업입니다.

### AChecklistStatus
체크리스트 또는 섹션의 완료 상태를 나타내는 열거형：
- `.unchecked`：체크된 항목이 없음
- `.partiallyChecked`：일부 항목이 체크됨
- `.checked`：모든 항목이 체크됨

## 기여

기여를 환영합니다！Pull Request를 자유롭게 제출해 주세요.

## 라이선스

AChecklist는 MIT 라이선스 하에 사용할 수 있습니다. 자세한 내용은 LICENSE 파일을 참조하세요.