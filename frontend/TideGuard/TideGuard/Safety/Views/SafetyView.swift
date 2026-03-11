//
//  SafetyView.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 17.04.2025.
//

import UIKit
import MapKit
import SnapKit

//class SafetyView: UIView {
//    lazy var segmentedControl: UISegmentedControl = UISegmentedControl(items: ["Map","Weather", "Forecast"])
//
//    lazy var containerView: UIView = UIView()
//    lazy var mapView: MKMapView = MKMapView()
//
//    lazy var forecastContainer: UIView = UIView()
//    lazy var forecastScrollView: UIScrollView = UIScrollView()
//    lazy var forecastContentView: UIView = UIView()
//
//    lazy var weatherForecastHeaderLabel: UILabel = UILabel()
//    lazy var floodForecastHeaderLabel: UILabel = UILabel()
//
//
//    lazy var weeklyWeatherStackView: UIStackView = UIStackView()
//
//
//    lazy var monthlyFloodStackView: UIStackView = UIStackView()
//
//
//    lazy var weatherContainer: UIView = UIView()
//    lazy var weatherImageView: UIImageView = UIImageView()
//    lazy var weatherDescriptionLabel: UILabel = UILabel()
//    lazy var temperatureLabel: UILabel = UILabel()
//    lazy var humidityLabel: UILabel = UILabel()
//    lazy var activityIndicator = UIActivityIndicatorView(style: .large)
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupFunc()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupFunc() {
//        setUpSegments()
//        setUpContainer()
//        setUpMap()
//        setUpWeatherContainer()
//        setupForecastContainer()
//        setupForecastContent()
//        setupActivityIndicator()
//
//    }
//
//    private func setUpSegments() {
//        addSubview(segmentedControl)
//        segmentedControl.backgroundColor = UIColor(named: "Color")
//        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
//        segmentedControl.selectedSegmentIndex = 0
//        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor(named: "MainColor") as Any], for: .selected)
//        segmentedControl.addTarget(self, action: #selector(switchSection), for: .valueChanged)
//        segmentedControl.snp.makeConstraints { make in
//            make.top.equalTo(safeAreaLayoutGuide).offset(10)
//            make.leading.trailing.equalToSuperview().inset(16)
//        }
//    }
//
//    private func setUpContainer() {
//        addSubview(containerView)
//        containerView.snp.makeConstraints { make in
//            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
//            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
//        }
//    }
//
//    private func setUpMap() {
//        containerView.addSubview(mapView)
//        mapView.isHidden = false
//        mapView.snp.makeConstraints { make in
//            make.edges.equalTo(containerView)
//        }
//    }
//
//
//    private func setUpWeatherContainer() {
//        containerView.addSubview(weatherContainer)
//        weatherContainer.backgroundColor = UIColor(named: "BackgroundColor")?.withAlphaComponent(0.9)
//        weatherContainer.layer.cornerRadius = 15
//        weatherContainer.clipsToBounds = true
//        weatherContainer.isHidden = true
//        weatherContainer.snp.makeConstraints { make in
//            make.edges.equalTo(containerView).inset(16)
//        }
//
//        weatherImageView.contentMode = .scaleAspectFit
//        weatherContainer.addSubview(weatherImageView)
//        weatherImageView.snp.makeConstraints { make in
//            make.top.equalTo(weatherContainer.snp.top).offset(20)
//            make.centerX.equalTo(weatherContainer.snp.centerX)
//            make.width.height.equalTo(100)
//        }
//
//        weatherDescriptionLabel.font = .systemFont(ofSize: 18, weight: .medium)
//        weatherDescriptionLabel.textColor = UIColor(named: "MainColor")
//        weatherDescriptionLabel.textAlignment = .center
//        weatherContainer.addSubview(weatherDescriptionLabel)
//        weatherDescriptionLabel.snp.makeConstraints { make in
//            make.top.equalTo(weatherImageView.snp.bottom).offset(10)
//            make.centerX.equalTo(weatherContainer.snp.centerX)
//        }
//
//        temperatureLabel.font = .systemFont(ofSize: 24, weight: .bold)
//        temperatureLabel.textColor = UIColor(named: "MainColor")
//        weatherContainer.addSubview(temperatureLabel)
//        temperatureLabel.snp.makeConstraints { make in
//            make.top.equalTo(weatherDescriptionLabel.snp.bottom).offset(10)
//            make.centerX.equalTo(weatherContainer.snp.centerX)
//        }
//
//        humidityLabel.font = .systemFont(ofSize: 16, weight: .regular)
//        humidityLabel.textColor = UIColor(named: "MainColor")
//        weatherContainer.addSubview(humidityLabel)
//        humidityLabel.snp.makeConstraints { make in
//            make.top.equalTo(temperatureLabel.snp.bottom).offset(10)
//            make.centerX.equalTo(weatherContainer.snp.centerX)
//            make.bottom.lessThanOrEqualTo(weatherContainer.snp.bottom).offset(-20)
//        }
//    }
//
//    private func setupForecastContainer() {
//        containerView.addSubview(forecastContainer)
//        forecastContainer.isHidden = true
//        forecastContainer.snp.makeConstraints { make in
//            make.edges.equalTo(containerView)
//        }
//    }
//
//    private func  setupForecastContent() {
//        forecastContainer.addSubview(forecastScrollView)
//
//        forecastScrollView.showsVerticalScrollIndicator = false
//        forecastScrollView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        forecastScrollView.addSubview(forecastContentView)
//        forecastContentView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//            make.width.equalTo(forecastScrollView)
//        }
//
//
//        forecastContentView.addSubview(weatherForecastHeaderLabel)
//        weatherForecastHeaderLabel.text = "7-Day Forecast"
//        weatherForecastHeaderLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//        weatherForecastHeaderLabel.textColor = UIColor(named: "MainColor")
//        weatherForecastHeaderLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(20)
//            make.leading.equalToSuperview().inset(16)
//        }
//
//
//        forecastContentView.addSubview(weeklyWeatherStackView)
//        weeklyWeatherStackView.axis = .horizontal
//        weeklyWeatherStackView.distribution = .fillEqually
//        weeklyWeatherStackView.spacing = 8
//        weeklyWeatherStackView.snp.makeConstraints { make in
//            make.top.equalTo(weatherForecastHeaderLabel.snp.bottom).offset(12)
//            make.leading.trailing.equalToSuperview().inset(16)
//            make.height.equalTo(150)
//        }
//
//
//        let divider = UIView()
//        divider.backgroundColor = UIColor.systemGray5
//        forecastContentView.addSubview(divider)
//        divider.snp.makeConstraints { make in
//            make.top.equalTo(weeklyWeatherStackView.snp.bottom).offset(24)
//            make.leading.trailing.equalToSuperview().inset(16)
//            make.height.equalTo(1)
//        }
//
//
//        forecastContentView.addSubview(floodForecastHeaderLabel)
//        floodForecastHeaderLabel.text = "Monthly Flood Risk Forecast"
//        floodForecastHeaderLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//        floodForecastHeaderLabel.textColor = UIColor(named: "MainColor")
//        floodForecastHeaderLabel.snp.makeConstraints { make in
//            make.top.equalTo(divider.snp.bottom).offset(24)
//            make.leading.equalToSuperview().inset(16)
//        }
//
//
//        forecastContentView.addSubview(monthlyFloodStackView)
//        monthlyFloodStackView.axis = .vertical
//        monthlyFloodStackView.spacing = 12
//        monthlyFloodStackView.snp.makeConstraints { make in
//            make.top.equalTo(floodForecastHeaderLabel.snp.bottom).offset(12)
//            make.leading.trailing.equalToSuperview().inset(16)
//            make.bottom.equalToSuperview().offset(-24)
//        }
//    }
//
//
//
//    @objc private func switchSection(_ sender: UISegmentedControl) {
//
//        mapView.isHidden = true
//        weatherContainer.isHidden = true
//        forecastContainer.isHidden = true
//
//        switch sender.selectedSegmentIndex {
//        case 0:
//            mapView.isHidden = false
//        case 1:
//            weatherContainer.isHidden = false
//        case 2:
//                forecastContainer.isHidden = false
//        default: break
//        }
//    }
//    
//
//    func updateWeatherImage(with urlString: String?) {
//        guard let urlString = urlString, let url = URL(string: urlString) else {
//            weatherImageView.image = nil
//            return
//        }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data, let image = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    self.weatherImageView.image = image
//                }
//            } else {
//                print("Failed to load weather image: \(error?.localizedDescription ?? "No error")")
//            }
//        }.resume()
//    }
//
//
//
//    func updateWeeklyForecast(with data: [WeatherData.DailyForecast]) {
//        weeklyWeatherStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
//
//        for day in data {
//            let card = makeDayWeatherCard(day: day)
//            weeklyWeatherStackView.addArrangedSubview(card)
//        }
//    }
//
//
//    private func makeDayWeatherCard(day: WeatherData.DailyForecast) -> UIView {
//        let card = UIView()
//        card.backgroundColor = UIColor.systemGray6
//        card.layer.cornerRadius = 12
//
//        let dayLabel = UILabel()
//        dayLabel.text = day.date ?? "-"
//        dayLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
//        dayLabel.textAlignment = .center
//        dayLabel.textColor = .secondaryLabel
//        card.addSubview(dayLabel)
//        dayLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(8)
//            make.centerX.equalToSuperview()
//        }
//
//
//        let iconImageView = UIImageView()
//        iconImageView.contentMode = .scaleAspectFit
//        card.addSubview(iconImageView)
//        iconImageView.snp.makeConstraints { make in
//            make.top.equalTo(dayLabel.snp.bottom).offset(4)
//            make.centerX.equalToSuperview()
//            make.width.height.equalTo(32)
//        }
//
//        if let iconUrl = day.icon, let url = URL(string: iconUrl) {
//            URLSession.shared.dataTask(with: url) { data, _, _ in
//                if let data = data, let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        iconImageView.image = image
//                    }
//                }
//            }.resume()
//        }
//
//        let tempLabel = UILabel()
//        let maxTemp = day.maxTemp ?? 0
//        let minTemp = day.minTemp ?? 0
//        tempLabel.text = "\(Int(maxTemp))°/\(Int(minTemp))°"
//        tempLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
//        tempLabel.textAlignment = .center
//        tempLabel.textColor = .label
//        card.addSubview(tempLabel)
//        tempLabel.snp.makeConstraints { make in
//            make.top.equalTo(iconImageView.snp.bottom).offset(4)
//            make.centerX.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-8)
//        }
//
//        return card
//    }
//
//    func updateMonthlyFloodForecast(_ monthlyRisks: [Int]) {
//
//        monthlyFloodStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
//
//        let monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
//                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
//
//        // Split into two rows of 6
//        let firstHalf  = Array(zip(monthNames.prefix(6), monthlyRisks.prefix(6)))
//        let secondHalf = Array(zip(monthNames.suffix(6), monthlyRisks.suffix(6)))
//
//        for half in [firstHalf, secondHalf] {
//            let rowStack = UIStackView()
//            rowStack.axis = .horizontal
//            rowStack.distribution = .fillEqually
//            rowStack.spacing = 8
//
//            for (month, risk) in half {
//                let cell = makeMonthRiskCell(month: month, risk: risk)
//                rowStack.addArrangedSubview(cell)
//            }
//            monthlyFloodStackView.addArrangedSubview(rowStack)
//        }
//    }
//
//
//    private func makeMonthRiskCell(month: String, risk: Int) -> UIView {
//        let cell = UIView()
//        cell.backgroundColor = UIColor.systemGray6
//        cell.layer.cornerRadius = 12
//
//        let monthLabel = UILabel()
//        monthLabel.text = month
//        monthLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
//        monthLabel.textAlignment = .center
//        monthLabel.textColor = .secondaryLabel
//        cell.addSubview(monthLabel)
//        monthLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(10)
//            make.centerX.equalToSuperview()
//        }
//
//        let riskLabel = UILabel()
//        riskLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
//        riskLabel.textAlignment = .center
//
//        let dot = UIView()
//        dot.layer.cornerRadius = 8
//
//        switch risk {
//        case 2:
//            dot.backgroundColor = .systemRed
//            riskLabel.text = "High"
//            riskLabel.textColor = .systemRed
//        case 1:
//            dot.backgroundColor = .systemOrange
//            riskLabel.text = "Med"
//            riskLabel.textColor = .systemOrange
//        default:
//            dot.backgroundColor = .systemGreen
//            riskLabel.text = "Low"
//            riskLabel.textColor = .systemGreen
//        }
//
//        cell.addSubview(dot)
//        dot.snp.makeConstraints { make in
//            make.top.equalTo(monthLabel.snp.bottom).offset(8)
//            make.centerX.equalToSuperview()
//            make.width.height.equalTo(16)
//        }
//
//        cell.addSubview(riskLabel)
//        riskLabel.snp.makeConstraints { make in
//            make.top.equalTo(dot.snp.bottom).offset(4)
//            make.centerX.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-10)
//        }
//
//        return cell
//    }
//
//    private func setupActivityIndicator() {
//        addSubview(activityIndicator)
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.color = .gray
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
//            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//    }
//
//    func showLoadingSpinner() {
//        activityIndicator.startAnimating()
//        isUserInteractionEnabled = false
//    }
//
//    func hideLoadingSpinner() {
//        activityIndicator.stopAnimating()
//        isUserInteractionEnabled = true
//    }
//}



class SafetyView: UIView {

    lazy var bottomTabBar: UIView = UIView()
    lazy var mapTabButton: UIButton    = makeTabButton(icon: "map.fill",    title: "Map")
    lazy var weatherTabButton: UIButton = makeTabButton(icon: "cloud.sun.fill", title: "Weather")
    lazy var forecastTabButton: UIButton = makeTabButton(icon: "calendar",  title: "Forecast")
    lazy var tabIndicator: UIView = UIView()

    lazy var pagingScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.bounces = false
        return sv
    }()

    lazy var mapPage: UIView     = UIView()
    lazy var weatherPage: UIView = UIView()
    lazy var forecastPage: UIView = UIView()

    lazy var mapView: MKMapView = MKMapView()

    lazy var weatherAnimationContainer: UIView = UIView()
    lazy var weatherIconContainer: UIView = UIView()
    lazy var weatherIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    lazy var weatherConditionLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        l.textAlignment = .center
        l.textColor = .secondaryLabel
        return l
    }()
    lazy var weatherTempLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 72, weight: .thin)
        l.textAlignment = .center
        l.textColor = UIColor(named: "MainColor") ?? .label
        return l
    }()
    lazy var weatherDetailsStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 24
        sv.distribution = .fillEqually
        return sv
    }()
    lazy var humidityPill: WeatherDetailPill  = WeatherDetailPill(icon: "💧", title: "Humidity")
    lazy var precipPill: WeatherDetailPill    = WeatherDetailPill(icon: "🌧", title: "Rainfall")


    lazy var forecastScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    lazy var forecastContentView: UIView = UIView()
    lazy var weeklyHeaderLabel: UILabel  = makeHeaderLabel("7-Day Weather Forecast")
    lazy var weeklyWeatherStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 10
        return sv
    }()

    lazy var floodHeaderLabel: UILabel = makeHeaderLabel("14-Day Flood Forecast")
    lazy var floodGridContainer: UIView = UIView()


    lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.hidesWhenStopped = true
        ai.color = .gray
        return ai
    }()


    //to enable me track the current page
    private var currentPage: Int = 0


    private var weatherAnimationLayers: [CALayer] = []
    private var weatherAnimationViews: [UIView] = []


    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        backgroundColor = UIColor(named: "BackgroundColor") ?? .systemBackground
        setupPagingScrollView()
        setupMapPage()
        setupWeatherPage()
        setupForecastPage()
        setupBottomTabBar()
        setupActivityIndicator()
        setupEdgeSwipeZones()
    }



    private func setupPagingScrollView() {
        addSubview(pagingScrollView)
        pagingScrollView.delegate = self
        pagingScrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-84) // leave room for tab bar
        }

        pagingScrollView.addSubview(mapPage)
        pagingScrollView.addSubview(weatherPage)
        pagingScrollView.addSubview(forecastPage)
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        let w = pagingScrollView.bounds.width
        let h = pagingScrollView.bounds.height
        guard w > 0 else { return }

        pagingScrollView.contentSize = CGSize(width: w * 3, height: h)

        mapPage.frame     = CGRect(x: 0,     y: 0, width: w, height: h)
        weatherPage.frame = CGRect(x: w,     y: 0, width: w, height: h)
        forecastPage.frame = CGRect(x: w * 2, y: 0, width: w, height: h)

        weatherAnimationContainer.frame = weatherPage.bounds
    }

    private func setupMapPage() {
        mapPage.addSubview(mapView)
        mapView.frame = mapPage.bounds
        mapView.mapType = .hybridFlyover
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func setupEdgeSwipeZones() {

        let leftEdge = UIView()
        leftEdge.backgroundColor = .clear
        addSubview(leftEdge)
        leftEdge.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(30)
        }

        let rightEdge = UIView()
        rightEdge.backgroundColor = .clear
        addSubview(rightEdge)
        rightEdge.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(30)
        }

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        rightEdge.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        leftEdge.addGestureRecognizer(swipeRight)
    }

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            let nextPage = min(currentPage + 1, 2)
            navigateToPage(nextPage, animated: true)
        case .right:
            let prevPage = max(currentPage - 1, 0)
            navigateToPage(prevPage, animated: true)
        default:
            break
        }
    }


    private func setupWeatherPage() {
        weatherPage.addSubview(weatherAnimationContainer)
        weatherAnimationContainer.frame = weatherPage.bounds
        weatherAnimationContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        weatherAnimationContainer.clipsToBounds = true


        let card = UIView()
        card.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.75)
        card.layer.cornerRadius = 28
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor


        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.08
        card.layer.shadowOffset = CGSize(width: 0, height: 8)
        card.layer.shadowRadius = 20

        weatherPage.addSubview(card)
        card.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }


        card.addSubview(weatherTempLabel)
        weatherTempLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.centerX.equalToSuperview()
        }


        card.addSubview(weatherConditionLabel)
        weatherConditionLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherTempLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }


        card.addSubview(weatherIconImageView)
        weatherIconImageView.snp.makeConstraints { make in
            make.top.equalTo(weatherConditionLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }


        card.addSubview(weatherDetailsStack)
        weatherDetailsStack.addArrangedSubview(humidityPill)
        weatherDetailsStack.addArrangedSubview(precipPill)
        weatherDetailsStack.snp.makeConstraints { make in
            make.top.equalTo(weatherIconImageView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-28)
            make.height.equalTo(72)
        }
    }

    private func setupForecastPage() {

        forecastPage.addSubview(forecastScrollView)
        forecastScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        forecastScrollView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)

        forecastScrollView.addSubview(forecastContentView)
        forecastContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(forecastScrollView)
        }


        forecastContentView.addSubview(weeklyHeaderLabel)
        weeklyHeaderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().inset(20)
        }


        forecastContentView.addSubview(weeklyWeatherStackView)
        weeklyWeatherStackView.snp.makeConstraints { make in
            make.top.equalTo(weeklyHeaderLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }


        let divider = UIView()
        divider.backgroundColor = UIColor.systemGray5
        forecastContentView.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(weeklyWeatherStackView.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }


        forecastContentView.addSubview(floodHeaderLabel)
        floodHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(20)
        }

        forecastContentView.addSubview(floodGridContainer)
        floodGridContainer.snp.makeConstraints { make in
            make.top.equalTo(floodHeaderLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
            make.bottom.equalToSuperview().offset(-28)
        }
    }


    private func setupBottomTabBar() {
        addSubview(bottomTabBar)
        bottomTabBar.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)

        let blur = UIBlurEffect(style: .systemMaterial)
        let blurView = UIVisualEffectView(effect: blur)
        bottomTabBar.addSubview(blurView)
        blurView.snp.makeConstraints { make in make.edges.equalToSuperview() }

        bottomTabBar.layer.shadowColor = UIColor.black.cgColor
        bottomTabBar.layer.shadowOpacity = 0.08
        bottomTabBar.layer.shadowOffset = CGSize(width: 0, height: -4)
        bottomTabBar.layer.shadowRadius = 12

        bottomTabBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(84)
        }

        bottomTabBar.addSubview(tabIndicator)
        tabIndicator.backgroundColor = (UIColor(named: "MainColor") ?? .systemBlue).withAlphaComponent(0.12)
        tabIndicator.layer.cornerRadius = 16
        let stack = UIStackView(arrangedSubviews: [mapTabButton, weatherTabButton, forecastTabButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        bottomTabBar.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }

        mapTabButton.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
        weatherTabButton.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
        forecastTabButton.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)

        mapTabButton.tag = 0
        weatherTabButton.tag = 1
        forecastTabButton.tag = 2

        updateTabAppearance(selectedIndex: 0, animated: false)
    }

    @objc private func tabTapped(_ sender: UIButton) {
        navigateToPage(sender.tag, animated: true)
    }

    func navigateToPage(_ index: Int, animated: Bool) {
        currentPage = index
        let offset = CGPoint(x: pagingScrollView.bounds.width * CGFloat(index), y: 0)
        pagingScrollView.setContentOffset(offset, animated: animated)
        updateTabAppearance(selectedIndex: index, animated: true)
    }

    private func updateTabAppearance(selectedIndex: Int, animated: Bool) {
        let buttons = [mapTabButton, weatherTabButton, forecastTabButton]
        let accent = UIColor(named: "MainColor") ?? .systemBlue


        let buttonWidth = bottomTabBar.bounds.width / 3
        let indicatorWidth: CGFloat = 72
        let indicatorX = buttonWidth * CGFloat(selectedIndex) + (buttonWidth - indicatorWidth) / 2

        let update = {
            self.tabIndicator.frame = CGRect(
                x: indicatorX,
                y: 6,
                width: indicatorWidth,
                height: 48
            )
            for (i, btn) in buttons.enumerated() {
                let isSelected = i == selectedIndex
                btn.tintColor = isSelected ? accent : .tertiaryLabel
                btn.transform = isSelected ? CGAffineTransform(scaleX: 1.08, y: 1.08) : .identity
            }
        }

        if animated {
            UIView.animate(withDuration: 0.3, delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.5) { update() }
        } else {
            update()
        }
    }


    private func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }



    func updateWeather(description: String, temp: Double, humidity: Double, precipitation: Double, imageUrl: String?) {
        weatherTempLabel.text = "\(Int(temp))°"
        weatherConditionLabel.text = description
        humidityPill.setValue("\(Int(humidity))%")
        precipPill.setValue("\(Int(precipitation))%")
        updateWeatherImage(with: imageUrl)
        playWeatherAnimation(for: description)
    }
    

    func updateWeatherImage(with urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            weatherIconImageView.image = UIImage(systemName: "cloud")
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async { self.weatherIconImageView.image = image }
            }
        }.resume()
    }

    func updateWeeklyForecast(with data: [WeatherData.DailyForecast]) {
        weeklyWeatherStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (i, day) in data.enumerated() {
            let card = makeDayWeatherCard(day: day)
            card.alpha = 0
            card.transform = CGAffineTransform(translationX: 0, y: 20)
            weeklyWeatherStackView.addArrangedSubview(card)
            UIView.animate(withDuration: 0.4, delay: Double(i) * 0.06,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0) {
                card.alpha = 1
                card.transform = .identity
            }
        }
    }


    func updateFloodForecastGrid(_ days: [FloodRiskDay]) {

        floodGridContainer.subviews.forEach { $0.removeFromSuperview() }

        let columns = 7
        let spacing: CGFloat = 6
        let containerWidth = UIScreen.main.bounds.width - 32
        let cellWidth = (containerWidth - CGFloat(columns - 1) * spacing) / CGFloat(columns)
        let cellHeight = cellWidth * 1.3

        for (index, day) in days.enumerated() {
            let col = index % columns
            let row = index / columns

            let x = CGFloat(col) * (cellWidth + spacing)
            let y = CGFloat(row) * (cellHeight + spacing)

            let cell = makeFloodCell(day: day, width: cellWidth, height: cellHeight)
            cell.frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
            floodGridContainer.addSubview(cell)

            cell.alpha = 0
            UIView.animate(withDuration: 0.4, delay: Double(index) * 0.04,
                           usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
                cell.alpha = 1
            }
        }

        let rows = ceil(Double(days.count) / Double(columns))
        let totalHeight = CGFloat(rows) * (cellHeight + spacing)
        floodGridContainer.snp.updateConstraints { make in
            make.height.equalTo(totalHeight)
        }
    }

    private func makeFloodCell(day: FloodRiskDay, width: CGFloat, height: CGFloat) -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 10
        container.clipsToBounds = true

        switch day.riskLevel {
        case 2:  container.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
        case 1:  container.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)
        default: container.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
        }

        let dayLabel = UILabel()
        dayLabel.text = day.dayName
        dayLabel.font = .systemFont(ofSize: 10, weight: .medium)
        dayLabel.textColor = .secondaryLabel
        dayLabel.textAlignment = .center


        let dateLabel = UILabel()
        dateLabel.text = day.date.split(separator: "-").last.map(String.init) ?? ""
        dateLabel.font = .systemFont(ofSize: 13, weight: .bold)
        dateLabel.textColor = .label
        dateLabel.textAlignment = .center


        let dot = UIView()
        dot.layer.cornerRadius = 4
        switch day.riskLevel {
        case 2:  dot.backgroundColor = .systemRed
        case 1:  dot.backgroundColor = .systemOrange
        default: dot.backgroundColor = .systemGreen
        }

        container.addSubview(dayLabel)
        container.addSubview(dateLabel)
        container.addSubview(dot)

        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        dot.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(8)
        }

        return container
    }


    private func makeDayWeatherCard(day: WeatherData.DailyForecast) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor.secondarySystemBackground
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.06
        card.layer.shadowOffset = CGSize(width: 0, height: 4)
        card.layer.shadowRadius = 8


        let dayLabel = UILabel()
        dayLabel.text = day.date ?? "-"
        dayLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        dayLabel.textAlignment = .center
        dayLabel.textColor = .secondaryLabel
        card.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.centerX.equalToSuperview()
        }


        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        card.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(36)
        }

        if let iconUrl = day.icon, let url = URL(string: iconUrl) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async { iconView.image = image }
                }
            }.resume()
        }


        let maxTempLabel = UILabel()
        maxTempLabel.text = "\(Int(day.maxTemp ?? 0))°"
        maxTempLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        maxTempLabel.textAlignment = .center
        maxTempLabel.textColor = .label
        card.addSubview(maxTempLabel)
        maxTempLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }


        let minTempLabel = UILabel()
        minTempLabel.text = "\(Int(day.minTemp ?? 0))°"
        minTempLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        minTempLabel.textAlignment = .center
        minTempLabel.textColor = .tertiaryLabel
        card.addSubview(minTempLabel)
        minTempLabel.snp.makeConstraints { make in
            make.top.equalTo(maxTempLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }


        let rainLabel = UILabel()
        let precip = day.precipitation ?? 0
        rainLabel.text = "💧\(String(format: "%.1f", precip))mm"
        rainLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        rainLabel.textAlignment = .center
        rainLabel.textColor = .secondaryLabel
        card.addSubview(rainLabel)
        rainLabel.snp.makeConstraints { make in
            make.top.equalTo(minTempLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }

        return card
    }



    private func makeTabButton(icon: String, title: String) -> UIButton {
        let btn = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: icon)
        config.title = title
        config.imagePlacement = .top
        config.imagePadding = 4
        config.baseForegroundColor = .tertiaryLabel
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
            var a = attrs
            a.font = UIFont.systemFont(ofSize: 10, weight: .medium)
            return a
        }
        btn.configuration = config
        return btn
    }



    private func makeHeaderLabel(_ text: String) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        l.textColor = UIColor(named: "MainColor") ?? .label
        return l
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

