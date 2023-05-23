//
//  InputsExplorerControllerTests.swift
//  NutriScanTests
//
//  Created by Yago Marques on 18/05/23.
//

import XCTest
@testable import NutriScan

typealias InputsExplorerControllerSUT = (
    sut: InputsExplorerController,
    doubles: (
        view: InputsExplorerViewSpy,
        interactor: InputsExplorerInteractorSpy,
        coordinator: InputsExplorerCoordinatorSpy
    )
)

final class InputsExplorerControllerTests: XCTestCase {

    // MARK: - viewDidLoad
    func test_viewDidLoad_WhenViewLoadInFirstTime_ShouldConfigureCoordinatorNavigation() {
        let data = makeSUTandDoubles()

        data.sut.viewDidLoad()

        XCTAssertEqual(
            data.doubles.coordinator.receivedMessages,
            [.navigationConfigured]
        )
    }

    // MARK: - viewWillAppear
    func test_viewWillAppear_WhenViewAppear_ShouldRefreshViewConfigurationAndFetchFoods() {
        let data = makeSUTandDoubles()

        data.sut.viewWillAppear(true)

        XCTAssertEqual(
            data.doubles.interactor.receivedMessages,
            [.refreshViewConfigurationCalled]
        )
    }

    // MARK: - getImageClassification
    func test_getImageClassification_WhenImageIsCorrect_ShouldCallInteractorToCalcClassification() {
        let data = makeSUTandDoubles()

        data.sut.getClassification(for: UIImage(systemName: "plus")!)

        XCTAssertEqual(
            data.doubles.interactor.receivedMessages,
            [.getImageClassificationCalled]
        )
    }

    func test_getImageClassification_WhenImageIsNotCorrect_ShouldNotCallInteractorToCalcClassification() {
        let data = makeSUTandDoubles()

        data.sut.getClassification(for: UIImage())

        XCTAssertEqual(
            data.doubles.interactor.receivedMessages,
            []
        )
    }

    // MARK: - setTopBarButtons
    func test_setTopBarButtons_ShouldCallCoordinatorToConfigureNavigationButtons() {
        let data = makeSUTandDoubles()

        data.sut.setTopBarButtons([UIBarButtonItem()])

        XCTAssertEqual(
            data.doubles.coordinator.receivedMessages,
            [.setNavigationItensCalled]
        )
    }

    // MARK: - presentMedia
    func test_presentMedia_ShouldCallCoordinatorToShowCameraOrLibraryPhoto() {
        let data = makeSUTandDoubles()

        data.sut.presentMedia(UIImagePickerController())

        XCTAssertEqual(
            data.doubles.coordinator.receivedMessages,
            [.showMediaOptionCalled]
        )
    }

    // MARK: - presentMediaOptions
    func test_presentMediaOptions_ShouldCallCoordinatorToShowSheetWithMediaOptions() {
        let data = makeSUTandDoubles()

        data.sut.presentMediaOptions(UIAlertController())

        XCTAssertEqual(
            data.doubles.coordinator.receivedMessages,
            [.showMediaOptionsSheetCalled]
        )
    }

    // MARK: - filterFoods
    func test_filterFoods_ShouldCallInteractorToFilterFoods() {
        let data = makeSUTandDoubles()

        data.sut.filterFoods(filterBy: "myQueryOption")

        XCTAssertEqual(
            data.doubles.interactor.receivedMessages,
            [.filterFoodsCalled]
        )
    }

    // MARK: - searchFoods
    func test_searchFoods_ShouldCallInteractorToSearchFoods() {
        let data = makeSUTandDoubles()

        data.sut.searchFoods(searchBy: "mySearchQuery")

        XCTAssertEqual(
            data.doubles.interactor.receivedMessages,
            [.searchFoodsCalled]
        )
    }

    // MARK: - showOverview
    func test_showOverview_ShouldCallCoordinatorToPushOverviewOfSelectedFood() {
        let data = makeSUTandDoubles()
        let myFood = Food(name: "", category: "", itens: [])

        data.sut.showOverview(of: myFood)

        XCTAssertEqual(
            data.doubles.coordinator.receivedMessages,
            [.showOverviewCalled]
        )
    }

    // MARK: - presentVoiceAlert
    func test_presentVoiceAlert_ShouldCallCoordinatorToPresentVoiceInputErrorAlert() {
        let data = makeSUTandDoubles()

        data.sut.presentVoiceAlert(UIAlertController())

        XCTAssertEqual(
            data.doubles.coordinator.receivedMessages,
            [.presentVoiceAlertCalled]
        )
    }

    // MARK: - sendVoicePredict
    func test_sendVoicePredict_ShouldCallInteractorToGetFoodClassificationByVoicePrediction() {
        let data = makeSUTandDoubles()

        data.sut.sendVoicePredict(voiceText: "my voice recognized")

        XCTAssertEqual(
            data.doubles.interactor.receivedMessages,
            [.getVoiceClassificationCalled]
        )
    }

    // MARK: - displayFoodResumeFromImageClassification
    func test_displayFoodResumeFromImageClassification_ShouldCallCoordinatorToHideMediaOptionAndPushOverview() {
        let data = makeSUTandDoubles()
        let myFood = Food(name: "", category: "", itens: [])

        data.sut.displayFoodResumeFromImageClassification(viewModel: .init(food: myFood))

        XCTAssertEqual(
            data.doubles.coordinator.receivedMessages,
            [.downMediaOptionCalled, .showOverviewCalled]
        )
    }

