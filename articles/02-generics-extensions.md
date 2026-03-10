---
title: "【RxSwift入門】②ジェネリクス&エクステンションを理解する"
emoji: "📱"
type: "tech"
topics: ["iOS", "Swift", "MVVM", "RxSwift"]
published: false
---

## はじめに

[前回の記事](リンク)では、RxSwiftの基本概念（Observable、Subject、Disposable）を学びました。
今回は、RxSwiftをより深く理解するために欠かせない **ジェネリクス** と **Reactive Extension** の仕組みを解説します。

「`Observable<Int>`の`<Int>`って何？」「`label.rx.text`の`.rx`はどういう仕組み？」といった疑問を解消し、**自分で`.rx`を拡張できるレベル**を目指します。

:::message
📂 サンプルコード
この記事で使用しているコードの完全版は[GitHubリポジトリ](リポジトリURL)で公開しています。
:::

## この記事で学ぶこと

今回の記事では、以下の概念を学びます：

- **ジェネリクスの基礎** - `<T>`で型を抽象化する仕組み
- **Observable\<T>のジェネリクス** - 型安全なストリーム
- **Reactive Extension** - `.rx`名前空間の仕組み
- **RxCocoaのUI拡張** - `UILabel.rx.text`などの使い方
- **カスタムReactive Extension** - 独自の`.rx`プロパティの作り方

:::message
前回の記事で学んだ Observable、Subject、Disposable の知識を前提としています。
まだの方は[第1回の記事](リンク)を先にお読みください。
:::

## 1. ジェネリクスの基礎

### ジェネリクスとは

ジェネリクスは **「型をパラメータとして受け取る」** 仕組みです。
同じ処理を異なる型に対して使い回すことができます。

RxSwiftの`Observable<T>`を理解するためには、まずSwiftのジェネリクスを押さえる必要があります。

### ジェネリクスがない場合の問題

型ごとに同じような関数を書く必要があります：

```swift
// Int用
func printInt(_ value: Int) {
    print("値: \(value)")
}

// String用
func printString(_ value: String) {
    print("値: \(value)")
}

printInt(42)       // 値: 42
printString("Hi")  // 値: Hi
```

### ジェネリクスで解決

`<T>`を使えば、1つの関数であらゆる型に対応できます：

```swift
func printValue<T>(_ value: T) {
    print("値: \(value)")
}

printValue(42)      // T = Int  → 値: 42
printValue("Hello") // T = String → 値: Hello
printValue(3.14)    // T = Double → 値: 3.14
```

ここで`T`は **型パラメータ** と呼ばれ、実際に使うときに具体的な型が決まります。

### ジェネリックなクラス

クラスにもジェネリクスを使えます：

```swift
class Box<T> {
    let value: T

    init(_ value: T) {
        self.value = value
    }
}

let intBox = Box(42)           // Box<Int>
let stringBox = Box("RxSwift") // Box<String>
```

:::message
この`Box<T>`の考え方が、RxSwiftの`Observable<T>`にそのまま当てはまります。
`Observable<T>`は「型`T`の値が流れる箱（ストリーム）」です。
:::

### 型制約

型パラメータに制約をつけることもできます：

```swift
// T が Numeric に準拠している場合のみ使える
func sum<T: Numeric>(_ a: T, _ b: T) -> T {
    return a + b
}

sum(3, 5)       // 8（Int）
sum(1.5, 2.5)   // 4.0（Double）
// sum("A", "B") // コンパイルエラー！
```

## 2. Observable\<T> のジェネリクス

### 型パラメータの役割

`Observable<T>`の`T`は **「ストリームを流れるデータの型」** を表します。

```
Observable<Int>      → 整数が流れるストリーム
Observable<String>   → 文字列が流れるストリーム
Observable<Bool>     → 真偽値が流れるストリーム
Observable<[Todo]>   → Todoの配列が流れるストリーム
Observable<User>     → ユーザー情報が流れるストリーム
```

コードで確認してみましょう：

```swift
// Observable<Int> → 整数が流れるストリーム
let intStream: Observable<Int> = Observable.of(1, 2, 3)

// Observable<String> → 文字列が流れるストリーム
let stringStream: Observable<String> = Observable.of("A", "B", "C")

intStream.subscribe(onNext: { value in
    print("Int:", value)
})
// 出力:
// Int: 1
// Int: 2
// Int: 3
```

