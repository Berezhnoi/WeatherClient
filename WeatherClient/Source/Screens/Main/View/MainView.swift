//
//  MainView.swift
//  WeatherClinet2024
//
//  Created by user on 06.05.2024.
//

import UIKit

class MainView: UIView {
    
    weak var delegate: MainViewDelegate?
    private var collectionView: UICollectionView!
    private var headerView: HeaderView!
    
    private var forecastMeta: CDForecast?
    private var forecastItems: [CDForecastItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getForecastItemByIndex(_ index: Int) -> CDForecastItem? {
        return forecastItems[index]
    }
    
    public func getForecastItemsCount() -> Int {
        return forecastItems.count
    }
}

// MARK: - UI
private extension MainView {
    private func setupUI() {
        setupHeaderView()
        setupCollectionView()
    }
    
    private func setupHeaderView() {
        headerView = HeaderView(frame: .zero)
        headerView.backgroundColor = UIColor(red: 0.67, green: 0.84, blue: 0.90, alpha: 1.0)
        addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constant.HEADER_HEIGHT)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        layout.minimumLineSpacing = 10
//        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(red: 0.67, green: 0.84, blue: 0.90, alpha: 1.0)
        addSubview(collectionView)
        
        // Register custom cell classes
        collectionView.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: CurrentWeatherCell.reuseIdentifier)
        collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: ForecastCell.reuseIdentifier)
        
        // Configure layout constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - MainViewProtocol
extension MainView: MainViewProtocol {
    func setupCurrentWeather(with data: CDWeatherInfo) {
        let cityName = data.cityName ?? "-"
        let temperature = "\(Int(data.temperature.rounded()))"
        headerView.configure(cityName: cityName, temperature: temperature)
    }
    
    func setupForecast(forecastMeta: CDForecast, forecastItems: [CDForecastItem]) {
        self.forecastMeta = forecastMeta
        self.forecastItems = forecastItems.sorted(by: { ($0.date ?? Date()) < ($1.date ?? Date()) })
        collectionView.reloadData()
    }
}

// MARK: - Constant
private enum Constant {
    
    static let HEADER_HEIGHT: CGFloat = 140.0
}