    // MARK: - displayImageClassificationError
    func test_displayImageClassificationError_ShouldCallCoordinatorToHideMediaOptionAndPushErrorAlert() {
        let data = makeSUTandDoubles()

        data.sut.displayImageClassificationError()

        XCTAssertEqual(
            data.doubles.coordinator.receivedMessages,
            [.downMediaOptionCalled, .showImageClassificationAlertCalled]
        )
    }

    // MARK: - displayFoodResumeFromVoice
    func test_displayFoodResumeFromVoice_ShouldCallCoordinatorToPushOverviewOfSelectedItem() {
        let data = makeSUTandDoubles()
        let myFood = Food(name: "", category: "", itens: [])

        data.sut.displayFoodResumeFromVoice(viewModel: .init(food: myFood))

        XCTAssertEqual(
            data.doubles.coordinator.receivedMessages,
            [.showOverviewCalled]
        )
    }

    // MARK: - displayVoiceRecognizerError
    func test_displayVoiceRecognizerError_ShouldCallCoordinatorToPresentVoiceRecognizerErrorAlert() {
        let data = makeSUTandDoubles()

        data.sut.displayVoiceRecognizerError()

        XCTAssertEqual(
            data.doubles.coordinator.receivedMessages,
            [.presentVoiceAlertCalled]
        )
    }

    // MARK: - displayFoodGrid
    func test_displayFoodGrid_ShouldCallViewToUpdateGridItens() {
        let data = makeSUTandDoubles()
        let myFoods = [
            Food(name: "", category: "", itens: [])
        ]

        data.sut.displayFoodGrid(viewModel: .init(foods: myFoods))

        XCTAssertEqual(
            data.doubles.view.receivedMessages,
            [.updateFoodGridCalled]
        )
    }

    // MARK: - displayFilteredFoods
    func test_displayFilteredFoods_ShouldCallViewToUpdateGridItensWithFilteredFoods() {
        let data = makeSUTandDoubles()
        let myFilteredFoods = [
            Food(name: "", category: "", itens: [])
        ]

        data.sut.displayFilteredFoods(viewModel: .init(filteredFoods: myFilteredFoods))

        XCTAssertEqual(
            data.doubles.view.receivedMessages,
            [.updateFoodGridCalled]
        )
    }

    // MARK: - displaySearchedFoods
    func test_displaySearchedFoods_ShouldCallViewToUpdateGridItensWithSearchedFoods() {
        let data = makeSUTandDoubles()
        let mySearchedFoods = [
            Food(name: "", category: "", itens: [])
        ]

        data.sut.displaySearchedFoods(viewModel: .init(searchedFoods: mySearchedFoods))

        XCTAssertEqual(
            data.doubles.view.receivedMessages,
            [.updateFoodGridCalled]
        )
    }

    // MARK: - displayConnectivityError
    func test_displayConnectivityError_ShouldCallViewToShowConnectivityErrorMessage() {
        let data = makeSUTandDoubles()
        let myCustomError = ConnectivityErrorComposer.make()

        data.sut.displayConnectivityError(viewModel: .init(data: myCustomError))

        XCTAssertEqual(
            data.doubles.view.receivedMessages,
            [.showConnectivityErrorViewCalled]
        )
    }

    // MARK: - displayActivityIndicator
    func test_displayActivityIndicator_WhenStatusIsToStart_ShouldCallViewToStartNetworkingActivityProgress() {
        let data = makeSUTandDoubles()

        data.sut.displayActivityIndicator(viewModel: .init(status: .start))

        XCTAssertEqual(
            data.doubles.view.receivedMessages,
            [.startActivityLoadingCalled]
        )
    }

    func test_displayActivityIndicator_WhenStatusIsToStop_ShouldCallViewToStopNetworkingActivityProgress() {
        let data = makeSUTandDoubles()

        data.sut.displayActivityIndicator(viewModel: .init(status: .stop))

        XCTAssertEqual(
            data.doubles.view.receivedMessages,
            [.stopActivityLoadingCalled]
        )
    }

    // MARK: - displayEmptyListNotification
    func test_displayEmptyListNotification_ShouldCallViewToShowEmptyListErrorMessage() {
        let data = makeSUTandDoubles()
        let myCustomError = EmptyListNotificationComposer.make()

        data.sut.displayEmptyListNotification(viewModel: .init(data: myCustomError))

        XCTAssertEqual(
            data.doubles.view.receivedMessages,
            [.showEmptyFoodViewCalled]
        )
    }

    // MARK: - hideEmptyListNotification
    func test_hideEmptyListNotification_ShouldCallViewToHideEmptyListErrorMessage() {
        let data = makeSUTandDoubles()

        data.sut.hideEmptyListNotification()

        XCTAssertEqual(
            data.doubles.view.receivedMessages,
            [.hideEmptyFoodViewCalled]
        )
    }

    // MARK: - displayRefeshedView
    func test_displayRefeshedView_ShouldCallViewToRefreshLayout() {
        let data = makeSUTandDoubles()
        let filterIndexChoosed = 0

        data.sut.displayRefeshedView(viewModel: .init(filterIndex: filterIndexChoosed))

        XCTAssertEqual(
            data.doubles.view.receivedMessages,
            [.refreshViewCalled]
        )
    }
}

private extension InputsExplorerControllerTests {
    func makeSUTandDoubles() -> InputsExplorerControllerSUT {
        let interactor = InputsExplorerInteractorSpy()
        let coordinator = InputsExplorerCoordinatorSpy()
        let view = InputsExplorerViewSpy()
        let controller = InputsExplorerController(
            inputExplorerView: view,
            interactor: interactor,
            coordinator: coordinator
        )

        return InputsExplorerControllerSUT(sut: controller, doubles: ( view, interactor, coordinator ))
    }
}
