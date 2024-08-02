import UIKit
import Combine

class MainViewController: UIViewController, LocationManagerDelegate, CommonComponents {

    lazy var locationManager = LocationManager()

    let locationLabel = UILabel()
    var timeLabel = UILabel()
    var currentLocationCity = ""
    var currentLocationCountry = ""
    var filteredLocationsAfterMapping = [Location]()

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

        locationManager.delegate = self
        locationManager.startUpdatingLocation()

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
            let locationsResult = await ApiHandler.shared.fetchCityFromLocationsBase(for: currentLocationCity)
            print("Fetched locations: \(locationsResult)")

            filteredLocationsAfterMapping = CityIdHelper.shared.compareLocations(result: locationsResult)
            print("\nFiltered Locations: \(filteredLocationsAfterMapping)\n")
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
}

extension Notification.Name {
    static let locationUpdated = Notification.Name("locationUpdated")
}