### 型安全性のメリット

ジェネリクスにより、**コンパイル時に型の不整合を検出**できます：

```swift
let numberStream = Observable.of(10, 20, 30) // Observable<Int>

numberStream.subscribe(onNext: { (value: Int) in
    let doubled = value * 2  // 安全に計算できる
    print("2倍:", doubled)
})
// 出力:
// 2倍: 20
// 2倍: 40
// 2倍: 60
```

もし型安全でなかったら、`String`が流れてきたときに`value * 2`でクラッシュしてしまいます。
ジェネリクスのおかげで、そのようなバグをコンパイル時に防げます。

### map による型変換

`map`を使うと、ストリームの型を変換できます：

```swift
// Observable<Int> → Observable<String> に変換
let numbers = Observable.of(1, 2, 3)

let strings: Observable<String> = numbers.map { number in
    return "番号: \(number)"
}

strings.subscribe(onNext: { value in
    print(value)
})
// 出力:
// 番号: 1
// 番号: 2
// 番号: 3
```

```
  Observable<Int>          map            Observable<String>
 ┌─────────────┐    ┌──────────────┐    ┌──────────────────┐
 │  1, 2, 3    │ →  │ "番号: \($0)" │ →  │ "番号: 1" ...    │
 └─────────────┘    └──────────────┘    └──────────────────┘
```

:::message
`map`は第3回以降で詳しく解説する**Operator**の一つです。
ここでは「型変換ができる」ことだけ理解しておいてください。
:::

### カスタム型を流す

独自に定義した構造体もストリームに流せます：

```swift
struct User {
    let name: String
    let age: Int
}

// Observable<User> → ユーザー情報が流れるストリーム
let userStream = Observable.of(
    User(name: "田中", age: 25),
    User(name: "佐藤", age: 30),
    User(name: "鈴木", age: 28)
)

userStream
    .map { "\($0.name)さん（\($0.age)歳）" }
    .subscribe(onNext: { print($0) })
// 出力:
// 田中さん（25歳）
// 佐藤さん（30歳）
// 鈴木さん（28歳）
```

### Subject/Relay もジェネリクス

前回学んだSubjectやRelayも同様にジェネリクスです：

```swift
// BehaviorRelay<[String]> → 文字列の配列が流れるストリーム
let todoList = BehaviorRelay<[String]>(value: [])

todoList.subscribe(onNext: { items in
    print("ToDoリスト: \(items)")
})
// 出力: ToDoリスト: []

todoList.accept(todoList.value + ["買い物"])
todoList.accept(todoList.value + ["掃除"])
// 出力:
// ToDoリスト: ["買い物"]
// ToDoリスト: ["買い物", "掃除"]
```

## 3. Reactive Extension の仕組み

### rx とは何か

RxCocoaを使うと、`label.rx.text`のように`.rx`でアクセスできます。
この`.rx`は何者なのでしょうか？

```swift
let label = UILabel()

// label.rx は Reactive<UILabel> 型のオブジェクト
print(type(of: label.rx))
// 出力: Reactive<UILabel>
```

`.rx`は **Reactive\<Base>型のオブジェクト** を返すプロパティです。

### ReactiveCompatible プロトコル

`.rx`を使えるのは、`ReactiveCompatible`プロトコルに準拠しているクラスだけです。

```swift
// RxSwift 内部での定義（簡略化）
public protocol ReactiveCompatible {
    associatedtype ReactiveBase
    var rx: Reactive<ReactiveBase> { get }
}
```

**NSObjectのサブクラスはデフォルトで準拠**しているため、UILabel、UIButton、UITextFieldなどすべてのUIKitコンポーネントで`.rx`が使えます。

```swift
let button = UIButton()
let textField = UITextField()

print(type(of: button.rx))     // Reactive<UIButton>
print(type(of: textField.rx))  // Reactive<UITextField>
```

### Reactive\<Base> 構造体

`Reactive<Base>`の内部構造はシンプルです：

```swift
// RxSwift 内部での定義（簡略化）
public struct Reactive<Base> {
    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }
}
```

