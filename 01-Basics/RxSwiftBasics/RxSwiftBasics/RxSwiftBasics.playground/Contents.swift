//: # RxSwift 基礎知識編
//:
//: この Playground では、RxSwift の基本概念を学びます。
//: 上から順に実行していくことで、RxSwift の仕組みを理解できます。
//:
//: **実行方法:**
//: - 全体を実行: `Cmd + Shift + Return`
//: - コンソール表示: `Cmd + Shift + Y`

import RxSwift
import RxCocoa // BehaviorRelayのため

//: ---
//: ## 1. Observable の基本
//:
//: Observable は「時間とともにイベントを流すストリーム」です。
//: 川の流れのように、データが上流から下流へと時間とともに流れていきます。

print("=== 1. Observable の基本 ===\n")

//: ### 1-1. Observable.of - 複数の値を流す
let observable1 = Observable.of(1, 2, 3, 4, 5)

print("--- Observable.of の例 ---")
observable1.subscribe { event in
    print(event)
}
// 出力:
// next(1)
// next(2)
// next(3)
// next(4)
// next(5)
// completed

//: ### 1-2. Observable.just - 単一の値を流す
let observable2 = Observable.just("Hello, RxSwift!")

print("\n--- Observable.just の例 ---")
observable2.subscribe { event in
    print(event)
}
// 出力:
// next(Hello, RxSwift!)
// completed

//: ### 1-3. Observable.from - 配列から生成
let numbers = [10, 20, 30, 40, 50]
let observable3 = Observable.from(numbers)

print("\n--- Observable.from の例 ---")
observable3.subscribe { event in
    print(event)
}
// 出力:
// next(10)
// next(20)
// next(30)
// next(40)
// next(50)
// completed

//: ### 1-4. Observable.create - カスタムObservable
let observable4 = Observable<String>.create { observer in
    observer.onNext("イベント1")
    observer.onNext("イベント2")
    observer.onNext("イベント3")
    observer.onCompleted()
    
    return Disposables.create()
}

print("\n--- Observable.create の例 ---")
observable4.subscribe { event in
    print(event)
}
// 出力:
// next(イベント1)
// next(イベント2)
// next(イベント3)
// completed

//: ### 1-5. onNext, onError, onCompleted を分けて受け取る
let observable5 = Observable.of("A", "B", "C")

print("\n--- イベントを分けて受け取る例 ---")
observable5.subscribe(
    onNext: { value in
        print("値を受信:", value)
    },
    onError: { error in
        print("エラー:", error)
    },
    onCompleted: {
        print("完了しました")
    }
)
// 出力:
// 値を受信: A
// 値を受信: B
// 値を受信: C
// 完了しました

//: ### 💪 練習問題1
//: Observable.from を使って、配列 ["Swift", "Kotlin", "Java"] から Observable を作成し、
//: 各要素を購読して表示してみましょう。

print("\n--- 練習問題1 ---")
// ここにコードを書いてみよう!


//: ---
//: ## 2. PublishSubject
//:
//: PublishSubject は「購読開始後のイベントのみ」を受け取ります。
//: 購読前に流れたイベントは受け取れません。

print("\n\n=== 2. PublishSubject ===\n")

let publishSubject = PublishSubject<String>()

//: ### 2-1. 基本的な使い方
print("--- 基本的な使い方 ---")

// 購読前にイベントを流す
publishSubject.onNext("イベント0（購読前）")

// 購読開始
publishSubject.subscribe(onNext: { value in
    print("購読者1:", value)
})

// 購読後にイベントを流す
publishSubject.onNext("イベント1")
publishSubject.onNext("イベント2")
// 出力:
// 購読者1: イベント1
// 購読者1: イベント2
// ※ イベント0 は表示されない（購読前だから）

//: ### 2-2. 複数の購読者
print("\n--- 複数の購読者 ---")

let publishSubject2 = PublishSubject<Int>()

publishSubject2.subscribe(onNext: { value in
    print("購読者A:", value)
})

publishSubject2.onNext(1)

publishSubject2.subscribe(onNext: { value in
    print("購読者B:", value)
})

publishSubject2.onNext(2)
publishSubject2.onNext(3)
// 出力:
// 購読者A: 1
// 購読者A: 2
// 購読者B: 2
// 購読者A: 3
// 購読者B: 3

//: ### 💪 練習問題2
//: PublishSubject<String> を作成し、購読前に「購読前のメッセージ」を流し、
//: その後購読を開始して「購読後のメッセージ」を流してみましょう。
//: どちらのメッセージが表示されるか確認してください。

