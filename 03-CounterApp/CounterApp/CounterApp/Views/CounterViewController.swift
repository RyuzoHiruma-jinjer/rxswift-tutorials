//
//  CounterViewController.swift
//  CounterApp
//
//  RxSwift Tutorial #3 - カウンターアプリ
//

import UIKit
import RxSwift
import RxCocoa

/// カウンターアプリの ViewController
///
/// ViewModelとUIをバインディングで接続する。
/// View自身にはロジックを持たせず、ViewModelに委譲する。
final class CounterViewController: UIViewController {

    // MARK: - IBOutlets

    /// カウント値を表示するラベル
    @IBOutlet private weak var countLabel: UILabel!
    /// +ボタン
    @IBOutlet private weak var incrementButton: UIButton!
    /// −ボタン
    @IBOutlet private weak var decrementButton: UIButton!
    /// Resetボタン
    @IBOutlet private weak var resetButton: UIButton!

    // MARK: - Properties

    /// ViewModel - ビジネスロジックを担当
    private let viewModel = CounterViewModel()
    /// DisposeBag - バインディングのメモリ管理
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    // MARK: - Binding

    /// ViewModelとUIをバインディングで接続する
    ///
    /// Input:  UIイベント → ViewModel
    /// Output: ViewModel → UI
    private func bind() {
        // ============================================
        // Input: ボタンタップをViewModelに伝える
        // ============================================

        // +ボタンのタップイベントをViewModelのincrementTappedに流す
        incrementButton.rx.tap
            .bind(to: viewModel.incrementTapped)
            .disposed(by: disposeBag)

        // −ボタンのタップイベントをViewModelのdecrementTappedに流す
        decrementButton.rx.tap
            .bind(to: viewModel.decrementTapped)
            .disposed(by: disposeBag)

        // ResetボタンのタップイベントをViewModelのresetTappedに流す
        resetButton.rx.tap
            .bind(to: viewModel.resetTapped)
            .disposed(by: disposeBag)

        // ============================================
        // Output: ViewModelのデータをUIに反映する
        // ============================================

        // カウント値の文字列をラベルに表示
        viewModel.countText
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)

        // −ボタンの有効/無効を制御
        viewModel.isDecrementEnabled
            .bind(to: decrementButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
