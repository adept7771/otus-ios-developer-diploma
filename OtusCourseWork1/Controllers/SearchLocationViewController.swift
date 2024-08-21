//
//  SearchLocationViewController.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 01.08.2024.
//

import Foundation
import UIKit

class SearchLocationViewController: UIViewController, CommonComponents {

    let searchScreenView = UIView()
    let titleLabelLocationSearch = UILabel()
    var locationTextField = UITextField()
    let locationSeekButton = UIButton()
    let forecastTableView = UITableView()

    // Флаг для контроля необходимости показа модального окна
    private var shouldPresentLocationSelectionModal = false

    var chosenLocation = "" {
        didSet {
            print("Current location was set BY USER CHOICE to \(chosenLocation). Start searching at foreca")
            Task {
                print("Fetching and extracting locations for \(chosenLocation)")
                let fetchedCities = await ApiHandlerForeca.shared.fetchCityFromForecaLocationsBase(for: chosenLocation)
                resultCities = ApiHandlerForeca.shared.extractLocations(from: fetchedCities)
            }
        }
    }

    var resultCities: [Location] = [] {
        didSet {
            switch resultCities.count {
            case 0:
                showAlert(title: "ForecaDB search error", message: "No locations found in DB for \(chosenLocation). Try to change location name (choose another)")
            case 1:
                resultCity = resultCities.first!
            case _ where resultCities.count > 1:
                if shouldPresentLocationSelectionModal {
                    presentLocationSelectionModal()
                    shouldPresentLocationSelectionModal = false // Сбрасываем флаг после показа модального окна
                }
            default:
                print("Unexpected resultCities state")
            }
        }
    }

    var resultCity: Location = Location() {
        didSet {
            print("Selected city: \(resultCity.name) \(resultCity.country) \(resultCity.timezone)")

            Task {
                print("Getting forecast for \(resultCity.name)")
                weeklySingleDayForecast = await ApiHandlerForeca.shared.getWeeklyForecast(zoneId: resultCity.id)
            }
        }
    }

    var weeklySingleDayForecast: [WeeklySingleDay] = [] {
        didSet {
            print("Showing weekly forecast for \(resultCity.name)")
            forecastTableView.reloadData() // Обновление таблицы
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray3

        configureSearchScreenView(searchScreenView: searchScreenView)

        configureTitleLabel(searchScreenView: searchScreenView)
        configureLocationTextField(searchScreenView: searchScreenView)
        configureSearchButton(searchScreenView: searchScreenView)

        configureForecastTableView(searchScreenView: searchScreenView)

        locationSeekButton.addTarget(self, action: #selector(handleSearchButtonTapped), for: .touchUpInside)
        locationSeekButton.addTarget(self, action: #selector(buttonTouchDown), for: [.touchDown, .touchDragEnter])
        locationSeekButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchCancel, .touchDragExit])
    }

    @objc private func handleSearchButtonTapped() {
        guard let locationText = locationTextField.text, !locationText.isEmpty else {
            showAlert(title: "Error", message: "Please enter a location name")
            return
        }
        chosenLocation = locationText
        shouldPresentLocationSelectionModal = true
    }

    @objc private func buttonTouchDown() {
        animateButtonPress(isPressed: true)
    }

    @objc private func buttonTouchUp() {
        animateButtonPress(isPressed: false)
    }

    private func animateButtonPress(isPressed: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.locationSeekButton.transform = isPressed ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
            self.locationSeekButton.backgroundColor = isPressed ? .systemBlue.withAlphaComponent(0.8) : .systemBlue
        }
    }

    // Метод для отображения модального экрана с выбором локации если у нас несколько совпадений по названию локи
    private func presentLocationSelectionModal() {
        let locationSelectionVC = LocationSelectionViewController()
        locationSelectionVC.locations = resultCities
        locationSelectionVC.delegate = self
        locationSelectionVC.modalPresentationStyle = .automatic
        present(locationSelectionVC, animated: true, completion: nil)
    }