print("\n--- 練習問題2 ---")
// ここにコードを書いてみよう!


//: ---
//: ## 3. BehaviorSubject
//:
//: BehaviorSubject は「最新値を保持」し、購読時に即座にその値を通知します。
//: 初期値が必要です。

print("\n\n=== 3. BehaviorSubject ===\n")

//: ### 3-1. 基本的な使い方
print("--- 基本的な使い方 ---")

// 初期値100でBehaviorSubjectを作成
let behaviorSubject = BehaviorSubject<Int>(value: 100)

// 購読すると、即座に最新値（初期値100）が流れる
behaviorSubject.subscribe(onNext: { value in
    print("購読者1:", value)
})
// 出力: 購読者1: 100

behaviorSubject.onNext(200)
behaviorSubject.onNext(300)
// 出力:
// 購読者1: 200
// 購読者1: 300

//: ### 3-2. 後から購読しても最新値を受け取る
print("\n--- 後から購読しても最新値を受け取る ---")

let behaviorSubject2 = BehaviorSubject<String>(value: "初期値")

behaviorSubject2.onNext("値A")
behaviorSubject2.onNext("値B")

// ここで購読開始 → 最新値「値B」を即座に受け取る
behaviorSubject2.subscribe(onNext: { value in
    print("購読者2:", value)
})
// 出力: 購読者2: 値B

behaviorSubject2.onNext("値C")
// 出力: 購読者2: 値C

//: ### 💪 練習問題3
//: BehaviorSubject<Int> を初期値 0 で作成し、
//: 10, 20, 30 と値を流してから購読を開始してみましょう。
//: 最初に表示される値は何でしょうか？

print("\n--- 練習問題3 ---")
// ここにコードを書いてみよう!


//: ---
//: ## 4. ReplaySubject
//:
//: ReplaySubject は「指定した数の過去イベント」を保持し、
//: 購読時にそれらを再生します。

print("\n\n=== 4. ReplaySubject ===\n")

//: ### 4-1. 基本的な使い方（バッファサイズ2）
print("--- 基本的な使い方（バッファサイズ2） ---")

// 過去2つのイベントを保持
let replaySubject = ReplaySubject<Int>.create(bufferSize: 2)

replaySubject.onNext(1)
replaySubject.onNext(2)
replaySubject.onNext(3)

// 購読開始 → 過去2つ（2, 3）が再生される
replaySubject.subscribe(onNext: { value in
    print("購読者1:", value)
})
// 出力:
// 購読者1: 2
// 購読者1: 3

replaySubject.onNext(4)
// 出力: 購読者1: 4

//: ### 4-2. バッファサイズの違いを確認
print("\n--- バッファサイズの違いを確認 ---")

let replaySubject2 = ReplaySubject<String>.create(bufferSize: 3)

replaySubject2.onNext("A")
replaySubject2.onNext("B")
replaySubject2.onNext("C")
replaySubject2.onNext("D")

// 購読開始 → 過去3つ（B, C, D）が再生される
replaySubject2.subscribe(onNext: { value in
    print("購読者2:", value)
})
// 出力:
// 購読者2: B
// 購読者2: C
// 購読者2: D

//: ### 💪 練習問題4
//: ReplaySubject<String> をバッファサイズ 1 で作成し、
//: "one", "two", "three" と流してから購読を開始してみましょう。
//: どの値が表示されるか確認してください。

print("\n--- 練習問題4 ---")
// ここにコードを書いてみよう!


//: ---
//: ## 5. BehaviorRelay
//:
//: BehaviorRelay は「エラーが発生しない」Subject です。
//: 実務では最も推奨される型で、RxCocoa で提供されています。
//: BehaviorSubject と同様に最新値を保持します。

print("\n\n=== 5. BehaviorRelay ===\n")

//: ### 5-1. 基本的な使い方
print("--- 基本的な使い方 ---")

// 初期値10でBehaviorRelayを作成
let behaviorRelay = BehaviorRelay<Int>(value: 10)

// 購読すると、即座に最新値（初期値10）が流れる
behaviorRelay.subscribe(onNext: { value in
    print("購読者1:", value)
})
// 出力: 購読者1: 10

// accept()で新しい値を流す（onNext()ではない）
behaviorRelay.accept(20)
behaviorRelay.accept(30)
// 出力:
// 購読者1: 20
// 購読者1: 30

