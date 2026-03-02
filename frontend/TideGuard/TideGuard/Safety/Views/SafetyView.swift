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
    lazy var segmentedControl: UISegmentedControl = UISegmentedControl(items: ["Map","Weather"])
    lazy var containerView: UIView = UIView()
    lazy var mapView: MKMapView = MKMapView()
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
        containerView.addSubview(weatherContainer)
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

    @objc private func switchSection(_ sender: UISegmentedControl) {

        mapView.isHidden = true
        weatherContainer.isHidden = true
        //subviews.forEach { if $0.accessibilityIdentifier == "legendView" { $0.isHidden = true } }

        switch sender.selectedSegmentIndex {
        case 0:
            mapView.isHidden = false
           // subviews.forEach { if $0.accessibilityIdentifier == "legendView" { $0.isHidden = false } }
        case 1:
            weatherContainer.isHidden = false
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
