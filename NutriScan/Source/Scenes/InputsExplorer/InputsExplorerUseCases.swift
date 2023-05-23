//
//  CreateOrderModels.swift
//  NutriScan
//
//  Created by Yago Marques on 08/05/23.
//

import Foundation

enum InputsExplorer {
    // MARK: - UseCases
    enum GetImageClassification {
        struct Request {
            let image: Data
        }

        struct Response {
            let classification: String
        }

        struct ViewModel {
            let food: Food
        }
    }

    enum FetchFoods {
        struct Request { }

        struct Response {
            let foods: [RemoteFood]
        }

        struct ViewModel {
            let foods: [Food]
        }
    }

    enum FilterFoods {
        struct Request {
            let filterBy: String
        }

        struct Response {
            let filterBy: String
        }

        struct ViewModel {
            let filteredFoods: [Food]
        }
    }

    enum SearchFoods {
        struct Request {
            let searchBy: String
        }

        struct Response {
            let searchBy: String
        }

        struct ViewModel {
            let searchedFoods: [Food]
        }
    }

    enum ConnectivityError {
        struct Request { }

        struct Response { }

        struct ViewModel {
            let data: GenericErrorViewModel
        }
    }

    enum EmptyFoodNotification {
        struct Request { }

        struct Response { }

        struct ViewModel {
            let data: GenericErrorViewModel
        }
    }

    enum ActivityIndicator {
        struct Request { }

        struct Response {
            let status: FoodActivityStatus
        }

        struct ViewModel {
            let status: FoodActivityStatus
        }
    }

    enum GetVoiceClassification {
        struct Request {
            let text: String
        }

        struct Response {
            let text: String
        }

        struct ViewModel {
            let food: Food
        }
    }

    enum RefreshViewWhenAppear {
        struct Request {
            let filterIndex: Int
        }

        struct Response {
            let filterIndex: Int
        }

        struct ViewModel {
            let filterIndex: Int
        }
    }
}