//: ### 5-2. 現在の値を取得
print("\n--- 現在の値を取得 ---")

let currentValue = behaviorRelay.value
print("現在の値:", currentValue)
// 出力: 現在の値: 30

//: ### 5-3. エラーが発生しない特性
print("\n--- エラーが発生しない ---")

// BehaviorRelayにはonError()やonCompleted()がない
// これにより、意図しないストリームの終了を防げる

let relay = BehaviorRelay<String>(value: "安全")
relay.accept("値1")
relay.accept("値2")
// エラーで終了することがないため、安心して使える

//: ### 5-4. 実務での使用例：カウンター
print("\n--- 実務での使用例：カウンター ---")

let counterRelay = BehaviorRelay<Int>(value: 0)

counterRelay.subscribe(onNext: { count in
    print("カウント:", count)
})
// 出力: カウント: 0

// カウントアップ
counterRelay.accept(counterRelay.value + 1)
counterRelay.accept(counterRelay.value + 1)
counterRelay.accept(counterRelay.value + 1)
// 出力:
// カウント: 1
// カウント: 2
// カウント: 3

//: ### 💪 練習問題5
//: BehaviorRelay<Int> を初期値 100 で作成し、
//: 現在の値から 10 を引いた値を accept() で流すコードを書いてみましょう。
//: これを3回繰り返して、100 → 90 → 80 → 70 と変化することを確認してください。

print("\n--- 練習問題5 ---")
// ここにコードを書いてみよう!


//: ---
//: ## 6. Disposable と DisposeBag
//:
//: Disposable は「購読の解除」を行うための仕組みです。
//: DisposeBag は複数の Disposable をまとめて管理します。

print("\n\n=== 6. Disposable と DisposeBag ===\n")

//: ### 6-1. Disposableの基本
print("--- Disposableの基本 ---")

let observable6 = Observable.of(1, 2, 3)

let disposable = observable6.subscribe(onNext: { value in
    print("値:", value)
})

// 購読を解除
disposable.dispose()

// 解除後は何も流れない
observable6.subscribe(onNext: { value in
    print("解除後:", value)
})

//: ### 6-2. DisposeBagの使い方
print("\n--- DisposeBagの使い方 ---")

let disposeBag = DisposeBag()

Observable.of("A", "B", "C")
    .subscribe(onNext: { value in
        print("値:", value)
    })
    .disposed(by: disposeBag)

// DisposeBagがスコープを抜けると、自動的に購読が解除される

//: ### 6-3. メモリリークを防ぐ例
print("\n--- メモリリークを防ぐ例 ---")

class ViewController {
    let disposeBag = DisposeBag()
    let subject = PublishSubject<String>()
    
    func setupBindings() {
        // [weak self] でメモリリークを防ぐ
        subject
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                print("self:", self, "値:", value)
            })
            .disposed(by: disposeBag)
    }
}

let viewController = ViewController()
viewController.setupBindings()
viewController.subject.onNext("テスト")

//: ### 6-4. DisposeBagが解放されるタイミング
print("\n--- DisposeBagが解放されるタイミング ---")

do {
    let bag = DisposeBag()
    
    Observable.of(1, 2, 3)
        .subscribe(onNext: { value in
            print("スコープ内:", value)
        })
        .disposed(by: bag)
    
    // スコープを抜けると bag が解放され、購読も解除される
}

print("スコープを抜けました")

//: ### 💪 練習問題6
//: Observable.of("X", "Y", "Z") を作成し、
//: DisposeBag を使って購読を管理してみましょう。
//: .disposed(by: disposeBag) を使うのを忘れずに！

print("\n--- 練習問題6 ---")
let exerciseBag = DisposeBag()
// ここにコードを書いてみよう!


//: ---
//: ## まとめ
//:
//: このPlaygroundでは以下を学びました:
//:
//: 1. **Observable**: イベントストリームの生成方法
//: 2. **PublishSubject**: 購読後のイベントのみを受け取る
//: 3. **BehaviorSubject**: 最新値を保持し即座に通知
//: 4. **ReplaySubject**: 指定数の過去イベントを再生
//: 5. **BehaviorRelay**: エラーが発生しない安全な型（実務推奨）
//: 6. **Disposable/DisposeBag**: メモリ管理の仕組み
//:
//: 次のステップ: 実際のアプリでMVVMパターンと組み合わせて使ってみましょう！

print("\n\n=== 学習完了！ ===")
