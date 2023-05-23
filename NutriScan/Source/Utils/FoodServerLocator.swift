//
//  FoodServerLocator.swift
//  NutriScan
//
//  Created by Yago Marques on 17/05/23.
//

import Foundation

struct FoodServerLocator {
    static let shared = FoodServerLocator()

    private let server: [String: String] = [
        "apple": "maçã",
        "banana": "banana",
        "beetroot": "beterraba",
        "bell pepper": "pimentão",
        "cabbage": "repolho",
        "capsicum": "pimentão",
        "carrot": "cenoura",
        "cauliflower": "couve-flor",
        "chilli pepper": "pimenta",
        "corn": "milho",
        "cucumber": "pepino",
        "aggplant": "berinjela",
        "garlic": "alho",
        "ginger": "gengibre",
        "grapes": "uva",
        "jalapeno": "pimenta",
        "kiwi": "kiwi",
        "lemon": "limão",
        "lettuce": "alface",
        "mango": "manga",
        "onion": "cebola",
        "orange": "laranja",
        "paprika": "pimentão",
        "pear": "pera",
        "peas": "ervilha",
        "pineapple": "abacaxi",
        "pomegranate": "romã",
        "potato": "batata",
        "raddish": "rabanete",
        "soy beans": "soja",
        "spinach": "espinafre",
        "sweetcorn": "milho",
        "sweetpotato": "batata-doce",
        "tomato": "tomate",
        "turnip": "nabo",
        "watermelon": "melancia"
    ]

    private init() { }

    func getPortuguese(of foodName: String) -> String? {
        server[foodName]
    }
}
