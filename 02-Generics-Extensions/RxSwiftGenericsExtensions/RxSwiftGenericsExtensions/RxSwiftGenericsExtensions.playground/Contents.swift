//: # RxSwift ジェネリクス&エクステンション編
//:
//: この Playground では、RxSwift をより深く理解するために
//: ジェネリクスと Reactive Extension の仕組みを学びます。
//:
//: **実行方法:**
//: - 全体を実行: `Cmd + Shift + Return`
//: - コンソール表示: `Cmd + Shift + Y`

import RxSwift
import RxCocoa // BehaviorRelay, UIKit拡張のため
import UIKit

//: ---
//: ## 1. ジェネリクスの基礎
//:
//: ジェネリクスは「型をパラメータとして受け取る」仕組みです。
//: RxSwift の Observable<T> を理解するための前提知識として、まずは Swift のジェネリクスを確認しましょう。

print("=== 1. ジェネリクスの基礎 ===\n")

//: ### 1-1. ジェネリクスがない場合の問題

print("--- ジェネリクスがない場合の問題 ---")

// 型ごとに同じ処理を書く必要がある
func printInt(_ value: Int) {
    print("値: \(value)")
}

func printString(_ value: String) {
    print("値: \(value)")
}

printInt(42)
printString("Hello")
// 出力:
// 値: 42
// 値: Hello

//: ### 1-2. ジェネリクスで解決

print("\n--- ジェネリクスで解決 ---")

// T は「型パラメータ」- どんな型でも受け取れる
func printValue<T>(_ value: T) {
    print("値: \(value)")
}

printValue(42)         // T = Int
printValue("Hello")    // T = String
printValue(3.14)       // T = Double
printValue(true)       // T = Bool
// 出力:
// 値: 42
// 値: Hello
// 値: 3.14
// 値: true

//: ### 1-3. ジェネリックなクラス

print("\n--- ジェネリックなクラス ---")

// T は「箱の中身の型」を表す
class Box<T> {
    let value: T

    init(_ value: T) {
        self.value = value
    }

    func describe() -> String {
        return "Box(\(value))"
    }
}

let intBox = Box(42)           // Box<Int>
let stringBox = Box("RxSwift") // Box<String>

print(intBox.describe())       // Box(42)
print(stringBox.describe())    // Box(RxSwift)
// 出力:
// Box(42)
// Box(RxSwift)

//: ### 1-4. 型制約（where / プロトコル準拠）

print("\n--- 型制約 ---")

// T が Numeric に準拠している場合のみ使える
func sum<T: Numeric>(_ a: T, _ b: T) -> T {
    return a + b
}

print("Int の合計:", sum(3, 5))       // 8
print("Double の合計:", sum(1.5, 2.5)) // 4.0
// print(sum("A", "B"))  // ← コンパイルエラー！String は Numeric ではない

//: ### 💪 練習問題1
//: ジェネリクスを使って、2つの値を入れ替える関数 `swapValues<T>` を作成してみましょう。
//: ヒント: inout パラメータを使います。

print("\n--- 練習問題1 ---")
// ここにコードを書いてみよう!


//: ---
//: ## 2. Observable<T> のジェネリクス
//:
//: RxSwift の Observable は `Observable<T>` というジェネリッククラスです。
//: T は「ストリームを流れるデータの型」を表します。

print("\n\n=== 2. Observable<T> のジェネリクス ===\n")

//: ### 2-1. 型パラメータの役割

print("--- 型パラメータの役割 ---")

// Observable<Int> → 整数が流れるストリーム
let intStream: Observable<Int> = Observable.of(1, 2, 3)

// Observable<String> → 文字列が流れるストリーム
let stringStream: Observable<String> = Observable.of("A", "B", "C")

// Observable<Bool> → 真偽値が流れるストリーム
let boolStream: Observable<Bool> = Observable.of(true, false, true)

intStream.subscribe(onNext: { value in
    print("Int:", value)
})

stringStream.subscribe(onNext: { value in
    print("String:", value)
})

boolStream.subscribe(onNext: { value in
    print("Bool:", value)
})
// 出力:
// Int: 1
// Int: 2
// Int: 3
// String: A
// String: B
// String: C
// Bool: true
// Bool: false
// Bool: true

//: ### 2-2. 型安全性のメリット

print("\n--- 型安全性のメリット ---")

