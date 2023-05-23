//
//  OverviewItemCell.swift
//  NutriScan
//
//  Created by Yago Marques on 16/05/23.
//

import UIKit

final class OverviewItemCell: UITableViewCell {
    static let identifier = "OverviewItemCell"

    private let titleStep: UILabel = {
        let titleStep = UILabel()
        titleStep.translatesAutoresizingMaskIntoConstraints = false
        titleStep.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleStep.numberOfLines = 0
        return titleStep
    }()

    private let wayPoint: UIView = {
        let point = UIView()
        point.translatesAutoresizingMaskIntoConstraints = false
        point.layer.cornerCurve = .circular
        point.layer.cornerRadius = 10
        point.backgroundColor = UIColor(named: "NSGreen")

        return point
    }()

    private let wayRoute: UIView = {
        let route = UIView()
        route.translatesAutoresizingMaskIntoConstraints = false
        route.backgroundColor = UIColor(named: "NSGreen")

        return route
    }()

    private let descriptionStep: UILabel = {
        let descriptionStep = UILabel()
        descriptionStep.translatesAutoresizingMaskIntoConstraints = false
        descriptionStep.numberOfLines = 0
        return descriptionStep
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        buildLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension OverviewItemCell {
    func configureCellInformations(title: String, description: String, isLast: Bool) {
        titleStep.text = title
        descriptionStep.text = description
        if !isLast {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.addRouteIfNeeded()
            }
        }
    }

    func addRouteIfNeeded() {
        self.addSubview(wayRoute)

        NSLayoutConstraint.activate([
            wayRoute.topAnchor.constraint(equalTo: wayPoint.centerYAnchor),
            wayRoute.widthAnchor.constraint(equalToConstant: 1),
            wayRoute.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4),
            wayRoute.centerXAnchor.constraint(equalTo: wayPoint.centerXAnchor)
        ])
    }
}

extension OverviewItemCell: ViewCoding {
    func setupView() {
        self.selectionStyle = .none
//        self.backgroundColor = .green
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            wayPoint.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            wayPoint.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            wayPoint.widthAnchor.constraint(equalToConstant: 20),
            wayPoint.heightAnchor.constraint(equalTo: wayPoint.widthAnchor),

            titleStep.topAnchor.constraint(equalTo: wayPoint.topAnchor),
            titleStep.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 8),
            titleStep.leadingAnchor.constraint(equalTo: wayPoint.trailingAnchor, constant: 20),


            descriptionStep.topAnchor.constraint(equalToSystemSpacingBelow: titleStep.bottomAnchor, multiplier: 1),
            descriptionStep.leadingAnchor.constraint(equalTo: titleStep.leadingAnchor),
            descriptionStep.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            descriptionStep.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)

        ])
    }

    func setupHierarchy() {
        addSubview(wayPoint)
        addSubview(titleStep)
        addSubview(descriptionStep)
    }
}
