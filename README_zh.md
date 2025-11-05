# AChecklist

一个功能强大且灵活的Swift检查单管理库。

## Languages / 语言
- [English](README.md)
- [中文](README_zh.md) (当前页面)
- [日本語](README_ja.md)
- [한국어](README_ko.md)

## 概述

AChecklist是一个Swift包，提供了一个强大的框架，用于创建和管理具有高级功能的检查单，如互斥分区、过期时间和详细的状态管理。它设计用于iOS、macOS、tvOS和watchOS应用程序。

## 特性

- **分层结构**：使用分区和项目组织检查单
- **互斥功能**：定义互斥的分区，一次只允许选择其中一个
- **状态管理**：使用颜色编码跟踪和可视化完成状态
- **过期时间**：设置项目在可配置的时间段后过期
- **加密存储**：使用加密保护检查单数据
- **本地化支持**：内置国际化支持
- **跨平台**：适用于所有Apple平台

## 安装

### Swift Package Manager

要使用Swift Package Manager将AChecklist集成到您的项目中，请在`Package.swift`文件中添加以下内容：

```swift
dependencies: [
    .package(url: "https://github.com/RapboyGao/AChecklist.git", branch: "main")
]
```

然后，将AChecklist添加为目标的依赖项：

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["AChecklist"]
    )
]
```

## 使用方法

### 创建简单的检查单

```swift
import AChecklist

// 创建一个包含分区和项目的检查单
let checklist = AChecklist(
    name: "每日任务",
    sections: [
        AChecklistSection(
            name: "晨间例行",
            items: [
                AChecklistItem(title: "起床", detail: "7:00 AM"),
                AChecklistItem(title: "锻炼", detail: "30分钟"),
                AChecklistItem(title: "早餐", detail: "蛋白质和水果")
            ]
        ),
        AChecklistSection(
            name: "晚间任务",
            items: [
                AChecklistItem(title: "晚餐", detail: "健康餐食"),
                AChecklistItem(title: "阅读", detail: "30页")
            ]
        )
    ]
)
```

### 使用互斥分区

互斥功能允许您创建一次只允许选择其中一个的分区：

```swift
// 创建一个具有互斥分区的检查单
var checklist = AChecklist(
    name: "交通选项",
    sections: [
        AChecklistSection(
            name: "汽车",
            items: [
                AChecklistItem(title: "启动引擎"),
                AChecklistItem(title: "系好安全带")
            ]
        ).mutating { $0.isMutualExclusion = true },
        AChecklistSection(
            name: "公共交通",
            items: [
                AChecklistItem(title: "查看时刻表"),
                AChecklistItem(title: "购票")
            ]
        ).mutating { $0.isMutualExclusion = true },
        AChecklistSection(
            name: "自行车",
            items: [
                AChecklistItem(title: "检查轮胎"),
                AChecklistItem(title: "戴头盔")
            ]
        ).mutating { $0.isMutualExclusion = true }
    ]
)
```

### 勾选和取消勾选项目

```swift
// 勾选一个项目
checklist.sections[0].items[0].isChecked = true

// 切换项目状态
checklist.sections[0].items[1].toggle()

// 勾选分区中的所有项目
checklist.sections[1].status = .checked

// 获取整个检查单的状态
let status = checklist.status // .unchecked, .partiallyChecked, 或 .checked
```

### 过期时间

```swift
// 创建一个带有自定义过期时间的项目
var item = AChecklistItem(title: "服药")
item.expiresAfter = DateComponents(hour: 4)

// 检查项目是否已过期
let isExpired = item.isExpired(now: Date())
```

## 主要组件

### AChecklist
用于组织分区和项目的主容器。

### AChecklistSection
一组相关的检查项目，可以标记为互斥。

### AChecklistItem
具有标题、详情、完成状态和过期设置的单个任务。

### AChecklistStatus
表示检查单或分区完成状态的枚举：
- `.unchecked`：没有项目被勾选
- `.partiallyChecked`：部分项目被勾选
- `.checked`：所有项目都被勾选

## 贡献

欢迎贡献！请随时提交Pull Request。

## 许可证

AChecklist可在MIT许可证下使用。有关更多信息，请参阅LICENSE文件。