let numberStream = Observable.of(10, 20, 30) // Observable<Int>

// コンパイラが型をチェックしてくれる
numberStream.subscribe(onNext: { (value: Int) in
    // value は確実に Int 型
    let doubled = value * 2  // 安全に計算できる
    print("2倍:", doubled)
})
// 出力:
// 2倍: 20
// 2倍: 40
// 2倍: 60

// もし型安全でなかったら...
// let result = value * 2  // ← String が来たらクラッシュ！
// ジェネリクスのおかげでコンパイル時にエラーを検出できる

//: ### 2-3. map による型変換

print("\n--- map による型変換 ---")

// Observable<Int> → Observable<String> に変換
let numbers = Observable.of(1, 2, 3, 4, 5)

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
// 番号: 4
// 番号: 5

//: ### 2-4. カスタム型を流す

print("\n--- カスタム型を流す ---")

// 独自の構造体を定義
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

// User型から必要な情報を抽出
userStream
    .map { user in
        return "\(user.name)さん（\(user.age)歳）"
    }
    .subscribe(onNext: { description in
        print(description)
    })
// 出力:
// 田中さん（25歳）
// 佐藤さん（30歳）
// 鈴木さん（28歳）

//: ### 2-5. Subject/Relay もジェネリクス

print("\n--- Subject/Relay もジェネリクス ---")

// BehaviorRelay<[String]> → 文字列の配列が流れるストリーム
let todoList = BehaviorRelay<[String]>(value: [])

todoList.subscribe(onNext: { items in
    print("ToDoリスト: \(items)")
})
// 出力: ToDoリスト: []

// 配列に追加
todoList.accept(todoList.value + ["買い物"])
todoList.accept(todoList.value + ["掃除"])
// 出力:
// ToDoリスト: ["買い物"]
// ToDoリスト: ["買い物", "掃除"]

//: ### 💪 練習問題2
//: 以下の構造体 Product を定義し、Observable<Product> を作成してください。
//: map を使って Observable<String> に変換し、「商品名: ○○（¥○○）」の形式で出力してください。
//:
//: ```
//: struct Product {
//:     let name: String
//:     let price: Int
//: }
//: ```

print("\n--- 練習問題2 ---")
// ここにコードを書いてみよう!


//: ---
//: ## 3. Reactive Extension の仕組み
//:
//: RxCocoa では `label.rx.text` のように `.rx` でアクセスする仕組みがあります。
//: この仕組みを「Reactive Extension」と呼びます。
//: ここでは、その内部構造を理解しましょう。

print("\n\n=== 3. Reactive Extension の仕組み ===\n")

//: ### 3-1. rx とは何か

print("--- rx とは何か ---")

// UILabel に .rx でアクセスできる
let label = UILabel()

// label.rx は Reactive<UILabel> 型のオブジェクト
// Reactive<UILabel> が .text プロパティを持っている
print("label.rx の型:", type(of: label.rx))
// 出力: label.rx の型: Reactive<UILabel>

//: ### 3-2. ReactiveCompatible プロトコル

print("\n--- ReactiveCompatible プロトコル ---")

// .rx を使えるのは ReactiveCompatible に準拠しているクラスだけ
// NSObject のサブクラスはデフォルトで準拠している

// このプロトコルは内部でこのように定義されている：
// public protocol ReactiveCompatible {
//     associatedtype ReactiveBase
//     static var rx: Reactive<ReactiveBase>.Type { get }
//     var rx: Reactive<ReactiveBase> { get }
// }

// NSObject は ReactiveCompatible に準拠しているので、
// UILabel, UIButton, UITextField などすべての UIKit コンポーネントで
// .rx が使える

let button = UIButton()
let textField = UITextField()

print("button.rx の型:", type(of: button.rx))
print("textField.rx の型:", type(of: textField.rx))
// 出力:
// button.rx の型: Reactive<UIButton>
// textField.rx の型: Reactive<UITextField>

//: ### 3-3. Reactive<Base> 構造体

print("\n--- Reactive<Base> 構造体 ---")

// Reactive<Base> は以下のように定義されている：
// public struct Reactive<Base> {
//     public let base: Base
//     public init(_ base: Base) { self.base = base }
// }

// つまり label.rx.text は:
// 1. label.rx → Reactive<UILabel> オブジェクトを生成
// 2. .text → Reactive<UILabel> の extension で定義されたプロパティ