つまり`label.rx`は、`label`自体を`base`プロパティとして保持する`Reactive<UILabel>`オブジェクトです。

### 全体の流れ

`label.rx.text`がどう動くかをまとめると：

```
label.rx.text の仕組み:

┌──────────┐     .rx      ┌──────────────────┐     .text     ┌──────────────┐
│  UILabel  │ ──────────→ │ Reactive<UILabel> │ ──────────→  │ Binder<...>  │
└──────────┘              └──────────────────┘               └──────────────┘
                           ReactiveCompatible                 Extension で
                           プロトコルが提供                     定義
```

1. `label.rx` → `ReactiveCompatible`プロトコルが`Reactive<UILabel>`オブジェクトを生成
2. `.text` → `Reactive<UILabel>`のextensionで定義されたプロパティにアクセス
3. 結果として`Binder<String?>`が返され、Observableからバインドできる

## 4. RxCocoa の UI 拡張

RxCocoaは、UIKitコンポーネントに対して多くのReactive Extensionを提供しています。
代表的なものを見ていきましょう。

### UILabel.rx.text - テキストをバインド

```swift
let nameLabel = UILabel()
let disposeBag = DisposeBag()

let nameRelay = BehaviorRelay<String>(value: "初期値")

nameRelay
    .bind(to: nameLabel.rx.text)
    .disposed(by: disposeBag)

print(nameLabel.text) // "初期値"

nameRelay.accept("更新されました")
print(nameLabel.text) // "更新されました"
```

:::message
`bind(to:)`は`subscribe`の特殊バージョンです。Observableの値をBinderに直接流し込みます。
エラーイベントが発生するとデバッグ時にクラッシュするため、エラーが発生しないストリームで使うのが基本です。
:::

### UITextField.rx.text - 入力値を監視

```swift
let searchField = UITextField()

searchField.rx.text.orEmpty
    .subscribe(onNext: { text in
        print("入力テキスト:", text)
    })
    .disposed(by: disposeBag)
```

:::message
`.orEmpty`は`String?`を`String`に変換するオペレーターです。
`nil`の場合は空文字列`""`になります。
:::

### UIButton.rx.tap - タップイベント

```swift
let button = UIButton()

button.rx.tap
    .subscribe(onNext: {
        print("ボタンがタップされました")
    })
    .disposed(by: disposeBag)
```

`rx.tap`は`Observable<Void>`を返します。値はなく、「タップされた」というイベントだけが流れます。

### UISwitch.rx.isOn - スイッチの状態

```swift
let toggle = UISwitch()

toggle.rx.isOn
    .subscribe(onNext: { isOn in
        print("スイッチ:", isOn ? "ON" : "OFF")
    })
    .disposed(by: disposeBag)
```

### 主なRxCocoa UI拡張一覧

| UIコンポーネント | プロパティ | 型 | 用途 |
|:--|:--|:--|:--|
| UILabel | rx.text | Binder\<String?> | テキスト設定 |
| UITextField | rx.text | ControlProperty\<String?> | テキスト入出力 |
| UIButton | rx.tap | ControlEvent\<Void> | タップ検知 |
| UISwitch | rx.isOn | ControlProperty\<Bool> | ON/OFF状態 |
| UISlider | rx.value | ControlProperty\<Float> | スライダー値 |
| UISegmentedControl | rx.selectedSegmentIndex | ControlProperty\<Int> | 選択セグメント |
| UIDatePicker | rx.date | ControlProperty\<Date> | 選択日付 |
| UIActivityIndicatorView | rx.isAnimating | Binder\<Bool> | インジケーター制御 |

### bind(to:) でデータフローを作る

`bind(to:)`を使うと、ストリームの値をUIに自動反映できます：

```swift
let inputField = UITextField()
let outputLabel = UILabel()

// テキストフィールドの入力 → ラベルに自動反映
inputField.rx.text
    .bind(to: outputLabel.rx.text)
    .disposed(by: disposeBag)
```

```
 ┌──────────────┐    rx.text     ┌─────────────────┐    bind(to:)    ┌───────────┐
 │ UITextField   │ ──────────→  │ Observable<String?> │ ──────────→  │  UILabel   │
 │ (入力)        │              │                   │               │  (出力)    │
 └──────────────┘              └─────────────────┘               └───────────┘
```

