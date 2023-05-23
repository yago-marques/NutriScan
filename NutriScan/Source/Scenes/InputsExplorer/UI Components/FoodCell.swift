//
//  FoodCell.swift
//  NutriScan
//
//  Created by Yago Marques on 12/05/23.
//

import UIKit

final class FoodCell: UICollectionViewCell {

    static let identifier = "foodCell"

    private let foodImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit

        return image
    }()

    private let foodName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center

        return label
    }()

    private let stack: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        buildLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(food: Food) {
        self.foodName.text = food.name.capitalized
    }
}

extension FoodCell: ViewCoding {
    func setupView() {
        self.layer.cornerCurve = .circular
        self.layer.cornerRadius = 10
        self.backgroundColor = .systemGray6
    }

    func setupHierarchy() {
        self.addSubview(stack)
        stack.addSubview(foodImage)
        stack.addSubview(foodName)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            stack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),

            foodImage.widthAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.8),
            foodImage.heightAnchor.constraint(equalTo: foodImage.widthAnchor),
            foodImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            foodImage.topAnchor.constraint(equalTo: stack.topAnchor),

            foodName.centerXAnchor.constraint(equalTo: centerXAnchor),
            foodName.widthAnchor.constraint(equalTo: stack.widthAnchor),
            foodName.bottomAnchor.constraint(equalTo: stack.bottomAnchor)
        ])
    }
}
