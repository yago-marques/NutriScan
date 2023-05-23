//
//  InputsExplorerViewMock.swift
//  NutriScanTests
//
//  Created by Yago Marques on 18/05/23.
//

@testable import NutriScan

final class InputsExplorerViewSpy: InputsExplorerViewDelegate {
    enum Message: Equatable {
        case updateFoodGridCalled
        case showConnectivityErrorViewCalled
        case startActivityLoadingCalled
        case stopActivityLoadingCalled
        case showEmptyFoodViewCalled
        case hideEmptyFoodViewCalled
        case refreshViewCalled
    }

    var receivedMessages = [Message]()

    func updateFoodGrid(viewModels: [NutriScan.Food]) {
        receivedMessages.append(.updateFoodGridCalled)
    }

    func showConnectivityErrorView(_ viewModel: NutriScan.InputsExplorer.ConnectivityError.ViewModel) {
        receivedMessages.append(.showConnectivityErrorViewCalled)
    }

    func startActivityLoading() {
        receivedMessages.append(.startActivityLoadingCalled)
    }

    func stopActivityLoading() {
        receivedMessages.append(.stopActivityLoadingCalled)
    }

    func showEmptyFoodView(_ viewModel: NutriScan.InputsExplorer.EmptyFoodNotification.ViewModel) {
        receivedMessages.append(.showEmptyFoodViewCalled)
    }

    func hideEmptyFoodView() {
        receivedMessages.append(.hideEmptyFoodViewCalled)
    }

    func refreshView(index: Int) {
        receivedMessages.append(.refreshViewCalled)
    }
}
