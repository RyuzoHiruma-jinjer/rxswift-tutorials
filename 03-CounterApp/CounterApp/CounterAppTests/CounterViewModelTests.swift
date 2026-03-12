//
//  CounterViewModelTests.swift
//  CounterAppTests
//
//  RxSwift Tutorial #3 - カウンターアプリ
//

import XCTest
import RxSwift
import RxBlocking
@testable import CounterApp

final class CounterViewModelTests: XCTestCase {

    var viewModel: CounterViewModel!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        viewModel = CounterViewModel()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        viewModel = nil
        disposeBag = nil
        super.tearDown()
    }

    // MARK: - 初期値のテスト

    /// 初期状態でカウントが "0" であること
    func testInitialCountIsZero() throws {
        let countText = try viewModel.countText
            .toBlocking()
            .first()

        XCTAssertEqual(countText, "0")
    }

    /// 初期状態で−ボタンが無効であること（カウントが0のため）
    func testInitialDecrementIsDisabled() throws {
        let isEnabled = try viewModel.isDecrementEnabled
            .toBlocking()
            .first()

        XCTAssertEqual(isEnabled, false)
    }

    // MARK: - インクリメントのテスト

    /// +ボタンを1回タップするとカウントが "1" になること
    func testIncrementOnce() throws {
        viewModel.incrementTapped.accept(())

        let countText = try viewModel.countText
            .toBlocking()
            .first()

        XCTAssertEqual(countText, "1")
    }

    /// +ボタンを3回タップするとカウントが "3" になること
    func testIncrementMultipleTimes() throws {
        viewModel.incrementTapped.accept(())
        viewModel.incrementTapped.accept(())
        viewModel.incrementTapped.accept(())

        let countText = try viewModel.countText
            .toBlocking()
            .first()

        XCTAssertEqual(countText, "3")
    }

    /// +ボタンタップ後に−ボタンが有効になること
    func testDecrementEnabledAfterIncrement() throws {
        viewModel.incrementTapped.accept(())

        let isEnabled = try viewModel.isDecrementEnabled
            .toBlocking()
            .first()

        XCTAssertEqual(isEnabled, true)
    }

    // MARK: - デクリメントのテスト

    /// +ボタン2回→−ボタン1回でカウントが "1" になること
    func testDecrementAfterIncrement() throws {
        viewModel.incrementTapped.accept(())
        viewModel.incrementTapped.accept(())
        viewModel.decrementTapped.accept(())

        let countText = try viewModel.countText
            .toBlocking()
            .first()

        XCTAssertEqual(countText, "1")
    }

    /// カウントが0のとき−ボタンを押しても0のままであること
    func testDecrementDoesNotGoBelowZero() throws {
        viewModel.decrementTapped.accept(())

        let countText = try viewModel.countText
            .toBlocking()
            .first()

        XCTAssertEqual(countText, "0")
    }

    // MARK: - リセットのテスト

    /// +ボタン3回→Resetでカウントが "0" になること
    func testResetAfterIncrements() throws {
        viewModel.incrementTapped.accept(())
        viewModel.incrementTapped.accept(())
        viewModel.incrementTapped.accept(())
        viewModel.resetTapped.accept(())

        let countText = try viewModel.countText
            .toBlocking()
            .first()

        XCTAssertEqual(countText, "0")
    }

    /// Reset後に−ボタンが無効になること
    func testDecrementDisabledAfterReset() throws {
        viewModel.incrementTapped.accept(())
        viewModel.resetTapped.accept(())

        let isEnabled = try viewModel.isDecrementEnabled
            .toBlocking()
            .first()

        XCTAssertEqual(isEnabled, false)
    }

    // MARK: - 複合テスト

    /// 複数操作の連続テスト
    func testComplexOperations() throws {
        // +3回 → 3
        viewModel.incrementTapped.accept(())
        viewModel.incrementTapped.accept(())
        viewModel.incrementTapped.accept(())

        var countText = try viewModel.countText
            .toBlocking()
            .first()
        XCTAssertEqual(countText, "3")

        // −1回 → 2
        viewModel.decrementTapped.accept(())

        countText = try viewModel.countText
            .toBlocking()
            .first()
        XCTAssertEqual(countText, "2")

        // +2回 → 4
        viewModel.incrementTapped.accept(())
        viewModel.incrementTapped.accept(())

        countText = try viewModel.countText
            .toBlocking()
            .first()
        XCTAssertEqual(countText, "4")

        // Reset → 0
        viewModel.resetTapped.accept(())

        countText = try viewModel.countText
            .toBlocking()
            .first()
        XCTAssertEqual(countText, "0")
    }
}
