import UIKit

class MainViewController: UIViewController, LocationDetectorDelegate, CommonComponents, UITableViewDataSource, UITableViewDelegate {

    let mainScreenView = UIView()

    lazy var locationDetector = LocationDetector()
    var timeLabel = UILabel()
    let locationLabel: UILabel = UILabel()

    var currentLocationCity = ""
    var currentLocationCountry = ""

    var currentLocation: Location = Location() {
        didSet {
            print("Current location was set BY USER CHOICE to \(currentLocation)")
            Task {
                detailedSingleDayForecast = await ApiHandlerForeca.shared.getDetailedSingleDayForecast(zoneId: currentLocation.id)
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
            } else if filteredLocationsAfterMapping.count == 1 {
                // Если нет конфликтов, обновляем текущую локацию и погоду
                if let location = filteredLocationsAfterMapping.first {
                    updateLocation(location)
                }
            }
        }
    }

    var temperatureLabel = UILabel(), feelsLikeTempLabel = UILabel(), precipProbLabel = UILabel(),
        relHumidityLabel = UILabel(), dewPointLabel = UILabel(), windSpeedLabel = UILabel(),
        windDirStringLabel = UILabel(), thunderProbLabel = UILabel(), cloudinessLabel = UILabel(),
        uvIndexLabel = UILabel(), pressureLabel = UILabel()

    var detailedSingleDayForecast: DetailedSingleDayForecast = DetailedSingleDayForecast() {
        didSet {
            print("\nNew detailedSingleDayForecast data Presenting >>>> \n \(detailedSingleDayForecast) \n")
            updateWeatherLabels()
            Task {
                currentLocation7DayForecast = await requestParseAndSave7DayForecast(zoneId: currentLocation.id)
            }
        }
    }

    private var tableView7daysForecastCurrentLocation: UITableView = UITableView()

    var currentLocation7DayForecast: [WeeklySingleDay] = [WeeklySingleDay]() {
        didSet {
            print("\nNew currentLocation7DayForecast data. Presenting >>>>> \n \(currentLocation7DayForecast) \n")
            tableView7daysForecastCurrentLocation.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray3

        configureMainView(mainScreenView: mainScreenView)

        showLocationLabel(mainScreenView: mainScreenView)
        showTimeLabel(mainScreenView: mainScreenView)

        // Добавление всех необходимых сабвью перед установкой ограничений
        addWeatherLabelsForCurrentDayForecastToMainScreen(mainScreenView: mainScreenView)
        setuptableView7daysForecastCurrentLocation(in: mainScreenView)

        // Delegates
        locationDetector.delegate = self
        locationDetector.startUpdatingLocation()
    }
}

// MARK: UI Methods -------------------------
extension MainViewController {

    private func setuptableView7daysForecastCurrentLocation(in mainScreenView: UIView) {
        tableView7daysForecastCurrentLocation = UITableView(frame: .zero, style: .plain)
        tableView7daysForecastCurrentLocation.translatesAutoresizingMaskIntoConstraints = false
        tableView7daysForecastCurrentLocation.backgroundColor = .clear
        tableView7daysForecastCurrentLocation.dataSource = self
        tableView7daysForecastCurrentLocation.delegate = self
        tableView7daysForecastCurrentLocation.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        mainScreenView.addSubview(tableView7daysForecastCurrentLocation)

        // Устанавливаем ограничения таблицы
        tableView7daysForecastCurrentLocation.addAndActivateConstraints(
            to: [.top(10, relativeTo: pressureLabel.bottomAnchor), .leading(0), .trailing(0), .bottom(0)],
            of: mainScreenView
        )

        tableView7daysForecastCurrentLocation.separatorStyle = .none
        tableView7daysForecastCurrentLocation.isScrollEnabled = true
        tableView7daysForecastCurrentLocation.allowsSelection = false
    }

    private func configureMainView(mainScreenView: UIView) {
        mainScreenView.translatesAutoresizingMaskIntoConstraints = false
        mainScreenView.backgroundColor = .white
        view.addSubview(mainScreenView)
        mainScreenView.addAndActivateConstraints(to: [.safeAreaTop(0), .safeAreaBottom(0), .leading(0), .trailing(0)], of: view)
    }

