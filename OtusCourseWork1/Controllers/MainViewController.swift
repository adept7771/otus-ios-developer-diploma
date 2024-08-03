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
                detailedSingleDayForecast = await ForecaApiHandler.shared.getDetailedSingleDayForecast(zoneId: currentLocation.id)
                print(detailedSingleDayForecast)
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
            print("New forecast data: \(detailedSingleDayForecast) \n Presenting >>>>> \n")
            updateWeatherLabels()
        }
    }

    var temperatureLabel = UILabel(), feelsLikeTempLabel = UILabel(), precipProbLabel = UILabel(),
        relHumidityLabel = UILabel(), dewPointLabel = UILabel(), windSpeedLabel = UILabel(),
        windDirStringLabel = UILabel(), thunderProbLabel = UILabel(), cloudinessLabel = UILabel(),
        uvIndexLabel = UILabel(), pressureLabel = UILabel()

    // MARK: DidLoad -------------------------

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
        mainScreenView.addAndActivateConstraints(to: [.safeAreaTop(0), .safeAreaBottom(0), .leading(0), .trailing(0)], of: view)

        // locationLabel
        locationLabel.addAndActivateConstraints(to: [.top(15), .leading(20), .trailing(-20)], of: mainScreenView)
        locationLabel.addAndActivateConstraints(to: [.top(15, relativeTo: mainScreenView.topAnchor), .leading(20), .trailing(-20)], of: mainScreenView)

        // timeLabel
        timeLabel.addAndActivateConstraints(to: [.top(-5, relativeTo: locationLabel.bottomAnchor), .leading(20), .trailing(-20), .height(40)],
                                            of: mainScreenView)

        // Add weather labels to main screen view
        let weatherLabels = [temperatureLabel, feelsLikeTempLabel, relHumidityLabel, dewPointLabel,
                             windSpeedLabel, windDirStringLabel, thunderProbLabel, cloudinessLabel,
                             precipProbLabel, uvIndexLabel, pressureLabel]

        for label in weatherLabels {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .left
            mainScreenView.addSubview(label)
        }

        var previousLabel: UILabel = timeLabel
        for (index, label) in weatherLabels.enumerated() {
            if index == 0 {
                label.addAndActivateConstraints(
                    to: [
                        .top(10, relativeTo: previousLabel.bottomAnchor),
                        .leading(20),
                        .trailing(-20)
                    ],
                    of: mainScreenView
                )
            } else {
                // Последующие элементы устанавливаются относительно предыдущего label
                label.addAndActivateConstraints(
                    to: [
                        .top(10, relativeTo: previousLabel.bottomAnchor),
                        .leading(20),
                        .trailing(-20)
                    ],
                    of: mainScreenView
                )
            }
            previousLabel = label
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .locationUpdated, object: nil)
    }
}

extension MainViewController {

    // MARK: UI Methods -------------------------

    private func showLocationConflictViewController() {
        let locationConflictVC = LocationConflictViewController(locations: filteredLocationsAfterMapping)
        locationConflictVC.delegate = self // Устанавливаем делегата

        let navigationController = UINavigationController(rootViewController: locationConflictVC)
        navigationController.modalPresentationStyle = .pageSheet
        navigationController.modalTransitionStyle = .coverVertical

        present(navigationController, animated: true, completion: nil)
    }

    private func updateWeatherLabels() {
        temperatureLabel.text = "Temperature: \(detailedSingleDayForecast.current.temperature)"
        feelsLikeTempLabel.text = "Feels Like Temp: \(detailedSingleDayForecast.current.feelsLikeTemp)"
        relHumidityLabel.text = "Relative Humidity: \(detailedSingleDayForecast.current.relHumidity)"
        dewPointLabel.text = "Dew Point: \(detailedSingleDayForecast.current.dewPoint)"
        windSpeedLabel.text = "Wind Speed: \(detailedSingleDayForecast.current.windSpeed)"
        windDirStringLabel.text = "Wind Direction: \(detailedSingleDayForecast.current.windDirString)"
        thunderProbLabel.text = "Thunder Probability: \(detailedSingleDayForecast.current.thunderProb)"
        cloudinessLabel.text = "Cloudiness: \(detailedSingleDayForecast.current.cloudiness)"
        precipProbLabel.text = "Precipitation Probability: \(detailedSingleDayForecast.current.precipProb)"
        uvIndexLabel.text = "UV Index: \(detailedSingleDayForecast.current.uvIndex)"
        pressureLabel.text = "Pressure: \(detailedSingleDayForecast.current.pressure)"
    }
}

extension MainViewController {

    // MARK: Handler Methods -------------------------

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

