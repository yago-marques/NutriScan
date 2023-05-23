//
//  InternetErrorView.swift
//  NutriScan
//
//  Created by Yago Marques on 16/05/23.
//

import UIKit

final class GenericErrorView: UIView {

    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0

        return label
    }()

    private let message: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        buildLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(viewModel: GenericErrorViewModel) {
        self.image.image = UIImage(systemName: viewModel.image)
        self.title.text = viewModel.title
        self.message.text = viewModel.message
    }

}

extension GenericErrorView: ViewCoding {
    func setupView() {
        self.backgroundColor = .systemBackground
    }

    func setupHierarchy() {
        self.addSubview(image)
        self.addSubview(title)
        self.addSubview(message)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: 40),
            image.heightAnchor.constraint(equalTo: image.widthAnchor),

            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            title.topAnchor.constraint(equalToSystemSpacingBelow: image.bottomAnchor, multiplier: 2),

            message.centerXAnchor.constraint(equalTo: centerXAnchor),
            message.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            message.topAnchor.constraint(equalToSystemSpacingBelow: title.bottomAnchor, multiplier: 1)
        ])
    }
}

