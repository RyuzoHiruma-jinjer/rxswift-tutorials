# RxSwift Tutorials

RxSwiftを段階的に学ぶためのチュートリアルシリーズです。基礎から実践まで、手を動かしながら理解を深めていきます。

## 📚 チュートリアル一覧

| 回 | タイトル | 難易度 | 学ぶ内容 | 記事 | コード |
|----|---------|-------|---------|------|--------|
| 第1回 | 基礎知識編 | ⭐ | Observable, Subject, Disposable | [📝 記事](記事URL) | [📦 Playground](./01-Basics) |
| 第2回 | カウンターアプリ | ⭐ | RxCocoa, MVVM, テスト | [📝 記事](記事URL) | [📦 コード](./02-CounterApp) |
| 第3回 | ToDoリストアプリ | ⭐⭐ | 配列操作, UITableView | [📝 記事](記事URL) | [📦 コード](./03-TodoListApp) |
| 第4回 | リアルタイム検索アプリ | ⭐⭐⭐ | API通信, Scheduler, Hot/Cold | [📝 記事](記事URL) | [📦 コード](./04-SearchApp) |

## 🚀 クイックスタート

### リポジトリをクローン
```bash
git clone https://github.com/YourName/rxswift-tutorials.git
cd rxswift-tutorials
```

### 第1回：Playgroundで基礎を学ぶ
```bash
cd 01-Basics
open RxSwift-Basics.playground
```

詳しくは [01-Basics/README.md](./01-Basics/README.md) を参照してください。

### 第2回以降：アプリを作る
```bash
cd 02-CounterApp/CounterApp
open CounterApp.xcodeproj
```

## 📖 学習の進め方

### ステップ1：記事を読む
まずは各回のZenn記事で概念を理解しましょう。

### ステップ2：コードを動かす
リポジトリのコードを実際に動かして試してみましょう。

### ステップ3：コードを読む
動作を確認したら、コードを読んで理解を深めましょう。

### ステップ4：自分で書く
理解できたら、自分でコードを書いて応用してみましょう。

## 📋 前提知識

このチュートリアルを始める前に、以下の知識があることを推奨します：

- **Swift の基本文法** - 変数、関数、クラス、クロージャなど
- **UIKit の基礎知識** - ViewController、UIButton、UILabelなど
- **Xcode の基本操作** - プロジェクト作成、ビルド、実行

:::tip
初心者の方でも、わからない部分は調べながら進められる内容になっています。
:::

## 🛠 動作環境

- **Xcode**: 15.0 以降
- **iOS**: 15.0 以降
- **Swift**: 5.9 以降
- **macOS**: Monterey 以降

## 📦 使用ライブラリ

- [RxSwift](https://github.com/ReactiveX/RxSwift) 6.7.1
- [RxCocoa](https://github.com/ReactiveX/RxSwift) 6.7.1
- [RxBlocking](https://github.com/ReactiveX/RxSwift) 6.7.1（テスト用）

すべてSwift Package Manager（SPM）でインストールします。

## 🎯 このシリーズで学べること

### 基礎編（第1-2回）
- RxSwiftの基本概念
- Observable, Subject, Disposableの使い方
- RxCocoaを使ったUIバインディング
- MVVMアーキテクチャの基礎
- 単体テストの書き方

### 実践編（第3-4回）
- 配列データの管理
- UITableViewとの連携
- Operatorを使ったデータ加工
- API通信の実装
- Schedulerによるスレッド制御
- Hot/Cold Observableの理解

## 🗂 リポジトリ構成
```
rxswift-tutorials/
│
├── 01-Basics/
│   ├── RxSwift-Basics.playground      # Playgroundファイル
│   └── README.md                       # セットアップ手順
│
├── 02-CounterApp/
│   ├── CounterApp/                     # Xcodeプロジェクト
│   │   ├── ViewModels/
│   │   ├── Views/
│   │   └── Tests/
│   └── README.md
│
├── 03-TodoListApp/
│   ├── TodoListApp/
│   └── README.md
│
├── 04-SearchApp/
│   ├── SearchApp/
│   └── README.md
│
└── README.md（このファイル）
```

## 🤝 コントリビューション

誤字脱字や改善提案は Issue または Pull Request でお願いします。

### 報告する内容の例
- コードが動かない
- 説明がわかりにくい
- より良い実装方法の提案
- タイポの修正

## 📄 ライセンス

MIT License

## ✍️ 著者

[@YourName](https://zenn.dev/yourname)

## 🔗 関連リンク

- [Zenn記事一覧](https://zenn.dev/yourname)
- [RxSwift公式ドキュメント](http://reactivex.io/)
- [RxSwift GitHub](https://github.com/ReactiveX/RxSwift)
- [RxMarbles](https://rxmarbles.com/) - Operatorの視覚化

---

⭐ このリポジトリが役に立ったら、Starをお願いします！
