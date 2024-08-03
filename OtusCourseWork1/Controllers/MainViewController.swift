//
//  LocationUndefinedViewController.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 02.08.2024.
//

import UIKit

class MainViewController: UIViewController, LocationDetectorDelegate, CommonComponents {

    lazy var locationDetector = LocationDetector()
    var timeLabel = UILabel()
    let locationLabel: UILabel = UILabel()

    var currentLocationCity = ""
    var currentLocationCountry = ""
    
    var currentLocation: Location = Location() {
        didSet {
            print("Current location was set to \(currentLocation)")
            Task {
                await print(ForecaApiHandler.shared.getDetailedSingleDayForecast(zoneId: currentLocation.id))
            }
        }
    }

    var filteredLocationsAfterMapping = [Location]() {
        didSet {
            if filteredLocationsAfterMapping.count > 1 {
                DispatchQueue.main.async {
                    self.showLocationConflictViewController()
                }
            }
        }
    }

    var detailedSingleDayForecast: DetailedSingleDayForecast = DetailedSingleDayForecast() {
        didSet {
            print("Current location was set to \(currentLocation)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray3

        let mainScreenView = UIView()
        mainScreenView.translatesAutoresizingMaskIntoConstraints = false
        mainScreenView.backgroundColor = .white
        view.addSubview(mainScreenView)

        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.textAlignment = .center
        locationLabel.numberOfLines = 0
        locationLabel.lineBreakMode = .byWordWrapping

        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textAlignment = .center
        timeLabel.text = "Good \(TimeManager.shared.getTimeOfDay())!"

        mainScreenView.addSubview(locationLabel)
        mainScreenView.addSubview(timeLabel)

        locationDetector.delegate = self
        locationDetector.startUpdatingLocation()

        // Subscribe to locationUpdated notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleLocationUpdated), name: .locationUpdated, object: nil)

        // mainScreenView
        NSLayoutConstraint.activate([
            mainScreenView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScreenView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // locationLabel
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: mainScreenView.topAnchor, constant: 15),
            locationLabel.leadingAnchor.constraint(equalTo: mainScreenView.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: mainScreenView.trailingAnchor, constant: -20)
        ])

        // timeLabel
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: -5),
            timeLabel.leadingAnchor.constraint(equalTo: mainScreenView.leadingAnchor, constant: 20),
            timeLabel.trailingAnchor.constraint(equalTo: mainScreenView.trailingAnchor, constant: -20),
            timeLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc private func handleLocationUpdated() {
        Task {
            print("Fetching location list from API...")
            let locationsResult = await ForecaApiHandler.shared.fetchCityFromForecaLocationsBase(for: self.currentLocationCity)
            print("Fetched locations: \(locationsResult)")

            filteredLocationsAfterMapping = CityIdHelper.shared.compareLocations(result: locationsResult)
            print("\nFiltered Locations: \(filteredLocationsAfterMapping)\n")

            if(filteredLocationsAfterMapping.isEmpty){
                filteredLocationsAfterMapping = ForecaApiHandler.shared.extractLocations(from: locationsResult)
                print("\nCopy all locations to filtered array because was conflicts with area detection. FilteredLocationsAfterMapping: \n\n \(filteredLocationsAfterMapping)\n")
            }
        }
    }

    func didUpdateLocationName(_ locationName: String) {
        locationLabel.text = locationName

        let locationNameComponents = locationName.components(separatedBy: ",")

        if locationNameComponents.count == 2 {
            currentLocationCity = locationNameComponents[0].trimmingCharacters(in: .whitespacesAndNewlines)
            currentLocationCountry = locationNameComponents[1].trimmingCharacters(in: .whitespacesAndNewlines)

            // Send notification after updating the currentLocationCity
            NotificationCenter.default.post(name: .locationUpdated, object: nil)
        } else {
            print("Invalid location string")
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .locationUpdated, object: nil)
    }

    private func showLocationConflictViewController() {
        let locationConflictVC = LocationConflictViewController(locations: filteredLocationsAfterMapping)
        locationConflictVC.delegate = self // Устанавливаем делегата

        let navigationController = UINavigationController(rootViewController: locationConflictVC)
        navigationController.modalPresentationStyle = .pageSheet
        navigationController.modalTransitionStyle = .coverVertical

        present(navigationController, animated: true, completion: nil)
    }

    func updateLocation(_ location: Location) {
        locationLabel.text = "\(location.name), \(location.country)"
        currentLocation = location
    }
}

extension Notification.Name {
    static let locationUpdated = Notification.Name("locationUpdated")
}

extension MainViewController: LocationConflictViewControllerDelegate {
    func locationConflictViewController(_ controller: LocationConflictViewController, didSelectLocation location: Location) {
        updateLocation(location)
    }
}

