# AChecklist

強力で柔軟なSwift用チェックリスト管理ライブラリ。

## Languages / 言語
- [English](README.md)
- [中文](README_zh.md)
- [日本語](README_ja.md) (現在のページ)
- [한국어](README_ko.md)

## 概要

AChecklistは、相互排他セクション、有効期限、詳細な状態管理などの高度な機能を備えたチェックリストを作成・管理するための強力なフレームワークを提供するSwiftパッケージです。iOS、macOS、tvOS、watchOSアプリケーションで使用するように設計されています。

## 機能

- **階層構造**：セクションとアイテムでチェックリストを整理
- **相互排他**：一度に1つだけ選択できる相互排他セクションを定義
- **状態管理**：色分けで完了状態を追跡・視覚化
- **有効期限**：設定可能な期間の後にアイテムが期限切れになるように設定
- **暗号化ストレージ**：暗号化でチェックリストデータを保護
- **ローカライゼーションサポート**：国際化のための組み込みサポート
- **クロスプラットフォーム**：すべてのAppleプラットフォームで動作

## インストール

### Swift Package Manager

Swift Package Managerを使用してAChecklistをプロジェクトに統合するには、`Package.swift`ファイルに以下を追加してください：

```swift
dependencies: [
    .package(url: "https://github.com/RapboyGao/AChecklist.git", branch: "main")
]
```

次に、AChecklistをターゲットの依存関係として追加します：

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["AChecklist"]
    )
]
```

## 使用方法

### シンプルなチェックリストの作成

```swift
import AChecklist

// セクションとアイテムを含むチェックリストを作成
let checklist = AChecklist(
    name: "毎日のタスク",
    sections: [
        AChecklistSection(
            name: "朝のルーティン",
            items: [
                AChecklistItem(title: "起床", detail: "7:00 AM"),
                AChecklistItem(title: "運動", detail: "30分"),
                AChecklistItem(title: "朝食", detail: "タンパク質と果物")
            ]
        ),
        AChecklistSection(
            name: "夜のタスク",
            items: [
                AChecklistItem(title: "夕食", detail: "健康的な食事"),
                AChecklistItem(title: "読書", detail: "30ページ")
            ]
        )
    ]
)
```

### 相互排他セクションの使用

相互排他機能を使用すると、一度に1つだけ選択できるセクションを作成できます：

```swift
// 相互排他セクションを含むチェックリストを作成
var checklist = AChecklist(
    name: "交通手段の選択",
    sections: [
        AChecklistSection(
            name: "車",
            items: [
                AChecklistItem(title: "エンジンを始動"),
                AChecklistItem(title: "シートベルトを着用")
            ]
        ).mutating { $0.isMutualExclusion = true },
        AChecklistSection(
            name: "公共交通機関",
            items: [
                AChecklistItem(title: "スケジュールを確認"),
                AChecklistItem(title: "チケットを購入")
            ]
        ).mutating { $0.isMutualExclusion = true },
        AChecklistSection(
            name: "自転車",
            items: [
                AChecklistItem(title: "タイヤを確認"),
                AChecklistItem(title: "ヘルメットを着用")
            ]
        ).mutating { $0.isMutualExclusion = true }
    ]
)
```

### アイテムのチェックとチェック解除

```swift
// アイテムにチェックを入れる
checklist.sections[0].items[0].isChecked = true

// アイテムの状態を切り替える
checklist.sections[0].items[1].toggle()

// セクション内のすべてのアイテムにチェックを入れる
checklist.sections[1].status = .checked

// チェックリスト全体の状態を取得
let status = checklist.status // .unchecked, .partiallyChecked, または .checked
```

### 有効期限

```swift
// カスタム有効期限を持つアイテムを作成
var item = AChecklistItem(title: "薬を飲む")
item.expiresAfter = DateComponents(hour: 4)

// アイテムが期限切れかどうかを確認
let isExpired = item.isExpired(now: Date())
```

## 主要コンポーネント

### AChecklist
セクションとアイテムを整理するためのメインコンテナ。

### AChecklistSection
関連するチェック項目のグループで、相互排他に設定できます。

### AChecklistItem
タイトル、詳細、完了状態、有効期限設定を含む個々のタスク。

### AChecklistStatus
チェックリストまたはセクションの完了状態を表す列挙型：
- `.unchecked`：チェックされているアイテムはありません
- `.partiallyChecked`：一部のアイテムがチェックされています
- `.checked`：すべてのアイテムがチェックされています

## 貢献

貢献は大歓迎です！どうぞお気軽にPull Requestを送信してください。

## ライセンス

AChecklistはMITライセンスの下で利用可能です。詳細についてはLICENSEファイルを参照してください。