// label.rx.base で元のオブジェクトにアクセスできる
let label2 = UILabel()
label2.text = "テスト"
print("rx.base.text:", label2.rx.base.text ?? "nil")
// 出力: rx.base.text: テスト

//: ### 3-4. 全体像のまとめ
//:
//: ```
//: label.rx.text の仕組み:
//:
//: ┌──────────┐     .rx      ┌──────────────────┐     .text     ┌─────────────┐
//: │  UILabel  │ ──────────→ │ Reactive<UILabel> │ ──────────→  │ Binder<...> │
//: └──────────┘              └──────────────────┘               └─────────────┘
//:                           ReactiveCompatible                  Extension で
//:                           プロトコルが提供                     定義
//: ```

//: ### 💪 練習問題3
//: UISwitch を作成し、 .rx の型を確認してみましょう。
//: また、 .rx.base でどのオブジェクトにアクセスできるか確認してください。

print("\n--- 練習問題3 ---")
// ここにコードを書いてみよう!


//: ---
//: ## 4. RxCocoa の UI 拡張
//:
//: RxCocoa は UIKit のコンポーネントに対して便利な Reactive Extension を提供しています。
//: ここでは代表的なものを確認しましょう。

print("\n\n=== 4. RxCocoa の UI 拡張 ===\n")

//: ### 4-1. UILabel.rx.text - テキストをバインド

print("--- UILabel.rx.text ---")

let disposeBag = DisposeBag()
let nameLabel = UILabel()

// Observable から UILabel にテキストをバインド
let nameRelay = BehaviorRelay<String>(value: "初期値")

nameRelay
    .bind(to: nameLabel.rx.text)
    .disposed(by: disposeBag)

print("ラベルのテキスト:", nameLabel.text ?? "nil")
// 出力: ラベルのテキスト: 初期値

nameRelay.accept("更新されました")
print("ラベルのテキスト:", nameLabel.text ?? "nil")
// 出力: ラベルのテキスト: 更新されました

//: ### 4-2. UITextField.rx.text - 入力値を監視

print("\n--- UITextField.rx.text ---")

let searchField = UITextField()

// UITextField の入力をリアルタイムに監視
searchField.rx.text.orEmpty
    .subscribe(onNext: { text in
        print("入力テキスト:", text)
    })
    .disposed(by: disposeBag)

// プログラムから値を設定してシミュレーション
searchField.text = "RxSwift"
searchField.sendActions(for: .editingChanged)
// 出力: 入力テキスト: RxSwift

//: ### 4-3. UIButton.rx.tap - タップイベント

print("\n--- UIButton.rx.tap ---")

let tapButton = UIButton(type: .system)
var tapCount = 0

tapButton.rx.tap
    .subscribe(onNext: {
        tapCount += 1
        print("タップ回数:", tapCount)
    })
    .disposed(by: disposeBag)

// プログラムからタップをシミュレーション
tapButton.sendActions(for: .touchUpInside)
tapButton.sendActions(for: .touchUpInside)
tapButton.sendActions(for: .touchUpInside)
// 出力:
// タップ回数: 1
// タップ回数: 2
// タップ回数: 3

//: ### 4-4. UISwitch.rx.isOn - スイッチの状態

print("\n--- UISwitch.rx.isOn ---")

let toggle = UISwitch()

toggle.rx.isOn
    .subscribe(onNext: { isOn in
        print("スイッチ:", isOn ? "ON" : "OFF")
    })
    .disposed(by: disposeBag)

toggle.isOn = true
toggle.sendActions(for: .valueChanged)
// 出力: スイッチ: ON

toggle.isOn = false
toggle.sendActions(for: .valueChanged)
// 出力: スイッチ: OFF

//: ### 4-5. bind(to:) でデータフローを作る

print("\n--- bind(to:) でデータフローを作る ---")

let inputField = UITextField()
let outputLabel = UILabel()

// テキストフィールドの入力 → ラベルに自動反映
inputField.rx.text
    .bind(to: outputLabel.rx.text)
    .disposed(by: disposeBag)

inputField.text = "Hello, RxSwift!"
inputField.sendActions(for: .editingChanged)

print("入力:", inputField.text ?? "nil")
print("出力:", outputLabel.text ?? "nil")
// 出力:
// 入力: Hello, RxSwift!
// 出力: Hello, RxSwift!

