//
//  InputsExplorerControllerSpy.swift
//  NutriScanTests
//
//  Created by Thiago Henrique on 23/05/23.
//

import Foundation
@testable import NutriScan

class InputsExplorerControllerSpy: InputsExplorerControlling {
    enum Message: Equatable {
        case displayFoodResumeFromImageClassificationCalled
        case displayFoodGridCalled
        case displayFilteredFoodsCalled
        case displaySearchedFoodsCalled
        case displayConnectivityErrorCalled
        case displayActivityIndicatorCalled
        case displayEmptyListNotificationCalled
        case hideEmptyListNotificationCalled
        case displayImageClassificationErrorCalled
        case displayFoodResumeFromVoiceCalled
        case displayVoiceRecognizerErrorCalled
        case displayRefeshedViewCalled
    }
    
    var receivedMessages = [Message]()
    
    func displayFoodResumeFromImageClassification(viewModel: NutriScan.InputsExplorer.GetImageClassification.ViewModel) {
        receivedMessages.append(.displayFoodResumeFromImageClassificationCalled)
    }
    
    func displayFoodGrid(viewModel: NutriScan.InputsExplorer.FetchFoods.ViewModel) {
        receivedMessages.append(.displayFoodGridCalled)
    }
    
    func displayFilteredFoods(viewModel: NutriScan.InputsExplorer.FilterFoods.ViewModel) {
        receivedMessages.append(.displayFilteredFoodsCalled)
    }
    
    func displaySearchedFoods(viewModel: NutriScan.InputsExplorer.SearchFoods.ViewModel) {
        receivedMessages.append(.displaySearchedFoodsCalled)
    }
    
    func displayConnectivityError(viewModel: NutriScan.InputsExplorer.ConnectivityError.ViewModel) {
        receivedMessages.append(.displayConnectivityErrorCalled)
    }
    
    func displayActivityIndicator(viewModel: NutriScan.InputsExplorer.ActivityIndicator.ViewModel) {
        receivedMessages.append(.displayActivityIndicatorCalled)
    }
    
    func displayEmptyListNotification(viewModel: NutriScan.InputsExplorer.EmptyFoodNotification.ViewModel) {
        receivedMessages.append(.displayEmptyListNotificationCalled)
    }
    
    func hideEmptyListNotification() {
        receivedMessages.append(.hideEmptyListNotificationCalled)
    }
    
    func displayImageClassificationError() {
        receivedMessages.append(.displayImageClassificationErrorCalled)
    }
    
    func displayFoodResumeFromVoice(viewModel: NutriScan.InputsExplorer.GetVoiceClassification.ViewModel) {
        receivedMessages.append(.displayFoodResumeFromVoiceCalled)
    }
    
    func displayVoiceRecognizerError() {
        receivedMessages.append(.displayVoiceRecognizerErrorCalled)
    }
    
    func displayRefeshedView(viewModel: NutriScan.InputsExplorer.RefreshViewWhenAppear.ViewModel) {
        receivedMessages.append(.displayRefeshedViewCalled)
    }
    
    
}