## 5. カスタム Reactive Extension の作り方

### 独自クラスに .rx を追加する

自分で作ったクラスにも`.rx`を追加できます。必要な手順は2つだけ：

1. `ReactiveCompatible`に準拠させる
2. `Reactive` の `where Base:` でextensionを追加する

```swift
// ① カスタムクラスの定義
class Counter {
    var count: Int = 0

    func increment() {
        count += 1
    }
}

// ② ReactiveCompatible に準拠させる
extension Counter: ReactiveCompatible {}

// ③ Reactive<Counter> に拡張を追加
extension Reactive where Base: Counter {
    var currentCount: Observable<Int> {
        return Observable.just(base.count)
    }
}

// 使い方
let counter = Counter()
counter.increment()
counter.increment()

counter.rx.currentCount
    .subscribe(onNext: { count in
        print("カウント:", count)  // カウント: 2
    })
```

### UIView にカスタムプロパティを追加する

既存のUIKitクラスに新しいReactive Extensionを追加することもできます：

```swift
extension Reactive where Base: UIView {
    var backgroundColor: Binder<UIColor> {
        return Binder(self.base) { view, color in
            view.backgroundColor = color
        }
    }
}

// 使い方
let colorRelay = BehaviorRelay<UIColor>(value: .white)
colorRelay
    .bind(to: myView.rx.backgroundColor)
    .disposed(by: disposeBag)

colorRelay.accept(.red) // 背景色が赤に変わる
```

### Binder の仕組み

`Binder`は **「値を受け取ってUIに反映する」** ための型です。

```swift
Binder<Input>(対象オブジェクト) { 対象, 値 in
    // 対象に値を設定する処理
}
```

**Binderの特徴:**
- エラーイベントを受け取らない（UIの更新でエラーは不要）
- メインスレッドで実行される（UIの更新はメインスレッド必須）
- `[weak self]`が不要（内部で弱参照を使っている）

```swift
// 例: UILabelのフォントサイズをバインドできるようにする
extension Reactive where Base: UILabel {
    var fontSize: Binder<CGFloat> {
        return Binder(self.base) { label, size in
            label.font = UIFont.systemFont(ofSize: size)
        }
    }
}
```

### カスタム Reactive Extension の使いどころ

```
カスタム Reactive Extension が有効な場面:

├─ 同じUI更新処理を何度も書いている
│   → Binder にまとめてバインド可能にする
│
├─ 既存のUIコンポーネントに足りないプロパティがある
│   → rx.backgroundColor, rx.fontSize など
│
├─ 独自クラスをRxのストリームに組み込みたい
│   → ReactiveCompatible に準拠させる
│
└─ ViewModelとViewの接続を簡潔にしたい
    → カスタムBinderで1行でバインド
```

## 6. 実践的な組み合わせ - ViewModel風の構造

ここまで学んだジェネリクスとReactive Extensionを組み合わせて、次回のカウンターアプリにつながる**ViewModel風の構造**を作ってみましょう。

### ViewModel の基本構造

```swift
class SimpleViewModel {
    // Input（View → ViewModel）
    let inputText = BehaviorRelay<String>(value: "")

    // Output（ViewModel → View）
    let outputText: Observable<String>
    let characterCount: Observable<Int>
    let isValid: Observable<Bool>

    init() {
        outputText = inputText
            .map { "入力: \($0)" }

        characterCount = inputText
            .map { $0.count }

        isValid = inputText
            .map { $0.count >= 3 }
    }
}
```

ここでのポイント：
- **Input**: `BehaviorRelay<String>` — Viewから値を受け取る
- **Output**: `Observable<String>`, `Observable<Int>`, `Observable<Bool>` — Viewに値を流す
- **ジェネリクス**: 各ストリームの型が明確で、型安全

### UI とのバインディング

