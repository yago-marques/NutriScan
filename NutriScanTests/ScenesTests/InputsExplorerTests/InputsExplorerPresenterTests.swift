//
//  InputsExplorerPresenterTests.swift
//  NutriScanTests
//
//  Created by Thiago Henrique on 23/05/23.
//

import XCTest
@testable import NutriScan

typealias InputsExplorerPresenterSUT = (
    sut: InputsExplorerPresenter,
    controllerSpy: InputsExplorerControllerSpy
)

final class InputsExplorerPresenterTests: XCTestCase {
    func test_setup_should_inject_controller() {
        let (sut, controllerSpy) = makeSUTandDoubles()
        sut.setup(controller: controllerSpy)
        XCTAssertNotNil(sut.controller)
    }
    
    func test_presentFoodResumeFromImageClassification_when_classify_correctly_should_call_controller() {
        let (sut, controllerSpy) = makeSUTandDoubles()
        sut.foods = [Food(name: "laranja", category: "", itens: [])]
        sut.presentFoodResumeFromImageClassification(response: .init(classification: "(0.61) orange"))
        XCTAssertEqual(controllerSpy.receivedMessages, [.displayFoodResumeFromImageClassificationCalled])
    }
    
    func test_presentFoodResumeFromImageClassification_when_not_found_food_should_call_controller_with_error() {
        let (sut, controllerSpy) = makeSUTandDoubles()
        sut.presentFoodResumeFromImageClassification(response: .init(classification:  "(0.61) orange"))
        XCTAssertEqual(controllerSpy.receivedMessages, [.displayImageClassificationErrorCalled])
    }
    
    func test_presentFoodResumeFromImageClassification_when_cant_translate_call_controller_with_error() {
        let (sut, controllerSpy) = makeSUTandDoubles()
        sut.presentFoodResumeFromImageClassification(response: .init(classification:  "(0.61) a"))
        XCTAssertEqual(controllerSpy.receivedMessages, [.displayImageClassificationErrorCalled])
    }
    
    func test_presentFoodGrid_should_populate_foods() {
        let (sut, _) = makeSUTandDoubles()
        sut.presentFoodGrid(response: .init(foods: [RemoteFood(name: "orange", category: "", itens: [])]))
        XCTAssertFalse(sut.foods.isEmpty)
    }
    
    func test_presentFoodGrid_should_call_controller() {
        let (sut, controllerSpy) = makeSUTandDoubles()
        sut.presentFoodGrid(response: .init(foods: [RemoteFood(name: "orange", category: "", itens: [])]))
        XCTAssertEqual(controllerSpy.receivedMessages, [.displayFoodGridCalled])
    }
    
    func test_presentFilteredFoods_when_valid_category_should_filter_correctly() {
        let (sut, _) = makeSUTandDoubles()
        let inputedFood = Food(name: "laranja", category: "fruta", itens: [])
        sut.foods = [inputedFood]
        sut.presentFilteredFoods(response: .init(filterBy: "Fruta"))
        XCTAssertFalse(sut.filteredFoods.isEmpty)
    }
    
    func test_presentFilteredFoods_when_all_should_not_filter() {
        let (sut, _) = makeSUTandDoubles()
        let inputedFood = Food(name: "laranja", category: "", itens: [])
        sut.foods = [inputedFood]
        sut.presentFilteredFoods(response: .init(filterBy: "Todos"))
        XCTAssertFalse(sut.filteredFoods.isEmpty)
    }
    
    func test_presentFilteredFoods_should_call_controller() {
        let (sut, controllerSpy) = makeSUTandDoubles()
        let inputedFood = Food(name: "laranja", category: "", itens: [])
        sut.foods = [inputedFood]
        sut.presentFilteredFoods(response: .init(filterBy: "Todos"))
        XCTAssertEqual(controllerSpy.receivedMessages, [.displayFilteredFoodsCalled])
    }
    
    func test_presentSearchedFoods_should_search() {
        let (sut, _) = makeSUTandDoubles()
        sut.filteredFoods = [Food(name: "laranja", category: "", itens: [])]
        sut.presentSearchedFoods(response: .init(searchBy: "la"))
        XCTAssertFalse(sut.searchedFoods.isEmpty)
    }
    
    func test_presentSearchedFoods_should_search_correctly() {
        let (sut, _) = makeSUTandDoubles()
        sut.filteredFoods = [Food(name: "laranja", category: "", itens: [])]
        sut.presentSearchedFoods(response: .init(searchBy: "la"))
        XCTAssertEqual(sut.searchedFoods.first!.name, "laranja")
    }
    
    func test_presentSearchedFoods_should_call_controller() {
        let (sut, controllerSpy) = makeSUTandDoubles()
        sut.filteredFoods = [Food(name: "laranja", category: "", itens: [])]
        sut.presentSearchedFoods(response: .init(searchBy: "la"))
        XCTAssertEqual(controllerSpy.receivedMessages, [.displaySearchedFoodsCalled])
    }

    func test_presentConnectivityError_should_call_controller() {
        let (sut, controllerSpy) = makeSUTandDoubles()
        sut.presentConnectivityError()
        XCTAssertEqual(controllerSpy.receivedMessages, [.displayConnectivityErrorCalled])
    }
    
    func test_presentEmptyListNotificationIfNeeded_when_empty_should_call_controller_correctly() {
        let (sut, controllerSpy) = makeSUTandDoubles()
        sut.searchedFoods = []
        sut.presentEmptyListNotificationIfNeeded()
        XCTAssertEqual(controllerSpy.receivedMessages, [.displayEmptyListNotificationCalled])
    }
    
    func test_presentEmptyListNotificationIfNeeded_when_not_empty_should_call_controller_correctly() {
        let (sut, controllerSpy) = makeSUTandDoubles()
        sut.searchedFoods = [Food(name: "laranja", category: "", itens: [])]
        sut.presentEmptyListNotificationIfNeeded()
        XCTAssertEqual(controllerSpy.receivedMessages, [.hideEmptyListNotificationCalled])
    }
    
    func test_presentFoodResumeFromVoice_when_get_from_voice_should_call_controller_correctly() {
        let (sut, controllerSpy) = makeSUTandDoubles()
        let inputedFoodName = "laranja"
        sut.foods = [Food(name: inputedFoodName, category: "", itens: [])]
        sut.presentFoodResumeFromVoice(response: .init(text: inputedFoodName))
        XCTAssertEqual(controllerSpy.receivedMessages, [.displayFoodResumeFromVoiceCalled])
    }
    
    func test_presentFoodResumeFromVoice_when_cant_get_from_voice_should_call_controller_correctly() {
        let (sut, controllerSpy) = makeSUTandDoubles()
        sut.foods = []
        sut.presentFoodResumeFromVoice(response: .init(text: "laranja"))
        XCTAssertEqual(controllerSpy.receivedMessages, [.displayVoiceRecognizerErrorCalled])
    }
}

extension InputsExplorerPresenterTests {
    func makeSUTandDoubles() -> InputsExplorerPresenterSUT {
        let spy = InputsExplorerControllerSpy()
        let sut = InputsExplorerPresenter(controller: spy)
        return (sut, (spy))
    }
}
