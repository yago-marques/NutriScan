//
//  InputsExplorerCoordinatorMock.swift
//  NutriScanTests
//
//  Created by Yago Marques on 18/05/23.
//

@testable import NutriScan
import UIKit

final class InputsExplorerCoordinatorSpy: InputsExplorerCoordinatorManager {
    enum Message: Equatable {
        case navigationConfigured
        case showOverviewCalled
        case setNavigationItensCalled
        case downMediaOptionCalled
        case showImageClassificationAlertCalled
        case showMediaOptionCalled
        case showMediaOptionsSheetCalled
        case presentVoiceAlertCalled
    }

    var receivedMessages = [Message]()

    var navigation: UINavigationController? {
        didSet {
            receivedMessages.append(.navigationConfigured)
        }
    }

    func showOverview(of food: NutriScan.Food) {
        receivedMessages.append(.showOverviewCalled)
    }

    func setNavigationItens(_ buttons: [UIBarButtonItem]) {
        receivedMessages.append(.setNavigationItensCalled)
    }

    func downMediaOption() {
        receivedMessages.append(.downMediaOptionCalled)
    }

    func showImageClassificationAlert() {
        receivedMessages.append(.showImageClassificationAlertCalled)
    }

    func showMediaOption(_ picker: UIImagePickerController) {
        receivedMessages.append(.showMediaOptionCalled)
    }

    func showMediaOptionsSheet(_ sheet: UIAlertController) {
        receivedMessages.append(.showMediaOptionsSheetCalled)
    }

    func presentVoiceAlert(_ alert: UIAlertController) {
        receivedMessages.append(.presentVoiceAlertCalled)
    }
}
