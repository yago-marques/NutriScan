//
//  InputsExplorerInteractorTests.swift
//  NutriScanTests
//
//  Created by Yago Marques on 22/05/23.
//

import XCTest
@testable import NutriScan

typealias InputsExplorerInteractorSUT = (
    sut: InputsExplorerInteractor,
    doubles: (
        mlWorker: MlWorkerMock,
        httpWorker: HttpWorkerMock,
        coredataWorker: CoreDataWorkerStub,
        presenter: InputsExplorerPresenterSpy
    )
)

final class InputsExplorerInteractorTests: XCTestCase {

    //MARK: - getImageClassification
    func test_getImageClassification_ShouldCallPresenterToPresentFoodResume() {
        let data = makeSUTandDoubles()
        let imageData = Data()

        data.sut.getImageClassification(request: .init(image: imageData))

        XCTAssertTrue(data.doubles.mlWorker.createClassificationsRequestWasCalled)
        XCTAssertEqual(data.doubles.mlWorker.imageData, imageData)
        XCTAssertEqual(
            data.doubles.presenter.receivedMessages,
            [.presentFoodResumeFromImageClassificationCalled]
        )
    }

    //MARK: - fetchFoods
    func test_fetchFoods_WhenCacheIsNotEmpty_ShouldTryReadFromCache_ShouldCallPresenterToShowFoodGrid() async {
        let data = makeSUTandDoubles()
        data.doubles.coredataWorker.populateCache()

        await data.sut.fetchFoods(request: .init())

        XCTAssertEqual(
            data.doubles.coredataWorker.receivedMessages,
            [.readFoodsCalled]
        )
        XCTAssertEqual(
            data.doubles.presenter.receivedMessages,
            [.presentActivityIndicatorCalled, .presentFoodGridCalled, .presentActivityIndicatorCalled]
        )
    }
    
    func test_fetchFoods_WhenCacheIsEmpty_WhenInternetIsOn_ShouldTryReadFromCache_ShouldTryFetchFromInternet_ShouldUpdateCacheIfNeeded_ShouldCallPresenterToShowFoodGrid() async {
        let data = makeSUTandDoubles()

        await data.sut.fetchFoods(request: .init())

        XCTAssertEqual(
            data.doubles.coredataWorker.receivedMessages,
            [.readFoodsCalled, .readFoodsCalled, .createFoodsCalled]
        )

        XCTAssertEqual(data.doubles.httpWorker.endpointFlag?.method, "GET")
        XCTAssertEqual(data.doubles.httpWorker.endpointFlag?.path, "/deliveredUi")
        XCTAssertEqual(data.doubles.httpWorker.endpointFlag?.mode, .asyncAwait)
        XCTAssertEqual(
            data.doubles.presenter.receivedMessages,
            [.presentActivityIndicatorCalled, .presentFoodGridCalled, .presentActivityIndicatorCalled]
        )
    }

    func test_fetchFoods_WhenCacheIsEmpty_WhenInternetIsNotOn_ShouldTryReadFromCache_ShouldTryFetchFromInternet_ShouldCallPresenterToShowConnectivityError() async {
        let data = makeSUTandDoubles()
        data.doubles.httpWorker.internetIsOn = false

        await data.sut.fetchFoods(request: .init())

        XCTAssertEqual(
            data.doubles.coredataWorker.receivedMessages,
            [.readFoodsCalled]
        )

        XCTAssertEqual(data.doubles.httpWorker.endpointFlag?.method, "GET")
        XCTAssertEqual(data.doubles.httpWorker.endpointFlag?.path, "/deliveredUi")
        XCTAssertEqual(data.doubles.httpWorker.endpointFlag?.mode, .asyncAwait)
        XCTAssertEqual(
            data.doubles.presenter.receivedMessages,
            [.presentActivityIndicatorCalled, .presentConnectivityErrorCalled, .presentActivityIndicatorCalled]
        )
    }

    //MARK: - filterFoods
    func test_filterFoods_ShouldCallPresenterToShowFilteredFoodsOnGrid() {
        let data = makeSUTandDoubles()

        data.sut.filterFoods(request: .init(filterBy: "myFilterQuery"))

        XCTAssertEqual(
            data.doubles.presenter.receivedMessages,
            [.presentFilteredFoodsCalled]
        )
    }

    //MARK: - searchFoods
    func test_searchFoods_ShouldCallPresenterToShowSearchedFoodsOnGrid_ShouldCallPresenterToShowMessageOfEmptyListForQueryIfNeeded() {
        let data = makeSUTandDoubles()

        data.sut.searchFoods(request: .init(searchBy: "mySearchQuery"))

        XCTAssertEqual(
            data.doubles.presenter.receivedMessages,
            [.presentSearchedFoodsCalled, .presentEmptyListNotificationIfNeededCalled]
        )
    }

    //MARK: - getVoiceClassification
    func test_getVoiceClassification_ShouldCallPresenterToShowSelectedFoodOverview() {
        let data = makeSUTandDoubles()

        data.sut.getVoiceClassification(request: .init(text: "voice recognized text"))

        XCTAssertEqual(
            data.doubles.presenter.receivedMessages,
            [.presentFoodResumeFromVoiceCalled]
        )
    }

    //MARK: - refreshViewConfiguration
    func test_refreshViewConfiguration_ShouldCallPresenterToRefreshViewSettings() {
        let data = makeSUTandDoubles()
        let selectedFilterIndexPosition = 0

        data.sut.refreshViewConfiguration(request: .init(filterIndex: selectedFilterIndexPosition))

        XCTAssertEqual(
            data.doubles.presenter.receivedMessages,
            [.presentRefreshedViewCalled]
        )
    }

    //MARK: - refreshViewConfiguration
    func test_refreshViewConfiguration_ShouldCallPresenterToRefreshViewSettings() {
        let data = makeSUTandDoubles()
        let selectedFilterIndexPosition = 0

        data.sut.refreshViewConfiguration(request: .init(filterIndex: selectedFilterIndexPosition))

        XCTAssertEqual(
            data.doubles.presenter.receivedMessages,
            [.presentRefreshedViewCalled]
        )
    }
}

private extension InputsExplorerInteractorTests {
    func makeSUTandDoubles() -> InputsExplorerInteractorSUT {
        let mlWorker = MlWorkerMock()
        let httpWorker = HttpWorkerMock()
        let coredataWorker = CoreDataWorkerStub()
        let presenter = InputsExplorerPresenterSpy()

        let interactor = InputsExplorerInteractor(
            mlWorker: mlWorker,
            presenter: presenter,
            httpWorker: httpWorker,
            coredataWorker: coredataWorker
        )

        return InputsExplorerInteractorSUT(
            sut: interactor,
            doubles: ( mlWorker, httpWorker, coredataWorker, presenter )
        )
    }
}