extension SafetyView {

    func playWeatherAnimation(for condition: String) {

        weatherAnimationViews.forEach { $0.removeFromSuperview() }
        weatherAnimationViews.removeAll()
        weatherAnimationLayers.forEach { $0.removeFromSuperlayer() }
        weatherAnimationLayers.removeAll()
        weatherAnimationContainer.backgroundColor = .clear

        let lower = condition.lowercased()

        if lower.contains("rain") || lower.contains("shower") || lower.contains("drizzle") {
            playRainAnimation()
        } else if lower.contains("thunder") || lower.contains("storm") {
            playThunderstormAnimation()
        } else if lower.contains("cloud") || lower.contains("fog") || lower.contains("overcast") {
            playCloudAnimation()
        } else if lower.contains("clear") || lower.contains("sunny") {
            playSunAnimation()
        } else {
            playCloudAnimation()
        }
    }

    private func playRainAnimation() {
        let gradient = CAGradientLayer()
        gradient.frame = weatherAnimationContainer.bounds
        gradient.colors = [
            UIColor(red: 0.42, green: 0.58, blue: 0.78, alpha: 0.35).cgColor,
            UIColor(red: 0.24, green: 0.38, blue: 0.58, alpha: 0.25).cgColor
        ]
        weatherAnimationContainer.layer.insertSublayer(gradient, at: 0)
        weatherAnimationLayers.append(gradient)

        for i in 0..<40 {
            let drop = UIView()
            let x = CGFloat.random(in: 0...weatherAnimationContainer.bounds.width)
            drop.frame = CGRect(x: x, y: -20, width: 1.5, height: CGFloat.random(in: 12...22))
            drop.backgroundColor = UIColor(red: 0.5, green: 0.7, blue: 1.0, alpha: 0.6)
            drop.layer.cornerRadius = 1
            weatherAnimationContainer.addSubview(drop)
            weatherAnimationViews.append(drop)

            let duration = Double.random(in: 0.5...0.9)
            let delay = Double(i) * 0.04

            UIView.animate(withDuration: duration, delay: delay,
                           options: [.repeat, .curveLinear]) {
                drop.frame.origin.y = self.weatherAnimationContainer.bounds.height + 20
                drop.frame.origin.x += 10
            }
        }
    }