//: ### 💪 練習問題4
//: BehaviorRelay<Bool> を作成し、UISwitch の .rx.isOn にバインドしてみましょう。
//: Relay の値を true/false に変更して、スイッチの状態が変わることを確認してください。

print("\n--- 練習問題4 ---")
// ここにコードを書いてみよう!


//: ---
//: ## 5. カスタム Reactive Extension
//:
//: 自分で作ったクラスにも `.rx` を追加できます。
//: ここでは、独自の Reactive Extension の作り方を学びましょう。

print("\n\n=== 5. カスタム Reactive Extension ===\n")

//: ### 5-1. 独自クラスに .rx を追加する

print("--- 独自クラスに .rx を追加する ---")

// カスタムクラスの定義
class Counter {
    var count: Int = 0

    func increment() {
        count += 1
    }

    func reset() {
        count = 0
    }
}

// ReactiveCompatible に準拠させる
extension Counter: ReactiveCompatible {}

// Reactive<Counter> に拡張を追加
extension Reactive where Base: Counter {
    // 現在のカウントを Observable として公開
    var currentCount: Observable<Int> {
        return Observable.just(base.count)
    }
}

let counter = Counter()
counter.increment()
counter.increment()
counter.increment()

// .rx でアクセスできる！
counter.rx.currentCount
    .subscribe(onNext: { count in
        print("カウント:", count)
    })
// 出力: カウント: 3

print("counter.rx の型:", type(of: counter.rx))
// 出力: counter.rx の型: Reactive<Counter>

//: ### 5-2. UIView にカスタムプロパティを追加する

print("\n--- UIView にカスタムプロパティを追加する ---")

// UIView の背景色を Rx で設定できるようにする
extension Reactive where Base: UIView {
    // 背景色をバインドできる Binder
    var backgroundColor: Binder<UIColor> {
        return Binder(self.base) { view, color in
            view.backgroundColor = color
        }
    }
}

let myView = UIView()
let colorRelay = BehaviorRelay<UIColor>(value: .white)

colorRelay
    .bind(to: myView.rx.backgroundColor)
    .disposed(by: disposeBag)

print("背景色:", myView.backgroundColor ?? "nil")
// 出力: 背景色: UIExtendedSRGBColorSpace 1 1 1 1

colorRelay.accept(.red)
print("背景色:", myView.backgroundColor ?? "nil")
// 出力: 背景色: UIExtendedSRGBColorSpace 1 0 0 1

//: ### 5-3. Binder の仕組み

print("\n--- Binder の仕組み ---")

// Binder は「値を受け取って何かする」ための型
// エラーイベントを受け取らない（UIの更新でエラーは不要）

// Binder の基本構造:
// Binder<Input>(対象オブジェクト) { 対象, 値 in
//     対象に値を設定する処理
// }

// 例: UILabel のフォントサイズをバインドできるようにする
extension Reactive where Base: UILabel {
    var fontSize: Binder<CGFloat> {
        return Binder(self.base) { label, size in
            label.font = UIFont.systemFont(ofSize: size)
        }
    }
}

let sizeLabel = UILabel()
let sizeRelay = BehaviorRelay<CGFloat>(value: 14.0)

sizeRelay
    .bind(to: sizeLabel.rx.fontSize)
    .disposed(by: disposeBag)

print("フォントサイズ:", sizeLabel.font.pointSize)
// 出力: フォントサイズ: 14.0

sizeRelay.accept(24.0)
print("フォントサイズ:", sizeLabel.font.pointSize)
// 出力: フォントサイズ: 24.0

//: ### 5-4. Observable を返すカスタムプロパティ

print("\n--- Observable を返すカスタムプロパティ ---")

// UITextField に文字数を監視するプロパティを追加
extension Reactive where Base: UITextField {
    var textLength: Observable<Int> {
        return text.orEmpty.map { $0.count }
    }
}

let charField = UITextField()

charField.rx.textLength
    .subscribe(onNext: { length in
        print("文字数:", length)
    })
    .disposed(by: disposeBag)

charField.text = "Hello"
charField.sendActions(for: .editingChanged)
// 出力: 文字数: 5

charField.text = "RxSwift入門"
charField.sendActions(for: .editingChanged)
// 出力: 文字数: 7

