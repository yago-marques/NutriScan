//
//  FoodOverviewView.swift
//  NutriScan
//
//  Created by Yago Marques on 15/05/23.
//

import UIKit

final class FoodOverviewView: UIView {
    weak var controller: FoodOverviewController?
    private var selectedFood: Food? = nil

    private let banner: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "NSGreen")

        return view
    }()

    private let image: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit

        return image
    }()

    private let name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        label.numberOfLines = 0

        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(OverviewItemCell.self, forCellReuseIdentifier: OverviewItemCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

    init(frame: CGRect, controller: FoodOverviewController? = nil) {
        self.controller = controller
        super.init(frame: frame)

        buildLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupOverview(with food: Food) {
        self.selectedFood = food
        self.name.text = selectedFood?.name.capitalized
    }
}

extension FoodOverviewView: ViewCoding {
    func setupView() {
        self.backgroundColor = .systemBackground
    }

    func setupHierarchy() {
        addSubview(banner)
        addSubview(image)
        addSubview(name)
        addSubview(tableView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            banner.widthAnchor.constraint(equalTo: widthAnchor),
            banner.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            banner.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),

            image.centerYAnchor.constraint(equalTo: banner.bottomAnchor),
            image.leadingAnchor.constraint(equalToSystemSpacingAfter: banner.leadingAnchor, multiplier: 5),
            image.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            image.heightAnchor.constraint(equalTo: image.widthAnchor),

            name.leadingAnchor.constraint(equalToSystemSpacingAfter: image.trailingAnchor, multiplier: 1),
            name.bottomAnchor.constraint(equalTo: banner.bottomAnchor, constant: -5),
            name.trailingAnchor.constraint(equalTo: banner.trailingAnchor, constant: -20),

            tableView.topAnchor.constraint(equalToSystemSpacingBelow: image.bottomAnchor, multiplier: 5),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
}


extension FoodOverviewView: UITableViewDelegate { }

extension FoodOverviewView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedFood?.itens.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if
            let cell = tableView.dequeueReusableCell(withIdentifier: OverviewItemCell.identifier) as? OverviewItemCell,
            let itens = selectedFood?.itens
        {

            cell.configureCellInformations(
                title: itens[indexPath.row].title,
                description: itens[indexPath.row].description,
                isLast: indexPath.row == (itens.count - 1)
            )

            return cell
        } else {
            return UITableViewCell()
        }
    }
}