```swift
let viewModel = SimpleViewModel()
let disposeBag = DisposeBag()

let displayLabel = UILabel()
let validationLabel = UILabel()

// Output → UI にバインド
viewModel.outputText
    .bind(to: displayLabel.rx.text)
    .disposed(by: disposeBag)

viewModel.isValid
    .map { $0 ? "✓ OK" : "✗ 3文字以上入力してください" }
    .bind(to: validationLabel.rx.text)
    .disposed(by: disposeBag)

// Input ← UI から値を流す
viewModel.inputText.accept("Rx")
// displayLabel.text → "入力: Rx"
// validationLabel.text → "✗ 3文字以上入力してください"

viewModel.inputText.accept("RxSwift")
// displayLabel.text → "入力: RxSwift"
// validationLabel.text → "✓ OK"
```

```
 ┌─────────────┐                              ┌──────────────────┐
 │   View      │    Input（BehaviorRelay）     │   ViewModel      │
 │             │  ──────────────────────────→  │                  │
 │ UITextField │    accept("RxSwift")          │  map, filter     │
 │ UIButton    │                              │  データ加工        │
 │             │    Output（Observable）        │                  │
 │ UILabel     │  ←──────────────────────────  │                  │
 └─────────────┘    bind(to: rx.text)          └──────────────────┘
```

:::message
この Input/Output パターンは、第3回のカウンターアプリで本格的に実装します。
ここでは「ジェネリクスとReactive Extensionがどう連携するか」を感じ取ってください。
:::

## まとめ

この記事では、RxSwiftをより深く理解するための仕組みを学びました。

### 学んだこと

1. **ジェネリクスの基礎**
   - `<T>`で型を抽象化する仕組み
   - ジェネリック関数、ジェネリッククラス、型制約

2. **Observable\<T> のジェネリクス**
   - `T`はストリームを流れるデータの型
   - コンパイル時の型安全性
   - `map`による型変換（`Observable<Int>` → `Observable<String>`）
   - カスタム型（`User`, `Todo`）もストリームに流せる

3. **Reactive Extension の仕組み**
   - `.rx`は`Reactive<Base>`オブジェクトを返すプロパティ
   - `ReactiveCompatible`プロトコルが`.rx`を提供
   - NSObjectのサブクラスはデフォルトで`.rx`が使える

4. **RxCocoa の UI 拡張**
   - `UILabel.rx.text`, `UIButton.rx.tap`, `UITextField.rx.text`など
   - `bind(to:)`でストリームをUIに直接バインド
   - `.orEmpty`で`String?`を`String`に変換

5. **カスタム Reactive Extension**
   - `ReactiveCompatible`に準拠させて`.rx`を追加
   - `Binder`でUIへの値設定を抽象化
   - `extension Reactive where Base:`で拡張を定義

6. **実践的な組み合わせ**
   - ViewModel の Input/Output パターン
   - ジェネリクスによる型安全なデータフロー
   - `bind(to:)`によるUIバインディング

### 次のステップ

基礎概念とジェネリクス・エクステンションの仕組みを理解したら、次はいよいよ実際のアプリを作ります！

## 今後の学習ロードマップ

### 第3回：カウンターアプリ ⭐

- **RxCocoa の基礎** - UIKitとの連携
- **基本的な Operator** - map, bind(to:)
- **MVVM パターン** - ViewとViewModelの分離
- **テストの書き方** - RxSwiftアプリのテスト

### 第4回：ToDoリストアプリ ⭐⭐

- **配列の管理** - BehaviorRelay<[Todo]>
- **Operator の活用** - filter, map, scan
- **UITableView との連携**
- **複数のイベントを組み合わせる**

### 第5回：リアルタイム検索アプリ ⭐⭐⭐

- **高度な Operator** - debounce, distinctUntilChanged, flatMap
- **API通信** - URLSession + RxSwift
- **Scheduler** - バックグラウンド処理とUI更新
- **Hot vs Cold Observable** - 詳細解説

### 第6回以降

- タイマー/ストップウォッチアプリ - 時間ベースのObservable
- フォームバリデーションアプリ - 複数条件のリアルタイムチェック
- 天気アプリ - エラーハンドリングと位置情報連携

## 参考資料

- [ReactiveX公式ドキュメント](http://reactivex.io/)
- [RxSwift GitHub](https://github.com/ReactiveX/RxSwift)
- [RxMarbles](https://rxmarbles.com/) - Operatorの視覚化

:::message
この記事がRxSwiftを学ぶ助けになれば幸いです。次回のカウンターアプリ編で、MVVMパターンを実際に手を動かしながら学びましょう！
:::
