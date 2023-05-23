//
//  InputsExplorerPresenterSpy.swift
//  NutriScanTests
//
//  Created by Yago Marques on 22/05/23.
//

import Foundation
@testable import NutriScan

final class InputsExplorerPresenterSpy: InputExplorerPresenting {
    enum Message: Equatable {
        case presentFoodResumeFromImageClassificationCalled
        case presentFoodGridCalled
        case presentFilteredFoodsCalled
        case presentSearchedFoodsCalled
        case presentConnectivityErrorCalled
        case presentActivityIndicatorCalled
        case presentEmptyListNotificationIfNeededCalled
        case presentFoodResumeFromVoiceCalled
        case presentRefreshedViewCalled
    }

    var receivedMessages = [Message]()

    func presentFoodResumeFromImageClassification(response: NutriScan.InputsExplorer.GetImageClassification.Response) {
        receivedMessages.append(.presentFoodResumeFromImageClassificationCalled)
    }

    func presentFoodGrid(response: NutriScan.InputsExplorer.FetchFoods.Response) {
        receivedMessages.append(.presentFoodGridCalled)
    }

    func presentFilteredFoods(response: NutriScan.InputsExplorer.FilterFoods.Response) {
        receivedMessages.append(.presentFilteredFoodsCalled)
    }

    func presentSearchedFoods(response: NutriScan.InputsExplorer.SearchFoods.Response) {
        receivedMessages.append(.presentSearchedFoodsCalled)
    }

    func presentConnectivityError() {
        receivedMessages.append(.presentConnectivityErrorCalled)
    }

    func presentActivityIndicator(response: NutriScan.InputsExplorer.ActivityIndicator.Response) {
        receivedMessages.append(.presentActivityIndicatorCalled)
    }

    func presentEmptyListNotificationIfNeeded() {
        receivedMessages.append(.presentEmptyListNotificationIfNeededCalled)
    }

    func presentFoodResumeFromVoice(response: NutriScan.InputsExplorer.GetVoiceClassification.Response) {
        receivedMessages.append(.presentFoodResumeFromVoiceCalled)
    }

    func presentRefreshedView(response: NutriScan.InputsExplorer.RefreshViewWhenAppear.Response) {
        receivedMessages.append(.presentRefreshedViewCalled)
    }
}
