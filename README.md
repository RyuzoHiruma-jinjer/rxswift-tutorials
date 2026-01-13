# RxSwift Tutorials

RxSwiftを段階的に学ぶためのチュートリアルシリーズです。基礎から実践まで、手を動かしながら理解を深めていきます。

## 📚 チュートリアル一覧

| No | タイトル | 難易度 | 学ぶ内容 | 記事 | コード |
|----|---------|-------|---------|------|--------|
| 1 | 基礎知識編 | ⭐ | Observable, Subject, Disposable | [📝](https://zenn.dev/jinjer_techblog/articles/61ce0010c646b3#rxswift%E3%81%A8%E3%81%AF) | [📂](./01-Basics) |
| 2 | ジェネリクス&エクステンション編 | ⭐ | Observable<T>, Reactive Extension | [📝](記事URL) | [📂](./02-Generics-Extensions) |
| 3 | カウンターアプリ | ⭐ | **MVVM**, RxCocoa, テスト | [📝](記事URL) | [📂](./03-CounterApp) |
| 4 | ToDoリストアプリ | ⭐⭐ | **MVVM**, 配列操作, UITableView | [📝](記事URL) | [📂 ](./04-TodoListApp) |
| 5 | リアルタイム検索アプリ | ⭐⭐⭐ | **MVVM**, API通信, Scheduler, Hot/Cold | [📝](記事URL) | [📂](./05-SearchApp) |

## 🚀 クイックスタート

### リポジトリをクローン
```bash
cd [クローンするプロジェクトを配置するディレクトリ]
git clone https://github.com/YourName/rxswift-tutorials.git
cd rxswift-tutorials
```

### 第1回：Playgroundで基礎を学ぶ
```bash
cd 01-Basics
open RxSwift-Basics.playground
```

詳しくは [01-Basics/README.md](./01-Basics/README.md) を参照してください。

### 第2回：ジェネリクスとエクステンションを学ぶ
```bash
cd 02-Generics-Extensions
open Generics-Extensions.playground
```

詳しくは [02-Generics-Extensions/README.md](./02-Generics-Extensions/README.md) を参照してください。

### 第3回以降：アプリを作る
```bash
cd 03-CounterApp/CounterApp
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
> 第3回のカウンターアプリでMVVMの基本を丁寧に解説します。
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

### 基礎編（第1-3回）
- RxSwiftの基本概念（Observable, Subject, Disposable）
- **Observable<T>のジェネリクス**
- **Reactiveエクステンション（rx名前空間）**
- RxCocoaを使ったUIバインディング
- **MVVMアーキテクチャの基礎**
- Input/Outputパターン
- XCTestでの単体テスト（ViewModelのテスト）
- Xibを使ったレイアウト

### 実践編（第4-5回）
- **MVVMでの配列データ管理**
- UITableViewとRxSwiftの連携
- Operatorを使ったデータ加工
- **MVVMでのAPI通信実装**
- **Single/Completable/Maybeなどの特殊なObservable**（APIコールやDB操作で使用）
- Schedulerによるスレッド制御
- Hot/Cold Observableの実践的な理解
- より複雑なViewModelのテスト

> 💡 **Single/Completable/Maybeについて**
> 
> これらは通常のObservableを特定のユースケースに特化させた型です：
> - **Single**: 1つの値またはエラーのみを返す（APIコール、DB取得など）
> - **Completable**: 完了またはエラーのみを通知（保存処理など）
> - **Maybe**: 0個または1個の値、またはエラーを返す（オプショナルなデータ取得）
> 
> 第5回の実践編で、API通信を実装しながら学びます。

## 🗂 リポジトリ構成
```
rxswift-tutorials/
│
├── 01-Basics/
│   ├── RxSwift-Basics.playground      # Playgroundファイル
│   └── README.md                       # セットアップ手順
│
├── 02-Generics-Extensions/
│   ├── Generics-Extensions.playground  # Playgroundファイル
│   └── README.md                       # セットアップ手順
│
├── 03-CounterApp/
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
├── 04-TodoListApp/
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
├── 05-SearchApp/
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
| 第3回 | ⭐ シンプル | MVVMの基本、Input/Output |
| 第4回 | ⭐⭐ 中級 | 配列データの管理、UITableView連携 |
| 第5回 | ⭐⭐⭐ 高度 | API通信、非同期処理、依存性注入 |

## 🎓 学習の流れ

```
第1回: RxSwiftの基本概念
   ↓ Observable, Subject, Disposableを理解
   
第2回: ジェネリクスとエクステンション
   ↓ Observable<T>やrx名前空間の仕組みを理解
   
第3回: カウンターアプリ
   ↓ MVVMの基本とInput/Outputパターンを理解
   
第4回: ToDoリストアプリ
   ↓ 配列データの管理とUITableView連携を理解
   
第5回: リアルタイム検索アプリ
   ↓ API通信とScheduler、Single（APIコールで使う特殊なObservable）を理解
```

**第1-2回でRxSwiftの理論を固めてから、第3回以降でMVVMアプリを実装します。**

> 💡 **なぜ第5回でSingleを学ぶのか？**
> 
> Single/Completable/MaybeはAPIコールやDB操作など、**実際のユースケース**で使われる特殊なObservableです。基礎を固めてから実践で学ぶことで、より深く理解できます。

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

[@ryuzo.hiruma](https://zenn.dev/hiruma)

## 🔗 関連リンク

- [Zenn記事一覧](https://zenn.dev/hiruma)
- [RxSwift公式ドキュメント](http://reactivex.io/)
- [RxSwift GitHub](https://github.com/ReactiveX/RxSwift)
- [RxMarbles](https://rxmarbles.com/) - Operatorの視覚化

---

⭐ このリポジトリが役に立ったら、Starをお願いします!
