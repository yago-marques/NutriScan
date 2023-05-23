//
//  InputsExplorerPresenter.swift
//  NutriScan
//
//  Created by Yago Marques on 06/05/23.
//

import Foundation

// MARK: - Protocols
protocol InputExplorerPresenting {
    func presentFoodResumeFromImageClassification(response: InputsExplorer.GetImageClassification.Response)
    func presentFoodGrid(response: InputsExplorer.FetchFoods.Response)
    func presentFilteredFoods(response: InputsExplorer.FilterFoods.Response)
    func presentSearchedFoods(response: InputsExplorer.SearchFoods.Response)
    func presentConnectivityError()
    func presentActivityIndicator(response: InputsExplorer.ActivityIndicator.Response)
    func presentEmptyListNotificationIfNeeded()
    func presentFoodResumeFromVoice(response: InputsExplorer.GetVoiceClassification.Response)
    func presentRefreshedView(response: InputsExplorer.RefreshViewWhenAppear.Response)
}

final class InputsExplorerPresenter: InputExplorerPresenting {
    // MARK: - Dependencies
    weak var controller: InputsExplorerControlling?

    var foods: [Food] = []
    var filteredFoods: [Food] = []
    var searchedFoods: [Food] = []

    // MARK: - Initializers
    init(controller: InputsExplorerControlling? = nil) {
        self.controller = controller
    }

    // MARK: - Methods
    func setup(controller: InputsExplorerControlling) {
        self.controller = controller
    }

    func presentFoodResumeFromImageClassification(response: InputsExplorer.GetImageClassification.Response) {
        let classification = getFoodNameOfClassification(response.classification)
        guard let foodName = FoodServerLocator.shared.getPortuguese(of: classification) else {
            controller?.displayImageClassificationError()
            return
        }

        guard let food = foods.first(where: { $0.name == foodName }) else {
            controller?.displayImageClassificationError()
            return
        }

        controller?.displayFoodResumeFromImageClassification(viewModel: .init(food: food))
    }

    func presentFoodGrid(response: InputsExplorer.FetchFoods.Response) {
        let viewModels = response.foods.map { FoodMapper.toViewModel(from: $0) }
        self.foods = viewModels

        controller?.displayFoodGrid(viewModel: .init(foods: self.foods))
    }

    func presentFilteredFoods(response: InputsExplorer.FilterFoods.Response) {
        if response.filterBy != FoodCategory.all.rawValue {
            filteredFoods = self.foods.filter { $0.category == response.filterBy.lowercased() }
        } else {
            filteredFoods = self.foods
        }

        controller?.displayFilteredFoods(viewModel: .init(filteredFoods: filteredFoods))
    }

    func presentSearchedFoods(response: InputsExplorer.SearchFoods.Response) {
        searchedFoods = filteredFoods
            .filter { $0.name.lowercased().contains(response.searchBy.lowercased()) }

        controller?.displaySearchedFoods(viewModel: .init(searchedFoods: searchedFoods))
    }

    func presentConnectivityError() {
        controller?.displayConnectivityError(viewModel: .init(data: ConnectivityErrorComposer.make()))
    }

    func presentActivityIndicator(response: InputsExplorer.ActivityIndicator.Response) {
        controller?.displayActivityIndicator(viewModel: .init(status: response.status))
    }

    func presentEmptyListNotificationIfNeeded() {
        if searchedFoods.isEmpty {
            controller?.displayEmptyListNotification(viewModel: .init(data: EmptyListNotificationComposer.make()))
        } else {
            controller?.hideEmptyListNotification()
        }
    }

    func presentFoodResumeFromVoice(response: InputsExplorer.GetVoiceClassification.Response) {
        if let food = getFoodFromVoiceText(response.text) {
            controller?.displayFoodResumeFromVoice(viewModel: .init(food: food))
        } else {
            controller?.displayVoiceRecognizerError()
        }
    }

    func presentRefreshedView(response: InputsExplorer.RefreshViewWhenAppear.Response) {
        controller?.displayRefeshedView(viewModel: .init(filterIndex: response.filterIndex))
    }
}

extension InputsExplorerPresenter {
    private func getFoodNameOfClassification(_ classification: String) -> String {
        let str = classification
        let i = str.index(str.startIndex, offsetBy: 7)
        let substring = str[i...]

        return String(substring)
    }

    private func getFoodFromVoiceText(_ voiceText: String) -> Food? {
        foods
            .first(
                where: { food in
                    let foodName = food.name
                        .replacingOccurrences(of: "-", with: "")
                        .lowercased()

                    return voiceText
                        .replacingOccurrences(of: "-", with: "")
                        .replacingOccurrences(of: " ", with: "")
                        .lowercased()
                        .contains(foodName)
                }
            )
    }
}
