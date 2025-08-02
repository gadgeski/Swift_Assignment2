# Swift Assignment 2 - ToDo アプリ

## 概要

SwiftUI と UIKit を組み合わせて作成されたシンプルな ToDo アプリです。SQLite データベース（FMDB）を使用してタスクの永続化を行います。

## 主な機能

- ✅ タスクの一覧表示
- ✅ タスクの完了状態の切り替え
- ✅ タスクの削除（スワイプ操作）
- ✅ データの永続化（SQLite）

## 技術スタック

- **UI Framework**: SwiftUI + UIKit
- **データベース**: SQLite (FMDB)
- **アーキテクチャ**: MVC
- **対応プラットフォーム**: iOS 18.5+, macOS 15.5+, visionOS 2.5+

## プロジェクト構成

```
Swift_Assignment2/
├── Swift_Assignment2App.swift          # アプリのエントリーポイント
├── ContentView.swift                   # SwiftUIのメインビュー
├── ViewControllerRepresentable.swift   # UIKit→SwiftUI橋渡し
├── ViewController.swift                # メインのUIKitビューコントローラー
├── DatabaseManager.swift               # データベース操作管理
├── Task.swift                         # タスクのデータモデル
└── Assets.xcassets/                   # アプリのアセット
```

## 主要クラス・構造体

### 1. Task (Task.swift)

```swift
struct Task {
    let id: Int
    var title: String
    var isDone: Bool
}
```

タスクを表現するデータモデル。

### 2. DatabaseManager (DatabaseManager.swift)

SQLite データベースの操作を管理するシングルトンクラス。

**主要メソッド:**

- `addTask(title: String) -> Bool` - 新しいタスクを追加
- `fetchAllTasks() -> [Task]` - すべてのタスクを取得
- `updateTaskStatus(id: Int, isDone: Bool) -> Bool` - タスクの完了状態を更新
- `deleteTask(id: Int) -> Bool` - タスクを削除

### 3. ViewController (ViewController.swift)

UITableView を使用してタスク一覧を表示するメインのビューコントローラー。

**実装されているプロトコル:**

- `UITableViewDataSource` - テーブルビューのデータソース
- `UITableViewDelegate` - テーブルビューのデリゲート

**主要機能:**

- タスク一覧の表示
- セルタップでの完了状態切り替え
- スワイプ削除

### 4. ViewControllerRepresentable (ViewControllerRepresentable.swift)

UIKit の ViewController を SwiftUI で使用するためのラッパー。

## データベース設計

### tasks テーブル

| カラム名 | データ型                          | 説明                           |
| -------- | --------------------------------- | ------------------------------ |
| id       | INTEGER PRIMARY KEY AUTOINCREMENT | タスク ID（自動増分）          |
| title    | TEXT NOT NULL                     | タスクのタイトル               |
| is_done  | INTEGER NOT NULL                  | 完了状態（0: 未完了, 1: 完了） |

## セットアップ手順

### 必要な環境

- Xcode 16.4+
- iOS 18.5+ / macOS 15.5+ / visionOS 2.5+

### インストール手順

1. プロジェクトをクローンまたはダウンロード
2. Xcode でプロジェクトを開く
3. 依存関係（FMDB）が自動的に解決されることを確認
4. ビルド・実行

### 依存関係

- **FMDB** (v2.7.12+): SQLite の Objective-C ラッパー
  - GitHub: https://github.com/ccgus/fmdb

## 使用方法

### 基本操作

1. **タスクの確認**: アプリを起動すると、保存されているタスクが一覧表示されます
2. **完了状態の切り替え**: タスクをタップすると完了/未完了が切り替わります
3. **タスクの削除**: タスクを左にスワイプして削除ボタンをタップします

### データの永続化

- アプリを終了しても、タスクデータは SQLite データベースに保存されます
- データベースファイルは端末の Documents ディレクトリに`tasks.sqlite`として保存されます

## アーキテクチャの特徴

### SwiftUI + UIKit ハイブリッド構成

- **SwiftUI**: アプリの基本構造とエントリーポイント
- **UIKit**: メインの UI 実装（UITableView 使用）
- **ViewControllerRepresentable**: 両者を橋渡し

### シングルトンパターン

`DatabaseManager`はシングルトンパターンで実装されており、アプリ全体で一つのデータベース接続を共有します。

## 注意事項

- 現在の実装では新しいタスクを追加する機能が UI に含まれていません
- エラーハンドリングは基本的なログ出力のみです

## 今後の改善点

- [ ] 新規タスク追加 UI の実装
- [ ] タスク編集機能の追加
- [ ] より詳細なエラーハンドリング
- [ ] タスクの並び替え機能
- [ ] カテゴリ分け機能
