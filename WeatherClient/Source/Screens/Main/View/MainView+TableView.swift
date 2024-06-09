//
//  MainView+TableView.swift
//  WeatherClient
//
//  Created by rendi on 09.06.2024.
//

import UIKit

// MARK: - UITableViewDataSource
extension MainView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getForecastItemsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ForecastCell.reuseIdentifier, for: indexPath) as! ForecastCell
            if let forecastItem = getForecastItemByIndex(indexPath.row) {
                let title = forecastItem.date?.dayOfWeek() ?? "-"
                let tempMin: String = "\(Int(forecastItem.tempMin.rounded()))°"
                let tempMax: String = "\(Int(forecastItem.tempMax.rounded()))°"
                let weatherCondition = forecastItem.weatherCondition
                cell.configure(
                    title: title,
                    tempMin: tempMin,
                    tempMax: tempMax,
                    weatherCondition: weatherCondition
                )
            }
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension MainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50 // Forecast cell size
        } else {
            return 0
        }
    }
}
