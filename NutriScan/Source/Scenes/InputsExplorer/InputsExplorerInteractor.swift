//
//  InputsExplorerInteractor.swift
//  NutriScan
//
//  Created by Yago Marques on 06/05/23.
//

import Foundation

enum CacheError: Error {
    case cacheEmpty
}

// MARK: - Protocols
protocol InputsExplorerInteracting {
    func getImageClassification(request: InputsExplorer.GetImageClassification.Request)
    func fetchFoods(request: InputsExplorer.FetchFoods.Request) async
    func filterFoods(request: InputsExplorer.FilterFoods.Request)
    func searchFoods(request: InputsExplorer.SearchFoods.Request)
    func getVoiceClassification(request: InputsExplorer.GetVoiceClassification.Request)
    func refreshViewConfiguration(request: InputsExplorer.RefreshViewWhenAppear.Request)
}

final class InputsExplorerInteractor: InputsExplorerInteracting {
    // MARK: - Dependencies
    private let mlWorker: MLFruitAndVegetableClassifier
    private let httpWorker: HTTPClient
    private let coredataWorker: FoodCoredataWorker
    private let presenter: InputExplorerPresenting

    // MARK: - Initializers
    init(
        mlWorker: MLFruitAndVegetableClassifier,
        presenter: InputExplorerPresenting,
        httpWorker: HTTPClient,
        coredataWorker: FoodCoredataWorker
    ) {
        self.mlWorker = mlWorker
        self.httpWorker = httpWorker
        self.presenter = presenter
        self.coredataWorker = coredataWorker
    }

    // MARK: - Methods
    func getImageClassification(request: InputsExplorer.GetImageClassification.Request) {
        mlWorker.createClassificationsRequest(for: request.image) { [weak self] classification in
            self?.presenter.presentFoodResumeFromImageClassification(response: .init(classification: classification))
        }
    }

    func fetchFoods(request: InputsExplorer.FetchFoods.Request) async {
        presenter.presentActivityIndicator(response: .init(status: .start))
        do {
            try tryLoadCachedFoods()
        } catch {
            await LoadRemoteFoods()
        }
        presenter.presentActivityIndicator(response: .init(status: .stop))
    }

    func filterFoods(request: InputsExplorer.FilterFoods.Request) {
        presenter.presentFilteredFoods(response: .init(filterBy: request.filterBy))
    }

    func searchFoods(request: InputsExplorer.SearchFoods.Request) {
        presenter.presentSearchedFoods(response: .init(searchBy: request.searchBy))
        presenter.presentEmptyListNotificationIfNeeded()
    }

    func getVoiceClassification(request: InputsExplorer.GetVoiceClassification.Request) {
        presenter.presentFoodResumeFromVoice(response: .init(text: request.text))
    }

    func refreshViewConfiguration(request: InputsExplorer.RefreshViewWhenAppear.Request) {
        presenter.presentRefreshedView(response: .init(filterIndex: request.filterIndex))
    }
}

private extension InputsExplorerInteractor {
    private func updateCacheIfNeeded(with remoteModels: [RemoteFood]) throws {
        let cachedFoods = try coredataWorker.readFoods()

        if cachedFoods.isEmpty {
            try coredataWorker.createFoods(with: remoteModels)
        }
    }

    private func fetchCache() throws -> [RemoteFood]? {
        let cachedFoods = try coredataWorker.readFoods()

        if cachedFoods.isEmpty {
            return nil
        } else {
            return cachedFoods
        }
    }

    private func tryLoadCachedFoods() throws {
        do {
            if let cachedFoods = try self.fetchCache() {
                presenter.presentFoodGrid(response: .init(foods: cachedFoods))
            } else {
                throw CacheError.cacheEmpty
            }
        } catch {
            throw CacheError.cacheEmpty
        }
    }

    private func LoadRemoteFoods() async {
        do {
            if let data = try await httpWorker.request(endpoint: FoodListEndpoint()) {
                let foods = try JSONDecoder().decode([RemoteFood].self, from: data)

                try self.updateCacheIfNeeded(with: foods)
                presenter.presentFoodGrid(response: .init(foods: foods))
            } else {
                presenter.presentConnectivityError()
            }
        } catch {
            presenter.presentConnectivityError()
        }

    }
}
