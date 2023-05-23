//
//  InputsExplorerView.swift
//  NutriScan
//
//  Created by Yago Marques on 06/05/23.
//

import UIKit
import Lottie

enum FoodCategory: String {
    case vegetable = "Legume"
    case fruit = "Fruta"
    case all = "Todos"
}

enum FoodActivityStatus {
    case start, stop
}

protocol InputsExplorerViewDelegate {
    func updateFoodGrid(viewModels: [Food])
    func showConnectivityErrorView(_ viewModel: InputsExplorer.ConnectivityError.ViewModel)
    func startActivityLoading()
    func stopActivityLoading()
    func showEmptyFoodView(_ viewModel: InputsExplorer.EmptyFoodNotification.ViewModel)
    func hideEmptyFoodView()
    func refreshView(index: Int)
}

final class InputsExplorerView: UIView, InputsExplorerViewDelegate {

    // MARK: - Dependencies
    weak var controller: InputsExplorerControllerDelegate?

    // MARK: - UI Components
    private lazy var cameraTopButtonItem: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonHandler))
    }()

    private lazy var cameraInputPicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        picker.cameraCaptureMode = .photo

        return picker
    }()

    private lazy var libraryInputPicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self

        return picker
    }()

    private lazy var mediaOptionsSheet: UIAlertController = {
        let alertSheet = UIAlertController(
            title: "Escolha uma foto",
            message: "Você pode tirar uma foto com a câmera ou escolher alguma da sua galeria",
            preferredStyle: .actionSheet
        )

        let libraryAction = UIAlertAction(title: "Galeria", style: .default) { [weak self] _ in
            guard let self else { return }
            self.controller?.presentMedia(self.libraryInputPicker)
        }

        let cameraAction = UIAlertAction(title: "Câmera", style: .default) { [weak self] _ in
            guard let self else { return }
            self.controller?.presentMedia(self.cameraInputPicker)
        }

        let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive)

        alertSheet.addAction(cameraAction)
        alertSheet.addAction(libraryAction)
        alertSheet.addAction(cancelAction)

        return alertSheet
    }()

    private lazy var headerView: ExplorerHeaderView = {
        let header = ExplorerHeaderView(frame: .zero, view: self)
        header.translatesAutoresizingMaskIntoConstraints = false

        return header
    }()

    lazy var filterSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [
            FoodCategory.all.rawValue,
            FoodCategory.fruit.rawValue + "s",
            FoodCategory.vegetable.rawValue + "s"
        ])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(filterFoods), for: .valueChanged)

        return control
    }()

    lazy var foodGrid: ExplorerGrid = {
        let grid = ExplorerGrid(frame: .zero, view: self)
        grid.translatesAutoresizingMaskIntoConstraints = false

        return grid
    }()

    private let connectivityErrorView: GenericErrorView = {
        let errorView = GenericErrorView()
        errorView.translatesAutoresizingMaskIntoConstraints = false

        return errorView
    }()

    private let emptyFoodsView: GenericErrorView = {
        let errorView = GenericErrorView()
        errorView.translatesAutoresizingMaskIntoConstraints = false

        return errorView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true

        return indicator
    }()

    private let voicePreviewArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerCurve = .circular
        view.layer.cornerRadius = 20

        return view
    }()

    private let voicePreviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center

        return label
    }()

    private let previewInstruction: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .thin)

        return label
    }()

    let voiceInputAnimation: LottieAnimationView = {
        let animationView = LottieAnimationView(animation: LottieAnimation.named("voiceInput"))
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop

        return animationView
    }()

    // MARK: - Initializers
    init(frame: CGRect , controller: InputsExplorerControllerDelegate? = nil) {
        self.controller = controller
        super.init(frame: frame)

        buildLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    private func playDocumentScanner() {
        controller?.presentMediaOptions(mediaOptionsSheet)
    }

    func setup(controller: InputsExplorerControllerDelegate) {
        self.controller = controller

        self.controller?.setTopBarButtons([cameraTopButtonItem])
    }

    func updateFoodGrid(viewModels: [Food]) {
        foodGrid.foods = viewModels
    }

    func searchFoods(searchBy: String) {
        controller?.searchFoods(searchBy: searchBy)
    }

    func showOverview(of selectedFood: Food) {
        controller?.showOverview(of: selectedFood)
    }

    func startActivityLoading() {
        DispatchQueue.main.async { [unowned self] in
            self.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()

            NSLayoutConstraint.activate([
                self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ])
        }
    }

    func stopActivityLoading() {
        DispatchQueue.main.async { [unowned self] in
            self.activityIndicator.stopAnimating()
        }
    }

    func showConnectivityErrorView(_ viewModel: InputsExplorer.ConnectivityError.ViewModel) {
        DispatchQueue.main.async { [unowned self] in
            self.addSubview(self.connectivityErrorView)
            self.connectivityErrorView.setup(viewModel: viewModel.data)

            NSLayoutConstraint.activate([
                self.connectivityErrorView.topAnchor.constraint(equalToSystemSpacingBelow: self.foodGrid.topAnchor , multiplier: 5),
                self.connectivityErrorView.widthAnchor.constraint(equalTo: self.widthAnchor),
                self.connectivityErrorView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
                self.connectivityErrorView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        }
    }

    func showEmptyFoodView(_ viewModel: InputsExplorer.EmptyFoodNotification.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.addSubview(self.emptyFoodsView)
            self.emptyFoodsView.setup(viewModel: viewModel.data)

            NSLayoutConstraint.activate([
                self.emptyFoodsView.topAnchor.constraint(equalToSystemSpacingBelow: self.foodGrid.topAnchor , multiplier: 5),
                self.emptyFoodsView.widthAnchor.constraint(equalTo: self.widthAnchor),
                self.emptyFoodsView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
                self.emptyFoodsView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        }
    }

    func hideEmptyFoodView() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            if !self.emptyFoodsView.isHidden {
                self.emptyFoodsView.removeFromSuperview()
            }
        }
    }

    func showVoicePreview(instruction: String) {
        withAnimation(speed: 0.3) {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.addSubview(self.voicePreviewArea)
                self.addSubview(self.voicePreviewLabel)
                self.addSubview(self.previewInstruction)
                self.addSubview(self.voiceInputAnimation)

                NSLayoutConstraint.activate([
                    self.voicePreviewArea.widthAnchor.constraint(equalTo: self.widthAnchor),
                    self.voicePreviewArea.heightAnchor.constraint(equalTo: self.voicePreviewArea.widthAnchor),
                    self.voicePreviewArea.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    self.voicePreviewArea.bottomAnchor.constraint(equalTo: self.bottomAnchor),

                    self.voicePreviewLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    self.voicePreviewLabel.centerYAnchor.constraint(equalTo: self.voicePreviewArea.centerYAnchor, constant: 10),
                    self.voicePreviewLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),

                    self.previewInstruction.topAnchor.constraint(equalToSystemSpacingBelow: self.voicePreviewArea.topAnchor, multiplier: 2),
                    self.previewInstruction.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    self.previewInstruction.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),

                    self.voiceInputAnimation.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    self.voiceInputAnimation.centerYAnchor.constraint(equalTo: self.voicePreviewLabel.centerYAnchor),
                    self.voiceInputAnimation.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
                    self.voiceInputAnimation.heightAnchor.constraint(equalTo: self.voiceInputAnimation.widthAnchor)
                ])

                self.previewInstruction.text = instruction
                self.voiceInputAnimation.play()
            }
        }
    }

    func hideVoicePreview() {
        withAnimation(speed: 0.5) {
            self.voicePreviewArea.removeFromSuperview()
            self.voicePreviewLabel.removeFromSuperview()
            self.previewInstruction.removeFromSuperview()

            if !self.voiceInputAnimation.isHidden {
                self.voiceInputAnimation.removeFromSuperview()
            }
        }
    }

    func updateVoicePreview(text: String) {
        withAnimation(speed: 0.1) {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                self.voiceInputAnimation.removeFromSuperview()
                self.voicePreviewLabel.text = text
            }
        }
    }

    func refreshView(index: Int) {
        headerView.resetSearch()
        filterSegmentedControl.selectedSegmentIndex = index
    }

    // MARK: - @objc Methods
    @objc
    private func cameraButtonHandler() {
        playDocumentScanner()
    }

    @objc
    func filterFoods() {
        switch filterSegmentedControl.selectedSegmentIndex {
        case 0:
            controller?.filterFoods(filterBy: FoodCategory.all.rawValue)
        case 1:
            controller?.filterFoods(filterBy: FoodCategory.fruit.rawValue)
        case 2:
            controller?.filterFoods(filterBy: FoodCategory.vegetable.rawValue)
        default:
            controller?.filterFoods(filterBy: FoodCategory.all.rawValue)
        }
    }

}

// MARK: - Conformed Protocols Implementations
extension InputsExplorerView: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        controller?.getClassification(for: image)
    }
}

extension InputsExplorerView: UINavigationControllerDelegate { }

extension InputsExplorerView: ViewCoding {
    func setupView() {
        self.backgroundColor = .systemBackground
    }

    func setupHierarchy() {
        self.addSubview(headerView)
        self.addSubview(filterSegmentedControl)
        self.addSubview(foodGrid)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.93),
            headerView.heightAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.2),

            filterSegmentedControl.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            filterSegmentedControl.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            filterSegmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),

            foodGrid.topAnchor.constraint(equalToSystemSpacingBelow: filterSegmentedControl.bottomAnchor, multiplier: 3),
            foodGrid.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95),
            foodGrid.centerXAnchor.constraint(equalTo: centerXAnchor),
            foodGrid.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
