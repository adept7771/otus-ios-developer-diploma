//
//  LocationUndefinedViewController.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 02.08.2024.
//

import Foundation
import UIKit

class LocationConflictViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var locations: [Location]

    let explanationLabel = UILabel()
    let tableView = UITableView()

    init(locations: [Location] = [Location]()) {
        self.locations = locations
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Conflicts with area detecting!"
        view.backgroundColor = .white

        setupExplanationLabel()
        setupTableView()
    }

    private func setupExplanationLabel() {
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.textAlignment = .center

        explanationLabel.text = "While determining your GPS coordinates, several locations were found that have the same name as your current location. Please select the location that is your current one from list."
        
        explanationLabel.numberOfLines = 0
        explanationLabel.lineBreakMode = .byWordWrapping

        view.addSubview(explanationLabel)
        NSLayoutConstraint.activate([
            explanationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            explanationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            explanationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: "LocationCell")

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationTableViewCell
        let location = locations[indexPath.row]
        cell.configure(with: location)
        return cell
    }

    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
}

class LocationTableViewCell: UITableViewCell {

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with location: Location) {
        descriptionLabel.text = """
        Name: \(location.name)
        Country: \(location.country)
        Timezone: \(location.timezone)
        Language: \(location.language)
        Admin Area: \(location.adminArea)
        Admin Area 2: \(location.adminArea2 ?? "N/A")
        Admin Area 3: \(location.adminArea3 ?? "N/A")
        Longitude: \(location.lon)
        Latitude: \(location.lat)
        """
    }
}



