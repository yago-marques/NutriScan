//
//  AsynchronousHandlerWorker.swift
//  NutriScan
//
//  Created by Yago Marques on 22/05/23.
//

import Foundation

protocol AsynchronousHandlerWorkerDelegate {
    func perform(_ action: @escaping () async -> Void) async
}

struct AsynchronousHandlerWorker: AsynchronousHandlerWorkerDelegate {
    func perform(_ action: @escaping () async -> Void) {
        Task {
            await action()
        }
    }
}
