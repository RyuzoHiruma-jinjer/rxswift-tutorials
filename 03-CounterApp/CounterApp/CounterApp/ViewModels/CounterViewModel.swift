//
//  CounterViewModel.swift
//  CounterApp
//
//  RxSwift Tutorial #3 - カウンターアプリ
//

import RxSwift
import RxCocoa
import RxRelay

/// カウンターアプリの ViewModel
///
/// Input/Output パターンで実装。
/// - Input: ViewからViewModelへのイベント（ボタンタップ）
/// - Output: ViewModelからViewへのデータ（カウント値、ボタン状態）
final class CounterViewModel {

    // MARK: - Inputs（ViewからViewModelへ）

    /// +ボタンがタップされた
    let incrementTapped = PublishRelay<Void>()
    /// −ボタンがタップされた
    let decrementTapped = PublishRelay<Void>()
    /// Resetボタンがタップされた
    let resetTapped = PublishRelay<Void>()

    // MARK: - Outputs（ViewModelからViewへ）

    /// カウント値（Int）- テストで使用
    let count: Observable<Int>
    /// カウント値の文字列表現 - UILabelにバインド
    let countText: Observable<String>
    /// −ボタンが有効かどうか - カウントが0のとき無効
    let isDecrementEnabled: Observable<Bool>

    // MARK: - Private

    /// カウント値を保持する BehaviorRelay（初期値: 0）
    private let countRelay = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()

    // MARK: - Initializer

    init() {
        // ============================================
        // Outputs の定義
        // ============================================

        // countRelay の値をそのまま公開
        count = countRelay.asObservable()

        // Int → String に変換（map オペレーター）
        countText = countRelay
            .map { "\($0)" }

        // 0より大きいときだけ−ボタンを有効にする
        isDecrementEnabled = countRelay
            .map { $0 > 0 }

        // ============================================
        // Inputs の処理
        // ============================================

        // +ボタン: カウントを+1
        incrementTapped
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.countRelay.accept(self.countRelay.value + 1)
            })
            .disposed(by: disposeBag)

        // −ボタン: カウントを-1（0未満にはならない）
        decrementTapped
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let newValue = max(0, self.countRelay.value - 1)
                self.countRelay.accept(newValue)
            })
            .disposed(by: disposeBag)

        // Resetボタン: カウントを0にリセット
        resetTapped
            .subscribe(onNext: { [weak self] in
                self?.countRelay.accept(0)
            })
            .disposed(by: disposeBag)
    }
}
