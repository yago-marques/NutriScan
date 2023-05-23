//
//  InputsExplorerCoordinator.swift
//  NutriScan
//
//  Created by Yago Marques on 15/05/23.
//

import UIKit

protocol InputsExplorerCoordinatorManager {
    var navigation: UINavigationController? {get set}
    func setNavigationItens(_ buttons: [UIBarButtonItem])
    func showOverview(of food: Food)
    func downMediaOption()
    func showImageClassificationAlert()
    func showMediaOption(_ picker: UIImagePickerController)
    func showMediaOptionsSheet(_ sheet: UIAlertController)
    func presentVoiceAlert(_ alert: UIAlertController)
}

final class InputsExplorerCoordinator: InputsExplorerCoordinatorManager {
    var navigation: UINavigationController?

    init(navigation: UINavigationController? = nil) {
        self.navigation = navigation
    }

    func setNavigationItens(_ buttons: [UIBarButtonItem]) {
        navigation?.navigationItem.setRightBarButtonItems(buttons, animated: true)
    }

    func showOverview(of food: Food) {
        navigation?.pushViewController(FoodOverviewFactory.make(with: food), animated: true)
    }

    func downMediaOption() {
        navigation?.dismiss(animated: true)
    }

    func showImageClassificationAlert() {
        navigation?.present(ImageClassificationErrorAlertComposer.make(), animated: true)
    }

    func showMediaOption(_ picker: UIImagePickerController) {
        navigation?.present(picker, animated: true)
    }

    func showMediaOptionsSheet(_ sheet: UIAlertController) {
        navigation?.present(sheet, animated: true)
    }

    func presentVoiceAlert(_ alert: UIAlertController) {
        navigation?.present(alert, animated: true)
    }
}

