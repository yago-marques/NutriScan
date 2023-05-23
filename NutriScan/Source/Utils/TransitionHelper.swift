//
//  TransitionHelper.swift
//  NutriScan
//
//  Created by Yago Marques on 17/05/23.
//

import UIKit

extension UIView {
    func withAnimation(speed: Double = 0.3, completionHandler: @escaping () -> Void) {
        UIView.transition(
            with: self,
            duration: speed,
            options: .transitionCrossDissolve,
            animations: {
                completionHandler()
            }
        )
    }
}