//: ### 💪 練習問題5
//: UILabel に対して、テキストが空かどうかを判定する
//: `isEmpty` プロパティ（Observable<Bool> を返す）を
//: Reactive Extension として追加してみましょう。
//:
//: ヒント: `rx.observe(String.self, "text")` を使います。

print("\n--- 練習問題5 ---")
// ここにコードを書いてみよう!


//: ---
//: ## 6. 実践的な組み合わせ
//:
//: これまで学んだジェネリクスと Reactive Extension を組み合わせて、
//: 実践的なパターンを確認しましょう。

print("\n\n=== 6. 実践的な組み合わせ ===\n")

//: ### 6-1. ViewModel風の構造

print("--- ViewModel風の構造 ---")

class SimpleViewModel {
    // Input（View → ViewModel）
    let inputText = BehaviorRelay<String>(value: "")

    // Output（ViewModel → View）
    let outputText: Observable<String>
    let characterCount: Observable<Int>
    let isValid: Observable<Bool>

    init() {
        // 入力テキストを加工して出力を作る
        outputText = inputText
            .map { "入力: \($0)" }

        characterCount = inputText
            .map { $0.count }

        isValid = inputText
            .map { $0.count >= 3 }
    }
}

let viewModel = SimpleViewModel()
let vmDisposeBag = DisposeBag()

viewModel.outputText
    .subscribe(onNext: { text in
        print(text)
    })
    .disposed(by: vmDisposeBag)

viewModel.characterCount
    .subscribe(onNext: { count in
        print("文字数: \(count)")
    })
    .disposed(by: vmDisposeBag)

viewModel.isValid
    .subscribe(onNext: { isValid in
        print("有効: \(isValid)")
    })
    .disposed(by: vmDisposeBag)

viewModel.inputText.accept("Hi")
viewModel.inputText.accept("Hello")
// 出力:
// 入力:
// 文字数: 0
// 有効: false
// 入力: Hi
// 文字数: 2
// 有効: false
// 入力: Hello
// 文字数: 5
// 有効: true

//: ### 6-2. UI とのバインディング

print("\n--- UI とのバインディング ---")

// ViewModel の出力を UI にバインド
let displayLabel = UILabel()
let validationLabel = UILabel()

let vm2 = SimpleViewModel()
let bindDisposeBag = DisposeBag()

// outputText → displayLabel
vm2.outputText
    .bind(to: displayLabel.rx.text)
    .disposed(by: bindDisposeBag)

// isValid → validationLabel のテキスト
vm2.isValid
    .map { $0 ? "✓ OK" : "✗ 3文字以上入力してください" }
    .bind(to: validationLabel.rx.text)
    .disposed(by: bindDisposeBag)

vm2.inputText.accept("Rx")
print("表示:", displayLabel.text ?? "nil")
print("検証:", validationLabel.text ?? "nil")

vm2.inputText.accept("RxSwift")
print("表示:", displayLabel.text ?? "nil")
print("検証:", validationLabel.text ?? "nil")
// 出力:
// 表示: 入力: Rx
// 検証: ✗ 3文字以上入力してください
// 表示: 入力: RxSwift
// 検証: ✓ OK

//: ### 💪 練習問題6
//: SimpleViewModel を参考に、数値を入力として受け取り、
//: 「偶数かどうか」と「10以上かどうか」を出力する
//: NumberViewModel を作成してみましょう。

print("\n--- 練習問題6 ---")
// ここにコードを書いてみよう!


//: ---
//: ## まとめ
//:
//: このPlaygroundでは以下を学びました:
//:
//: 1. **ジェネリクスの基礎**: 型パラメータ `<T>` で汎用的なコードを書く
//: 2. **Observable<T>**: 型安全なストリーム、map による型変換
//: 3. **Reactive Extension**: `.rx` の仕組み（ReactiveCompatible, Reactive<Base>）
//: 4. **RxCocoa の UI 拡張**: UILabel.rx.text, UIButton.rx.tap など
//: 5. **カスタム Reactive Extension**: 独自の `.rx` プロパティの作り方（Binder）
//: 6. **実践的な組み合わせ**: ViewModel と UI のバインディング
//:
//: 次のステップ: 第3回のカウンターアプリで、MVVMパターンを実際のアプリに適用しましょう！

print("\n\n=== 学習完了！ ===")
