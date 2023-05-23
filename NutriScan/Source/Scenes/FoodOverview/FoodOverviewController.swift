//
//  FoodOverviewController.swift
//  NutriScan
//
//  Created by Yago Marques on 15/05/23.
//

import UIKit

protocol FoodOverviewControlling: AnyObject {
    func displayOverview(viewModel: FoodOverview.LoadInfo.ViewModel)
}

final class FoodOverviewController: UIViewController {
    private let foodOverview: FoodOverviewView
    private let food: Food
    private let interactor: FoodOverviewInteracting

    init(
        foodOverview: FoodOverviewView,
        food: Food,
        interactor: FoodOverviewInteracting
    ) {
        self.foodOverview = foodOverview
        self.food = food
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view = self.foodOverview
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.backButtonTitle = ""

        interactor.organizeFoodInfo(request: .init(food: self.food))
    }

}

extension FoodOverviewController: FoodOverviewControlling {
    func displayOverview(viewModel: FoodOverview.LoadInfo.ViewModel) {
        foodOverview.setupOverview(with: viewModel.food)
    }
}