    private func showTimeLabel(mainScreenView: UIView) {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textAlignment = .center
        timeLabel.text = "Good \(TimeManager.shared.getTimeOfDay())!"
        mainScreenView.addSubview(timeLabel)
        timeLabel.addAndActivateConstraints(to: [.top(-5, relativeTo: locationLabel.bottomAnchor), .leading(20), .trailing(-20), .height(40)],
                                            of: mainScreenView)
    }

    private func showLocationLabel(mainScreenView: UIView) {
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.textAlignment = .center
        locationLabel.numberOfLines = 0
        locationLabel.lineBreakMode = .byWordWrapping
        mainScreenView.addSubview(locationLabel)
        locationLabel.addAndActivateConstraints(to: [.top(15, relativeTo: mainScreenView.topAnchor), .leading(20), .trailing(-20)], of: mainScreenView)
    }

    private func addWeatherLabelsForCurrentDayForecastToMainScreen(mainScreenView: UIView) {
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
                label.addAndActivateConstraints(to: [.top(10, relativeTo: previousLabel.bottomAnchor), .leading(20), .trailing(-20)], of: mainScreenView)

            } else {
                label.addAndActivateConstraints(to: [.top(10, relativeTo: previousLabel.bottomAnchor), .leading(20), .trailing(-20)], of: mainScreenView)

            }
            previousLabel = label
        }
    }

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

// MARK: Handler Methods -------------------------
extension MainViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentLocation7DayForecast.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let forecast = currentLocation7DayForecast[indexPath.row]

        cell.textLabel?.text = """
            Date: \(forecast.date)
            Max Temp: \(forecast.maxTemp)°C
            Min Temp: \(forecast.minTemp)°C
            Precip Accum: \(forecast.precipAccum) mm
            Max Wind Speed: \(forecast.maxWindSpeed) km/h
            """
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = .black

        return cell
    }

    private func requestParseAndSave7DayForecast(zoneId: Int) async -> [WeeklySingleDay] {
        return await ApiHandlerForeca.shared.getWeeklyForecast(zoneId: zoneId)
    }

    private func fetchLocationData() async {
        print("Fetching location list from API...")
        let locationsResult = await ApiHandlerForeca.shared.fetchCityFromForecaLocationsBase(for: self.currentLocationCity)
        print("Fetched locations: \(locationsResult)")

        filteredLocationsAfterMapping = CityIdHelper.shared.compareLocations(result: locationsResult)
        print("\nFiltered Locations: \(filteredLocationsAfterMapping)\n")

        if filteredLocationsAfterMapping.isEmpty {
            filteredLocationsAfterMapping = ApiHandlerForeca.shared.extractLocations(from: locationsResult)
            print("\nCopy all locations to filtered array because was conflicts with area detection. FilteredLocationsAfterMapping: \n\n \(filteredLocationsAfterMapping)\n")
        }
    }

    private func handleLocationUpdate() async {
        if let location = filteredLocationsAfterMapping.first {
            updateLocation(location)
        }
    }

    func didUpdateLocationName(_ locationName: String) {
        // Разделяем название города и страны
        let locationNameComponents = locationName.components(separatedBy: ",")

        if locationNameComponents.count == 2 {
            let apiCityName = locationNameComponents[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let apiCountryName = locationNameComponents[1].trimmingCharacters(in: .whitespacesAndNewlines)

            // Используем маппер для получения отформатированного названия
            if let (city, country) = CityNameMapping.getCurrentNameAndCountry(for: apiCityName) {
                locationLabel.text = "\(city), \(country)"
                currentLocationCity = city
                currentLocationCountry = country
            } else {
                // Если маппер не находит название, используем данные из API
                locationLabel.text = "\(apiCityName), \(apiCountryName)"
                currentLocationCity = apiCityName
                currentLocationCountry = apiCountryName
            }

            // Обновляем данные
            Task {
                await fetchLocationData()
                await handleLocationUpdate()
            }
        } else {
            print("Invalid location string")
        }
    }

    func updateLocation(_ location: Location) {
        locationLabel.text = "\(location.name), \(location.country)"
        currentLocation = location
    }
}

// MARK: Delegates -------------------------
extension MainViewController: LocationConflictViewControllerDelegate {
    func locationConflictViewController(_ controller: LocationConflictViewController, didSelectLocation location: Location) {
        updateLocation(location)
    }
}

