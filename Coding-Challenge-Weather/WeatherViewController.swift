//
//  WeatherViewController.swift
//  Coding-Challenge-Weather
//
//  Created by Andres S. Hernandez G. on 5/31/23.
//
import UIKit
import CoreLocation

enum TemperatureUnit {
    case fahrenheit
    case celsius
}

class WeatherViewController: UIViewController {
    
    // MARK:- Properties

    let locationManager = CLLocationManager()
    let networkingManager = NetworkingManager()
    var temperatureUnit: TemperatureUnit = .fahrenheit
    var currentWeatherData: WeatherData?
    private var infoPopupView: InfoPopupView?

    
    var weatherAttributes: [WeatherAttribute] = [
        WeatherAttribute(name: "Feels Like", iconName: "thermometer", value: "--°C"),
        WeatherAttribute(name: "Humidity", iconName: "drop.fill", value: "--%"),
        WeatherAttribute(name: "Wind Speed", iconName: "wind", value: "-- m/s"),
        WeatherAttribute(name: "Cloudiness", iconName: "cloud.fill", value: "--%")
    ]
    
    // MARK:- UI Elements
    
    private let infoButton: UIButton = {
            let button = UIButton(type: .infoLight)
        button.tintColor = UIColor.red
            return button
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let temperatureUnitSwitch: UISwitch = {
        let temperatureSwitch = UISwitch()
        temperatureSwitch.translatesAutoresizingMaskIntoConstraints = false
        temperatureSwitch.isOn = true // Default to Farenheit
        return temperatureSwitch
    }()
    
    // Temperature unit labels
    let fahrenheitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.text = "°F"
        return label
    }()
    
