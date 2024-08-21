//
//  RandomLocationViewController.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 21.08.2024.
//

import Foundation
import UIKit

class RandomLocationViewController: UIViewController, CommonComponents {

    let randomLocationView = UIView()
    let titleLabelRandomLocation = UILabel()
    let getRandomLocationForecastButton = UIButton()
    let forecastTableView = UITableView()

    var randomCityForecast: [WeeklySingleDay] = [] {
        didSet {
            if !randomCityForecast.isEmpty {
                forecastTableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray3
        configureRandomLocationView(randomLocationView: randomLocationView)
        configureTitleLabel(randomLocationView: randomLocationView)
        configureGetRandomForecastButton(randomLocationView: randomLocationView)
        configureForecastTableView(randomLocationView: randomLocationView)

        getRandomLocationForecastButton.addTarget(self, action: #selector(handleGetRandomForecastTapped), for: .touchUpInside)
        getRandomLocationForecastButton.addTarget(self, action: #selector(buttonTouchDown), for: [.touchDown, .touchDragEnter])
        getRandomLocationForecastButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchCancel, .touchDragExit])
    }

    @objc private func handleGetRandomForecastTapped() {
        getForecastForRandomLocation()
    }

    private func getForecastForRandomLocation() {
        var fetchedCities: Result<[Location], NetworkError> = .success([])

        Task {
            await fetchedCities = ApiHandlerForeca.shared.fetchCityFromForecaLocationsBase(for: EuropeanCities.randomCapital())
            let locations = ApiHandlerForeca.shared.extractLocations(from: fetchedCities)

            let locationOpt: Location? = locations.count == 1
                ? locations.first
                : locations.randomElement()

            guard let finalRandomLocation = locationOpt else {
                showAlert(title: "Random city exception", message: "Can't get random city for forecast")
                return
            }

            titleLabelRandomLocation.text = "\(finalRandomLocation.name) location forecast"

            randomCityForecast = await ApiHandlerForeca.shared.getWeeklyForecast(zoneId: finalRandomLocation.id)
        }
    }
}

extension RandomLocationViewController {

    private func configureRandomLocationView(randomLocationView: UIView) {
        randomLocationView.backgroundColor = .white
        view.addSubview(randomLocationView)
        randomLocationView.addAndActivateConstraints(to: [.safeAreaTop(0), .safeAreaBottom(0), .leading(0), .trailing(0)], of: view)
    }

    private func configureTitleLabel(randomLocationView: UIView) {
        titleLabelRandomLocation.text = "Random location forecast"
        titleLabelRandomLocation.textAlignment = .center
        titleLabelRandomLocation.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        randomLocationView.addSubview(titleLabelRandomLocation)

        titleLabelRandomLocation.addAndActivateConstraints(to: [
            .top(20, relativeTo: randomLocationView.topAnchor),
            .leading(20),
            .trailing(-20)
        ], of: randomLocationView)
    }

    private func configureGetRandomForecastButton(randomLocationView: UIView) {
        getRandomLocationForecastButton.setTitle("Get random forecast", for: .normal)
        getRandomLocationForecastButton.setTitleColor(.white, for: .normal)
        getRandomLocationForecastButton.backgroundColor = .systemBlue
        getRandomLocationForecastButton.layer.cornerRadius = 8

        randomLocationView.addSubview(getRandomLocationForecastButton)

        getRandomLocationForecastButton.addAndActivateConstraints(to: [
            .top(20, relativeTo: titleLabelRandomLocation.bottomAnchor),
            .leading(20),
            .trailing(-20),
            .height(30)
        ], of: randomLocationView)
    }

    private func configureForecastTableView(randomLocationView: UIView) {
        forecastTableView.dataSource = self
        forecastTableView.delegate = self
        forecastTableView.register(UITableViewCell.self, forCellReuseIdentifier: "forecastCell")
        randomLocationView.addSubview(forecastTableView)

        forecastTableView.addAndActivateConstraints(to: [
            .top(20, relativeTo: getRandomLocationForecastButton.bottomAnchor),
            .leading(20),
            .trailing(-20),
            .bottom(0, relativeTo: randomLocationView.bottomAnchor)
        ], of: randomLocationView)
    }

    @objc private func buttonTouchDown() {
        animateButtonPress(isPressed: true)
    }

    @objc private func buttonTouchUp() {
        animateButtonPress(isPressed: false)
    }

    private func animateButtonPress(isPressed: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.getRandomLocationForecastButton.transform = isPressed ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
            self.getRandomLocationForecastButton.backgroundColor = isPressed ? .systemBlue.withAlphaComponent(0.8) : .systemBlue
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension RandomLocationViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randomCityForecast.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath)
        let dayForecast = randomCityForecast[indexPath.row]
        cell.textLabel?.text = "\(dayForecast.date): \(dayForecast.minTemp)°C - \(dayForecast.maxTemp)°C, Wind m/s \(dayForecast.maxWindSpeed)"
        return cell
    }
}

enum EuropeanCities: String, CaseIterable {
    case amsterdam = "Amsterdam"
    case athens = "Athens"
    case belgrade = "Belgrade"
    case berlin = "Berlin"
    case bern = "Bern"
    case bratislava = "Bratislava"
    case brussels = "Brussels"
    case bucharest = "Bucharest"
    case budapest = "Budapest"
    case copenhagen = "Copenhagen"
    case dublin = "Dublin"
    case helsinki = "Helsinki"
    case kyiv = "Kyiv"
    case lisbon = "Lisbon"
    case ljubljana = "Ljubljana"
    case london = "London"
    case luxembourg = "Luxembourg"
    case madrid = "Madrid"
    case minsk = "Minsk"
    case moscow = "Moscow"
    case oslo = "Oslo"
    case paris = "Paris"
    case prague = "Prague"
    case reykjavik = "Reykjavik"
    case riga = "Riga"
    case rome = "Rome"
    case sofia = "Sofia"
    case stockholm = "Stockholm"
    case tallinn = "Tallinn"
    case vienna = "Vienna"
    case vilnius = "Vilnius"
    case warsaw = "Warsaw"
    case zagreb = "Zagreb"

    static func randomCapital() -> String {
        return EuropeanCities.allCases.randomElement()?.rawValue ?? ""
    }
}