    private func playThunderstormAnimation() {
        playRainAnimation()

        let flash = UIView(frame: weatherAnimationContainer.bounds)
        flash.backgroundColor = .white
        flash.alpha = 0
        weatherAnimationContainer.addSubview(flash)
        weatherAnimationViews.append(flash)

        func triggerFlash() {
            UIView.animateKeyframes(withDuration: 0.3, delay: 0) {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1) { flash.alpha = 0.6 }
                UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.1) { flash.alpha = 0 }
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.1) { flash.alpha = 0.3 }
                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7) { flash.alpha = 0 }
            } completion: { _ in
                let delay = Double.random(in: 3...5)
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) { triggerFlash() }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { triggerFlash() }
    }

    private func playCloudAnimation() {
        let gradient = CAGradientLayer()
        gradient.frame = weatherAnimationContainer.bounds
        gradient.colors = [
            UIColor(white: 0.85, alpha: 0.3).cgColor,
            UIColor(white: 0.75, alpha: 0.2).cgColor
        ]
        weatherAnimationContainer.layer.insertSublayer(gradient, at: 0)
        weatherAnimationLayers.append(gradient)

        for i in 0..<3 {
            let cloud = makeCloudView()
            let startX = -200 + CGFloat(i) * 80
            let y = CGFloat(60 + i * 55)
            cloud.frame.origin = CGPoint(x: startX, y: y)
            weatherAnimationContainer.addSubview(cloud)
            weatherAnimationViews.append(cloud)

            let duration = Double.random(in: 12...18)
            let delay = Double(i) * 1.5

            UIView.animate(withDuration: duration, delay: delay,
                           options: [.repeat, .curveLinear]) {
                cloud.frame.origin.x = self.weatherAnimationContainer.bounds.width + 200
            }
        }
    }

    private func makeCloudView() -> UIView {
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat.random(in: 50...90), weight: .thin)
        let image = UIImage(systemName: "cloud.fill", withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.white.withAlphaComponent(0.6)
        imageView.sizeToFit()
        return imageView
    }

    private func playSunAnimation() {

        let gradient = CAGradientLayer()
        gradient.frame = weatherAnimationContainer.bounds
        gradient.colors = [
            UIColor(red: 1.0, green: 0.85, blue: 0.4, alpha: 0.3).cgColor,
            UIColor(red: 1.0, green: 0.65, blue: 0.2, alpha: 0.2).cgColor
        ]
        weatherAnimationContainer.layer.insertSublayer(gradient, at: 0)
        weatherAnimationLayers.append(gradient)


        let sun = UIView()
        let sunSize: CGFloat = 80
        sun.frame = CGRect(
            x: weatherAnimationContainer.bounds.midX - sunSize / 2,
            y: 40,
            width: sunSize,
            height: sunSize
        )
        sun.layer.cornerRadius = sunSize / 2
        sun.backgroundColor = UIColor(red: 1.0, green: 0.85, blue: 0.3, alpha: 0.5)
        weatherAnimationContainer.addSubview(sun)
        weatherAnimationViews.append(sun)

        let rays = UIView(frame: sun.frame.insetBy(dx: -30, dy: -30))
        rays.center = sun.center
        weatherAnimationContainer.insertSubview(rays, belowSubview: sun)
        weatherAnimationViews.append(rays)

        for i in 0..<8 {
            let ray = UIView()
            let angle = CGFloat(i) * (.pi / 4)
            let rayLength: CGFloat = 28
            ray.frame = CGRect(x: rays.bounds.midX - 2, y: 4, width: 4, height: rayLength)
            ray.layer.cornerRadius = 2
            ray.backgroundColor = UIColor(red: 1.0, green: 0.85, blue: 0.3, alpha: 0.6)
            ray.layer.anchorPoint = CGPoint(x: 0.5, y: 0)

            let transform = CGAffineTransform(translationX: 0, y: rays.bounds.midY - 4)
                .rotated(by: angle)
                .translatedBy(x: 0, y: -rays.bounds.midY + 4)
            ray.transform = transform

            rays.addSubview(ray)
        }


        UIView.animate(withDuration: 2.5, delay: 0,
                       options: [.repeat, .autoreverse, .curveEaseInOut]) {
            sun.transform = CGAffineTransform(scaleX: 1.12, y: 1.12)
        }

        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 12
        rotation.repeatCount = .infinity
        rays.layer.add(rotation, forKey: "sunRotation")
        weatherAnimationLayers.append(rays.layer)
    }
}


extension SafetyView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == pagingScrollView else { return }
        let page = Int(round(scrollView.contentOffset.x / max(scrollView.bounds.width, 1)))
        if page != currentPage {
            currentPage = page
            updateTabAppearance(selectedIndex: page, animated: true)
        }
    }
}


class WeatherDetailPill: UIView {
    private let iconLabel = UILabel()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    init(icon: String, title: String) {
        super.init(frame: .zero)
        backgroundColor = UIColor.tertiarySystemBackground
        layer.cornerRadius = 14

        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 22)
        iconLabel.textAlignment = .center

        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center

        valueLabel.text = "--"
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        valueLabel.textColor = .label
        valueLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [iconLabel, valueLabel, titleLabel])
        stack.axis = .vertical
        stack.spacing = 2
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    func setValue(_ value: String) {
        valueLabel.text = value
    }
}
