//
//  InputsExplorerInteractorMock.swift
//  NutriScanTests
//
//  Created by Yago Marques on 18/05/23.
//

@testable import NutriScan

final class InputsExplorerInteractorSpy: InputsExplorerInteracting {
    enum Message: Equatable {
        case getImageClassificationCalled
        case fetchFoodsCalled
        case filterFoodsCalled
        case searchFoodsCalled
        case getVoiceClassificationCalled
        case refreshViewConfigurationCalled
    }

    var receivedMessages = [Message]()

    func getImageClassification(request: NutriScan.InputsExplorer.GetImageClassification.Request) {
        receivedMessages.append(.getImageClassificationCalled)
    }

    func fetchFoods(request: NutriScan.InputsExplorer.FetchFoods.Request) {
        receivedMessages.append(.fetchFoodsCalled)
    }

    func filterFoods(request: NutriScan.InputsExplorer.FilterFoods.Request) {
        receivedMessages.append(.filterFoodsCalled)
    }

    func searchFoods(request: NutriScan.InputsExplorer.SearchFoods.Request) {
        receivedMessages.append(.searchFoodsCalled)
    }

    func getVoiceClassification(request: NutriScan.InputsExplorer.GetVoiceClassification.Request) {
        receivedMessages.append(.getVoiceClassificationCalled)
    }

    func refreshViewConfiguration(request: NutriScan.InputsExplorer.RefreshViewWhenAppear.Request) {
        receivedMessages.append(.refreshViewConfigurationCalled)
    }
}