    let celsiusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.text = "°C"
        return label
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter a US city"
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .words
        textField.returnKeyType = .done
        return textField
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        return imageView
    }()
    
    // MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.24, green: 0.45, blue: 0.76, alpha: 1.0)
        
        setupUI()
        setupLocationManager()
        loadLastSearchedCity()
        setupCollectionView()
        
        title = "Weather App"
        
        // Add the info button to the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        temperatureUnitSwitch.addTarget(self, action: #selector(temperatureUnitSwitchValueChanged), for: .valueChanged)
    }
    
    // MARK:- UI Setup Private Methods
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WeatherAttributeCell.self, forCellWithReuseIdentifier: WeatherAttributeCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the collectionView to the view
        view.addSubview(collectionView)
        
        // Set up constraints for the collectionView
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 50),
            collectionView.heightAnchor.constraint(lessThanOrEqualToConstant: 130)
        ])
        
        // Set the item size of the collectionView layout
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 130, height: 130)
        }
    }
    
    private func setupUI() {
        // Search text field
        view.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -145)
        ])
        searchTextField.delegate = self
        
        // City label
        view.addSubview(cityLabel)
        NSLayoutConstraint.activate([
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 60)
        ])
        
        // Temperature label
        view.addSubview(temperatureLabel)
        NSLayoutConstraint.activate([
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 40)
        ])
        
        // Description label
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10)
        ])
        
        // Icon image view
        view.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            iconImageView.widthAnchor.constraint(equalToConstant: 120),
            iconImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Temperature unit switch and respective labels
        view.addSubview(temperatureUnitSwitch)
        view.addSubview(fahrenheitLabel)
        view.addSubview(celsiusLabel)
        
        // Set up constraints for temperature unit labels and switch
        NSLayoutConstraint.activate([
            celsiusLabel.trailingAnchor.constraint(equalTo: temperatureUnitSwitch.leadingAnchor, constant: -8),
            celsiusLabel.centerYAnchor.constraint(equalTo: temperatureUnitSwitch.centerYAnchor),
            
            temperatureUnitSwitch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            temperatureUnitSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            fahrenheitLabel.leadingAnchor.constraint(equalTo: temperatureUnitSwitch.trailingAnchor, constant: 8),
            fahrenheitLabel.centerYAnchor.constraint(equalTo: temperatureUnitSwitch.centerYAnchor)
        ])
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func loadLastSearchedCity() {
        if let lastSearchedCity = UserDefaults.standard.string(forKey: "LastSearchedCity") {
            searchTextField.text = lastSearchedCity
            getWeatherData(for: lastSearchedCity)
        }
    }
    
    // MARK:- Action Methods
    @objc func temperatureUnitSwitchValueChanged() {
        temperatureUnit = temperatureUnitSwitch.isOn ? .fahrenheit : .celsius
        updateTemperatureLabel()
    }
    
    @objc private func infoButtonTapped() {
        infoPopupView = InfoPopupView()
        print("HERE!!")
        infoPopupView?.present(on: view)
    }
    
    // MARK:- Networking Layer Call Methods
    
    func getWeatherData(for city: String) {
        networkingManager.getWeatherData(for: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherData):
                    self?.currentWeatherData = weatherData
                    self?.updateUI(with: weatherData)
                    self?.updateWeatherAttributes(with: weatherData)
                case .failure(let error):
                    // Handle error case
                    print("Weather data retrieval error: \(error)")
                    self?.showAlert(title: "Error", message: "Failed to retrieve weather data. The city you entered may not exist.")
                }
            }
        }
    }
    
    func downloadIcon(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Failed to download icon: \(error)")
                completion(nil)
            } else if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK:- Update UI Methods
    
    func updateWeatherAttributes(with weatherData: WeatherData) {
        // Extract the necessary values from the API response and update the weatherAttributes array
        weatherAttributes = [
            WeatherAttribute(name: "Feels Like", iconName: "thermometer", value: "\(Int(weatherData.main.realFeel - 273.15))°C"),
            WeatherAttribute(name: "Humidity", iconName: "drop.fill", value: "\(weatherData.main.humidity)%"),
            WeatherAttribute(name: "Wind Speed", iconName: "wind", value: "\(weatherData.wind.speed) m/s"),
            WeatherAttribute(name: "Cloudiness", iconName: "cloud.fill", value: "\(weatherData.clouds.all)%")
        ]
        
        // Reload the collection view to reflect the updated data
        collectionView.reloadData()
    }
    
    func updateUI(with weatherData: WeatherData) {
        DispatchQueue.main.async { [weak self] in
            self?.cityLabel.text = weatherData.name
            self?.descriptionLabel.text = weatherData.weather.first?.weatherDescription.capitalized
        }
        
        if let weatherIconCode = weatherData.weather.first?.weatherIcon {
            NetworkingManager().downloadImage(for: weatherIconCode) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async { [weak self] in
                        self?.iconImageView.image = image
                    }
                case .failure(let error):
                    print("Failed to download image: \(error)")
                }
            }
        }
        self.updateTemperatureLabel()
    }
    
    func updateTemperatureLabel() {
        guard let weatherData = currentWeatherData else {
            return
        }
        
        let temperature: Int
        let realFeel: Int
        
        switch temperatureUnit {
        case .celsius:
            temperature = Int(weatherData.main.temperature - 273.15)
            realFeel = Int(weatherData.main.realFeel - 273.15)
        case .fahrenheit:
            temperature = Int((weatherData.main.temperature - 273.15) * 9/5 + 32)
            realFeel = Int((weatherData.main.realFeel - 273.15) * 9/5 + 32)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.temperatureLabel.text = "\(temperature)°\(self?.temperatureUnit == .celsius ? "C" : "F")"
            let indexPath = IndexPath(item: 0, section: 0)
            if let cell = self?.collectionView.cellForItem(at: indexPath) as? WeatherAttributeCell{
                // Update the temperature label in the cell directly
                cell.valueLabel.text = "\(realFeel)°\(self?.temperatureUnit == .celsius ? "C" : "F")"
            }
        }
    }
}
