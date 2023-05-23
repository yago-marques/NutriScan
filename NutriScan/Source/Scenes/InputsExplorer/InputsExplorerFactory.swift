//
//  InputsExplorerFactory.swift
//  NutriScan
//
//  Created by Yago Marques on 06/05/23.
//

import UIKit

enum InputsExplorerFactory {
    static func make() -> UIViewController {
        let view = InputsExplorerView(frame: UIScreen.main.bounds)
        let presenter = InputsExplorerPresenter()
        let mlWorker = MLClassifierWorker()
        let interactor = InputsExplorerInteractor(
            mlWorker: mlWorker,
            presenter: presenter,
            httpWorker: URLSessionHTTPClient(session: URLSession.shared),
            coredataWorker: CoredataWorker()
        )
        let coordinator = InputsExplorerCoordinator()
        let controller = InputsExplorerController(
            inputExplorerView: view,
            interactor: interactor,
            coordinator: coordinator
        )

        presenter.controller = controller
        view.setup(controller: controller)
        controller.view = view

        return controller
    }
}
