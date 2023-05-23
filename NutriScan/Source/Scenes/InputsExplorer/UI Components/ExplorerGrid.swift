//
//  ExplorerCarousel.swift
//  NutriScan
//
//  Created by Yago Marques on 10/05/23.
//

import UIKit

final class ExplorerGrid: UIView {
    var foods = [Food]() {
        didSet {
            DispatchQueue.main.async {
                self.gridCollection.reloadData()
            }
        }
    }

    weak var mainView: InputsExplorerView?

    private let collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        return layout
    }()

    private lazy var gridCollection: UICollectionView = {
        let myCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionLayout)
        myCollectionView.register(FoodCell.self, forCellWithReuseIdentifier: FoodCell.identifier)
        myCollectionView.backgroundColor = .clear
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView.showsHorizontalScrollIndicator = false

        return myCollectionView
    }()

    init(frame: CGRect, view: InputsExplorerView) {
        self.mainView = view
        super.init(frame: frame)

        buildLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExplorerGrid: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.foods.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = gridCollection.dequeueReusableCell(withReuseIdentifier: FoodCell.identifier, for: indexPath) as? FoodCell else {
            return UICollectionViewCell()
        }

        cell.setup(food: foods[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mainView?.showOverview(of: foods[indexPath.row])
    }
}

extension ExplorerGrid: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = gridCollection.frame.width
        return CGSize(width: width * 0.485, height: width * 0.48)
    }
}

extension ExplorerGrid: ViewCoding {
    func setupView() { }

    func setupHierarchy() {
        self.addSubview(gridCollection)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            gridCollection.topAnchor.constraint(equalTo: topAnchor),
            gridCollection.bottomAnchor.constraint(equalTo: bottomAnchor),
            gridCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            gridCollection.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }


}
