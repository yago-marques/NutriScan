//
//  ViewController.swift
//  NutriScan
//
//  Created by Yago Marques on 06/05/23.
//

import UIKit

// MARK: - Protocols
protocol InputsExplorerControllerDelegate: AnyObject {
    func getClassification(for image: UIImage)
    func setTopBarButtons(_ buttons: [UIBarButtonItem])
    func presentMedia(_ media: UIImagePickerController)
    func presentMediaOptions(_ alertSheet: UIAlertController)
    func filterFoods(filterBy: String)
    func searchFoods(searchBy: String)
    func showOverview(of selectedFood: Food)
    func presentVoiceAlert(_ alert: UIAlertController)
    func sendVoicePredict(voiceText: String)
}

protocol InputsExplorerControlling: AnyObject {
    func displayFoodResumeFromImageClassification(viewModel: InputsExplorer.GetImageClassification.ViewModel)
    func displayFoodGrid(viewModel: InputsExplorer.FetchFoods.ViewModel)
    func displayFilteredFoods(viewModel: InputsExplorer.FilterFoods.ViewModel)
    func displaySearchedFoods(viewModel: InputsExplorer.SearchFoods.ViewModel)
    func displayConnectivityError(viewModel: InputsExplorer.ConnectivityError.ViewModel)
    func displayActivityIndicator(viewModel: InputsExplorer.ActivityIndicator.ViewModel)
    func displayEmptyListNotification(viewModel: InputsExplorer.EmptyFoodNotification.ViewModel)
    func hideEmptyListNotification()
    func displayImageClassificationError()
    func displayFoodResumeFromVoice(viewModel: InputsExplorer.GetVoiceClassification.ViewModel)
    func displayVoiceRecognizerError()
    func displayRefeshedView(viewModel: InputsExplorer.RefreshViewWhenAppear.ViewModel)
}

final class InputsExplorerController: UIViewController {
    // MARK: - Dependencies
    private let inputExplorerView: InputsExplorerViewDelegate
    private let interactor: InputsExplorerInteracting
    private var coordinator: InputsExplorerCoordinatorManager

    // MARK: - Initializers
    init(
        inputExplorerView: InputsExplorerViewDelegate,
        interactor: InputsExplorerInteracting,
        coordinator: InputsExplorerCoordinatorManager
    ) {
        self.inputExplorerView = inputExplorerView
        self.interactor = interactor
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.coordinator.navigation = self.navigationController
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        interactor.refreshViewConfiguration(request: .init(filterIndex: 0))

        Task { [weak self] in
            await self?.interactor.fetchFoods(request: .init())
        }
    }

}

// MARK: - Conformed Protocols Implementations
extension InputsExplorerController: InputsExplorerControllerDelegate {
    func getClassification(for image: UIImage) {
        if let data = image.pngData() {
            interactor.getImageClassification(request: .init(image: data))
        }
    }

    func setTopBarButtons(_ buttons: [UIBarButtonItem]) {
        coordinator.setNavigationItens(buttons)
    }

    func presentMedia(_ media: UIImagePickerController) {
        coordinator.showMediaOption(media)
    }

    func presentMediaOptions(_ alertSheet: UIAlertController) {
        coordinator.showMediaOptionsSheet(alertSheet)
    }

    func filterFoods(filterBy: String) {
        interactor.filterFoods(request: .init(filterBy: filterBy))
    }

    func searchFoods(searchBy: String) {
        interactor.searchFoods(request: .init(searchBy: searchBy))
    }

    func showOverview(of selectedFood: Food) {
        coordinator.showOverview(of: selectedFood)
    }

    func presentVoiceAlert(_ alert: UIAlertController) {
        coordinator.presentVoiceAlert(alert)
    }

    func sendVoicePredict(voiceText: String) {
        interactor.getVoiceClassification(request: .init(text: voiceText))
    }
}

extension InputsExplorerController: InputsExplorerControlling {
    func displayFoodResumeFromImageClassification(viewModel: InputsExplorer.GetImageClassification.ViewModel) {
        coordinator.downMediaOption()
        coordinator.showOverview(of: viewModel.food)
    }

    func displayFoodGrid(viewModel: InputsExplorer.FetchFoods.ViewModel) {
        inputExplorerView.updateFoodGrid(viewModels: viewModel.foods)
    }

    func displayFilteredFoods(viewModel: InputsExplorer.FilterFoods.ViewModel) {
        inputExplorerView.updateFoodGrid(viewModels: viewModel.filteredFoods)
    }

    func displaySearchedFoods(viewModel: InputsExplorer.SearchFoods.ViewModel) {
        inputExplorerView.updateFoodGrid(viewModels: viewModel.searchedFoods)
    }

    func displayConnectivityError(viewModel: InputsExplorer.ConnectivityError.ViewModel) {
        inputExplorerView.showConnectivityErrorView(viewModel)
    }

    func displayActivityIndicator(viewModel: InputsExplorer.ActivityIndicator.ViewModel) {
        switch viewModel.status {
        case .start:
            inputExplorerView.startActivityLoading()
        case .stop:
            inputExplorerView.stopActivityLoading()
        }
    }

    func displayEmptyListNotification(viewModel: InputsExplorer.EmptyFoodNotification.ViewModel) {
        inputExplorerView.showEmptyFoodView(viewModel)
    }

    func hideEmptyListNotification() {
        inputExplorerView.hideEmptyFoodView()
    }

    func displayImageClassificationError() {
        coordinator.downMediaOption()
        coordinator.showImageClassificationAlert()
    }

    func displayFoodResumeFromVoice(viewModel: InputsExplorer.GetVoiceClassification.ViewModel) {
        coordinator.showOverview(of: viewModel.food)
    }

    func displayVoiceRecognizerError() {
        coordinator.presentVoiceAlert(VoiceClassificationErrorAlertComposer.make())
    }

    func displayRefeshedView(viewModel: InputsExplorer.RefreshViewWhenAppear.ViewModel) {
        inputExplorerView.refreshView(index: viewModel.filterIndex)
    }
}
