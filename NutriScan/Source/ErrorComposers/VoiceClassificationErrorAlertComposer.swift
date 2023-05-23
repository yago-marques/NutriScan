//
//  VoiceClassificationErrorAlertComposer.swift
//  NutriScan
//
//  Created by Yago Marques on 17/05/23.
//

import UIKit

enum VoiceClassificationErrorAlertComposer {
    static func make() -> UIAlertController {
        let alert = UIAlertController(
            title: "Erro de busca",
            message: "Não conseguimos identificar um alimento de acordo com o que foi reconehcido na sua voz",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ok", style: .destructive, handler: nil))

        return alert
    }
}