    private func configureForecastTableView(searchScreenView: UIView) {
        forecastTableView.dataSource = self
        forecastTableView.delegate = self
        forecastTableView.register(UITableViewCell.self, forCellReuseIdentifier: "forecastCell")
        searchScreenView.addSubview(forecastTableView)

        forecastTableView.addAndActivateConstraints(to: [
            .top(20, relativeTo: locationSeekButton.bottomAnchor),
            .leading(20),
            .trailing(-20),
            .bottom(0, relativeTo: searchScreenView.bottomAnchor)
        ], of: searchScreenView)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate -------------------------
extension SearchLocationViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklySingleDayForecast.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath)
        let dayForecast = weeklySingleDayForecast[indexPath.row]
        cell.textLabel?.text = "\(dayForecast.date): \(dayForecast.minTemp)°C - \(dayForecast.maxTemp)°C, Wind M/s: \(dayForecast.maxWindSpeed)"
        return cell
    }
}

// MARK: UI Methods -------------------------
extension SearchLocationViewController {

    private func configureSearchScreenView(searchScreenView: UIView) {
        searchScreenView.backgroundColor = .white
        view.addSubview(searchScreenView)
        searchScreenView.addAndActivateConstraints(to: [.safeAreaTop(0), .safeAreaBottom(0), .leading(0), .trailing(0)], of: view)
    }

    private func configureTitleLabel(searchScreenView: UIView) {
        titleLabelLocationSearch.text = "Location search"
        titleLabelLocationSearch.textAlignment = .center
        titleLabelLocationSearch.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        searchScreenView.addSubview(titleLabelLocationSearch)

        titleLabelLocationSearch.addAndActivateConstraints(to: [
            .top(20, relativeTo: searchScreenView.topAnchor),
            .leading(20),
            .trailing(-20)
        ], of: searchScreenView)
    }

    private func configureLocationTextField(searchScreenView: UIView) {
        locationTextField.placeholder = "Enter Location Name"
        locationTextField.borderStyle = .roundedRect
        locationTextField.delegate = self
        searchScreenView.addSubview(locationTextField)

        locationTextField.addAndActivateConstraints(to: [
            .top(20, relativeTo: titleLabelLocationSearch.bottomAnchor),
            .leading(20),
            .trailing(-20)
        ], of: searchScreenView)
    }

    private func configureSearchButton(searchScreenView: UIView) {
        locationSeekButton.setTitle("Get forecast for location", for: .normal)
        locationSeekButton.setTitleColor(.white, for: .normal)
        locationSeekButton.backgroundColor = .systemBlue
        locationSeekButton.layer.cornerRadius = 8 // Закругление углов

        searchScreenView.addSubview(locationSeekButton)

        locationSeekButton.addAndActivateConstraints(to: [
            .top(20, relativeTo: locationTextField.bottomAnchor),
            .leading(20),
            .trailing(-20),
            .height(30)
        ], of: searchScreenView)
    }
}

// MARK: UITextFieldDelegate -------------------------
extension SearchLocationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        chosenLocation = textField.text ?? ""
    }
}

extension SearchLocationViewController: LocationSelectionDelegate {
    func didChooseLocation(_ location: Location) {
        resultCity = location
        resultCities = [] // Очищаем resultCities после выбора города
        print("Selected city: \(resultCity.name)")
    }
}

protocol LocationSelectionDelegate: AnyObject {
    func didChooseLocation(_ location: Location)
}

class LocationSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var locations: [Location] = []
    weak var delegate: LocationSelectionDelegate?
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
    }

    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let currentLocation = locations[indexPath.row]
        cell.textLabel?.text = "\(currentLocation.name) \(currentLocation.country) \(currentLocation.timezone)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = locations[indexPath.row]
        delegate?.didChooseLocation(selectedLocation)
        dismiss(animated: true, completion: nil)
    }
}
