//
//  MainView.swift
//  WeatherClinet2024
//
//  Created by user on 06.05.2024.
//

import UIKit

class MainView: UIView {
    
    weak var delegate: MainViewDelegate?
    private var tableView: UITableView!
    
    private var forecastMeta: CDForecast?
    private var forecastItems: [CDForecastItem] = []
    private var hourlyForecastItems: [CDHourlyForecastItem] = []
    
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
    
    public func getHourlyForecastItems() -> [CDHourlyForecastItem] {
        return hourlyForecastItems;
    }
}

// MARK: - UI
private extension MainView {
    private func setupUI() {
        setupTableView()
    }
    
    private func createTableHeader() -> UIView {
        let headerFrame = CGRect(
            x: 0,
            y: 0,
            width: tableView.frame.size.width,
            height: Constant.HEADER_HEIGHT
        )
        let headerView = HeaderView(frame: headerFrame)
        return headerView
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(red: 0.67, green: 0.84, blue: 0.90, alpha: 1.0)
        tableView.tableHeaderView = createTableHeader()
        
        addSubview(tableView)
        
        // Register custom cell classes
        tableView.register(HourlyTableViewCell.self, forCellReuseIdentifier: HourlyTableViewCell.reuseIdentifier)
        tableView.register(ForecastCell.self, forCellReuseIdentifier: ForecastCell.reuseIdentifier)
        
        // Configure layout constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Prevent automatic adjustment of content inset
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        // Set default separator inset for other cells
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

// MARK: - MainViewProtocol
extension MainView: MainViewProtocol {
    
    func setupCurrentWeather(with data: CDWeatherInfo) {
        let cityName = data.cityName ?? "-"
        let temperature = "\(Int(data.temperature.rounded()))"
        guard let tableHeaderView = tableView.tableHeaderView as? HeaderView else {
            return;
        }
        tableHeaderView.configure(cityName: cityName, temperature: temperature)
    }
    
    func setupForecast(forecastMeta: CDForecast, forecastItems: [CDForecastItem], hourlyForecastItems: [CDHourlyForecastItem]) {
        self.forecastMeta = forecastMeta
        self.forecastItems = forecastItems.sorted(by: { ($0.date ?? Date()) < ($1.date ?? Date()) })
        self.hourlyForecastItems = hourlyForecastItems.sorted(by: { ($0.date ?? Date()) < ($1.date ?? Date()) })
        tableView.reloadData()
    }
}

// MARK: - Constant
private enum Constant {
    
    static let HEADER_HEIGHT: CGFloat = 140.0
}
