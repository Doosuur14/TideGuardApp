//
//  SafetyView.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 17.04.2025.
//

import UIKit
import MapKit
import SnapKit

class SafetyView: UIView {
    lazy var segmentedControl: UISegmentedControl = UISegmentedControl(items: ["Map","Weather", "Forecast"])

    lazy var containerView: UIView = UIView()
    lazy var mapView: MKMapView = MKMapView()

    lazy var forecastContainer: UIView = UIView()
    lazy var forecastScrollView: UIScrollView = UIScrollView()

    lazy var weatherForecastHeaderLabel: UILabel = UILabel()
    lazy var floodForecastHeaderLabel: UILabel = UILabel()


    lazy var weeklyWeatherStackView: UIStackView = UIStackView()


    lazy var monthlyFloodStackView: UIStackView = UIStackView()


    lazy var weatherContainer: UIView = UIView()
    lazy var weatherImageView: UIImageView = UIImageView()
    lazy var weatherDescriptionLabel: UILabel = UILabel()
    lazy var temperatureLabel: UILabel = UILabel()
    lazy var humidityLabel: UILabel = UILabel()
    lazy var activityIndicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFunc()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupFunc() {
        setUpSegments()
        setUpContainer()
        setUpMap()
        setUpWeatherContainer()
        setupForecastContainer()
        setupForecastContent()
        setupActivityIndicator()

    }

    private func setUpSegments() {
        addSubview(segmentedControl)
        segmentedControl.backgroundColor = UIColor(named: "Color")
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor(named: "MainColor") as Any], for: .selected)
        segmentedControl.addTarget(self, action: #selector(switchSection), for: .valueChanged)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    private func setUpContainer() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

    private func setUpMap() {
        containerView.addSubview(mapView)
        mapView.isHidden = false
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
    }


    private func setUpWeatherContainer() {
        containerView.addSubview(weatherContainer)
        weatherContainer.backgroundColor = UIColor(named: "BackgroundColor")?.withAlphaComponent(0.9)
        weatherContainer.layer.cornerRadius = 15
        weatherContainer.clipsToBounds = true
        weatherContainer.isHidden = true
        weatherContainer.snp.makeConstraints { make in
            make.edges.equalTo(containerView).inset(16)
        }

        weatherImageView.contentMode = .scaleAspectFit
        weatherContainer.addSubview(weatherImageView)
        weatherImageView.snp.makeConstraints { make in
            make.top.equalTo(weatherContainer.snp.top).offset(20)
            make.centerX.equalTo(weatherContainer.snp.centerX)
            make.width.height.equalTo(100)
        }

        weatherDescriptionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        weatherDescriptionLabel.textColor = UIColor(named: "MainColor")
        weatherDescriptionLabel.textAlignment = .center
        weatherContainer.addSubview(weatherDescriptionLabel)
        weatherDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom).offset(10)
            make.centerX.equalTo(weatherContainer.snp.centerX)
        }

        temperatureLabel.font = .systemFont(ofSize: 24, weight: .bold)
        temperatureLabel.textColor = UIColor(named: "MainColor")
        weatherContainer.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherDescriptionLabel.snp.bottom).offset(10)
            make.centerX.equalTo(weatherContainer.snp.centerX)
        }

        humidityLabel.font = .systemFont(ofSize: 16, weight: .regular)
        humidityLabel.textColor = UIColor(named: "MainColor")
        weatherContainer.addSubview(humidityLabel)
        humidityLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(10)
            make.centerX.equalTo(weatherContainer.snp.centerX)
            make.bottom.lessThanOrEqualTo(weatherContainer.snp.bottom).offset(-20)
        }
    }

    private func setupForecastContainer() {
        containerView.addSubview(forecastContainer)
        forecastContainer.isHidden = true
        forecastContainer.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
    }

    private func  setupForecastContent() {
        forecastContainer.addSubview(forecastScrollView)

        forecastScrollView.showsVerticalScrollIndicator = false
        forecastScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        forecastScrollView.addSubview(forecastContainer)
        forecastContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(forecastScrollView)
        }

        // ── Section 1 header: 7 Day Weather Forecast ──
        forecastContainer.addSubview(weatherForecastHeaderLabel)
        weatherForecastHeaderLabel.text = "7-Day Weather Forecast"
        weatherForecastHeaderLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        weatherForecastHeaderLabel.textColor = UIColor(named: "MainColor")
        weatherForecastHeaderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().inset(16)
        }

        // ── Weekly weather stack ──
        forecastContainer.addSubview(weeklyWeatherStackView)
        weeklyWeatherStackView.axis = .horizontal
        weeklyWeatherStackView.distribution = .fillEqually
        weeklyWeatherStackView.spacing = 8
        weeklyWeatherStackView.snp.makeConstraints { make in
            make.top.equalTo(weatherForecastHeaderLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }

        // ── Divider ──
        let divider = UIView()
        divider.backgroundColor = UIColor.systemGray5
        forecastContainer.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(weeklyWeatherStackView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }

        // ── Section 2 header: Monthly Flood Risk ──
        forecastContainer.addSubview(floodForecastHeaderLabel)
        floodForecastHeaderLabel.text = "Monthly Flood Risk Forecast"
        floodForecastHeaderLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        floodForecastHeaderLabel.textColor = UIColor(named: "MainColor")
        floodForecastHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }

        
        forecastContainers.addSubview(monthlyFloodStackView)
        monthlyFloodStackView.axis = .vertical
        monthlyFloodStackView.spacing = 12
        monthlyFloodStackView.snp.makeConstraints { make in
            make.top.equalTo(floodForecastHeaderLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-24)
        }

    }




    @objc private func switchSection(_ sender: UISegmentedControl) {

        mapView.isHidden = true
        weatherContainer.isHidden = true

        switch sender.selectedSegmentIndex {
        case 0:
            mapView.isHidden = false
        case 1:
            weatherContainer.isHidden = false
        case 2:
                forecastContainer.isHidden = false
        default: break
        }
    }

    func updateWeatherImage(with urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            weatherImageView.image = nil
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.weatherImageView.image = image
                }
            } else {
                print("Failed to load weather image: \(error?.localizedDescription ?? "No error")")
            }
        }.resume()
    }

    private func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

    }

    func showLoadingSpinner() {
            activityIndicator.startAnimating()
            isUserInteractionEnabled = false
        }

        func hideLoadingSpinner() {
            activityIndicator.stopAnimating()
            isUserInteractionEnabled = true
        }
}
