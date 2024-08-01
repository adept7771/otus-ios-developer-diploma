import UIKit

class MainViewController: UIViewController, LocationManagerDelegate {
    let locationManager = LocationManager()

    let locationLabel = UILabel()
    var timeLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray3

        let mainScreenView = UIView()
        mainScreenView.translatesAutoresizingMaskIntoConstraints = false
        mainScreenView.backgroundColor = .white
        view.addSubview(mainScreenView)

        // Настройка locationLabel
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.textAlignment = .center
        locationLabel.numberOfLines = 0 // Позволяет использовать любое количество строк
        locationLabel.lineBreakMode = .byWordWrapping // Перенос по словам

        // Настройка timeLabel
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textAlignment = .center
        timeLabel.text = "Сейчас: \(TimeManager.shared.getTimeOfDay())"

        mainScreenView.addSubview(locationLabel)
        mainScreenView.addSubview(timeLabel)

        // Установка делегата и запуск обновления местоположения
        locationManager.delegate = self
        locationManager.startUpdatingLocation()

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

    func didUpdateLocationName(_ locationName: String) {
        locationLabel.text = locationName
    }
}
