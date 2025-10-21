# RxSwift Tutorials

RxSwiftを段階的に学ぶためのチュートリアルシリーズです。基礎から実践まで、手を動かしながら理解を深めていきます。

## 📚 チュートリアル一覧

| 回 | タイトル | 難易度 | 学ぶ内容 | 記事 | コード |
|----|---------|-------|---------|------|--------|
| 第1回 | 基礎知識編 | ⭐ | Observable, Subject, Disposable | [📝 記事](記事URL) | [📦 Playground](./01-Basics) |
| 第2回 | カウンターアプリ | ⭐ | **MVVM**, RxCocoa, テスト | [📝 記事](記事URL) | [📦 コード](./02-CounterApp) |
| 第3回 | ToDoリストアプリ | ⭐⭐ | **MVVM**, 配列操作, UITableView | [📝 記事](記事URL) | [📦 コード](./03-TodoListApp) |
| 第4回 | リアルタイム検索アプリ | ⭐⭐⭐ | **MVVM**, API通信, Scheduler, Hot/Cold | [📝 記事](記事URL) | [📦 コード](./04-SearchApp) |

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

**特にMVVMの構造に注目:**
- `ViewModels/` - ビジネスロジック
- `Views/` - UI（ViewController, Xib）
- `Tests/` - ViewModelの単体テスト

### ステップ4：自分で書く
理解できたら、自分でコードを書いて応用してみましょう。

> 💡 **MVVMが初めての方へ**
> 
> 第2回のカウンターアプリでMVVMの基本を丁寧に解説します。
> まずは小さなアプリでMVVMの構造を理解してから、徐々に複雑なアプリに進みましょう。

## 📋 前提知識

このチュートリアルを始める前に、以下の知識があることを推奨します：

- **Swift の基本文法** - 変数、関数、クラス、クロージャなど
- **UIKit の基礎知識** - ViewController、UIButton、UILabelなど
- **Xcode の基本操作** - プロジェクト作成、ビルド、実行

> 💡 **初心者の方へ**
> 
> 初心者の方でも、わからない部分は調べながら進められる内容になっています。

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

### アーキテクチャ
このシリーズでは、**すべてのアプリをMVVM（Model-View-ViewModel）形式**で実装します。

**MVVMとは？**
- **Model**: データとビジネスロジック
- **View**: UI表示（ViewController, Xib）
- **ViewModel**: ViewとModelの仲介役

**MVVMのメリット:**
- Viewとロジックの分離
- テストが書きやすい
- RxSwiftとの相性が良い
- 保守性・拡張性が高い

### 基礎編（第1-2回）
- RxSwiftの基本概念（Observable, Subject, Disposable）
- RxCocoaを使ったUIバインディング
- **MVVMアーキテクチャの基礎**
- Input/Outputパターン
- XCTestでの単体テスト（ViewModelのテスト）
- Xibを使ったレイアウト

### 実践編（第3-4回）
- **MVVMでの配列データ管理**
- UITableViewとRxSwiftの連携
- Operatorを使ったデータ加工
- **MVVMでのAPI通信実装**
- Schedulerによるスレッド制御
- Hot/Cold Observableの実践的な理解
- より複雑なViewModelのテスト

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
│   │   ├── ViewModels/                # ⭐ ViewModel層
│   │   │   └── CounterViewModel.swift
│   │   ├── Views/                     # ⭐ View層
│   │   │   ├── CounterViewController.swift
│   │   │   └── CounterViewController.xib
│   │   └── CounterAppTests/           # ⭐ テスト
│   │       └── CounterViewModelTests.swift
│   └── README.md
│
├── 03-TodoListApp/
│   ├── TodoListApp/                    # Xcodeプロジェクト
│   │   ├── Models/                    # ⭐ Model層
│   │   │   └── Todo.swift
│   │   ├── ViewModels/                # ⭐ ViewModel層
│   │   │   └── TodoListViewModel.swift
│   │   ├── Views/                     # ⭐ View層
│   │   │   ├── TodoListViewController.swift
│   │   │   └── TodoListViewController.xib
│   │   └── TodoListAppTests/          # ⭐ テスト
│   │       └── TodoListViewModelTests.swift
│   └── README.md
│
├── 04-SearchApp/
│   ├── SearchApp/                      # Xcodeプロジェクト
│   │   ├── Models/                    # ⭐ Model層
│   │   │   └── SearchResult.swift
│   │   ├── ViewModels/                # ⭐ ViewModel層
│   │   │   └── SearchViewModel.swift
│   │   ├── Views/                     # ⭐ View層
│   │   │   ├── SearchViewController.swift
│   │   │   └── SearchViewController.xib
│   │   ├── Services/                  # ⭐ APIクライアント
│   │   │   └── APIClient.swift
│   │   └── SearchAppTests/            # ⭐ テスト
│   │       └── SearchViewModelTests.swift
│   └── README.md
│
└── README.md（このファイル）
```

**⭐ MVVM構成のポイント:**
- `Models/` - データ構造とビジネスロジック
- `ViewModels/` - UIロジック（RxSwiftでデータを流す）
- `Views/` - UI表示（ViewControllerとXib）
- `Tests/` - ViewModelの単体テスト

## 🏗 MVVMアーキテクチャについて

このシリーズでは、**すべてのアプリをMVVM形式で実装**します。

### MVVMの基本構造
```
┌─────────────┐
│    View     │  UIViewController + Xib
│  (画面表示)  │  ・ボタンタップをViewModelに伝える
│             │  ・ViewModelのデータをUIに反映
└──────┬──────┘
       │ rx.tap / bind(to:)
       ↓
┌─────────────┐
│  ViewModel  │  ビジネスロジック
│ (データ処理) │  ・Inputを受け取る（PublishRelay）
│             │  ・Outputを流す（Observable）
└──────┬──────┘
       │
       ↓
┌─────────────┐
│    Model    │  データ構造
│  (データ)    │  ・Todo, User などの構造体
└─────────────┘
```

### RxSwift + MVVMのメリット

1. **責務の分離**
   - View: UIの表示のみ
   - ViewModel: ロジック
   - Model: データ

2. **テストが容易**
   - ViewModelを単体でテスト可能
   - UIに依存しないテスト

3. **宣言的なコード**
   - データの流れが明確
   - バグが見つけやすい

4. **拡張性**
   - 機能追加が容易
   - コードの再利用性が高い

### Input/Outputパターン

このシリーズでは、ViewModelを以下のパターンで実装します：
```swift
class CounterViewModel {
    // MARK: - Inputs（ViewからViewModelへ）
    let incrementTapped = PublishRelay<Void>()
    let decrementTapped = PublishRelay<Void>()
    
    // MARK: - Outputs（ViewModelからViewへ）
    let count: Observable<Int>
    let countText: Observable<String>
    
    // MARK: - Private
    private let countRelay = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()
    
    init() {
        // ロジックの実装
    }
}
```

このパターンにより：
- ✅ 入力と出力が明確
- ✅ カプセル化を保てる
- ✅ テストしやすい

### 段階的に学ぶMVVM

| 回 | MVVMの複雑さ | 学ぶポイント |
|----|------------|------------|
| 第2回 | ⭐ シンプル | MVVMの基本、Input/Output |
| 第3回 | ⭐⭐ 中級 | 配列データの管理、UITableView連携 |
| 第4回 | ⭐⭐⭐ 高度 | API通信、非同期処理、依存性注入 |

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
