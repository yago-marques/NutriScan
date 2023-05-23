//
//  ImageClassificationErrorComposer.swift
//  NutriScan
//
//  Created by Yago Marques on 17/05/23.
//

import UIKit

enum ImageClassificationErrorAlertComposer {
    static func make() -> UIAlertController {
        let alert = UIAlertController(
            title: "Erro de classificação",
            message: "Não conseguimos identificar esse alimento na base de dados",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ok", style: .destructive, handler: nil))

        return alert
    }
}
