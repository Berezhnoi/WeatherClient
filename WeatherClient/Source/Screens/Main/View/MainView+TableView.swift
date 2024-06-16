//
//  MainView+TableView.swift
//  WeatherClient
//
//  Created by rendi on 09.06.2024.
//

import UIKit

// MARK: - UITableViewDataSource
extension MainView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1 // cell that is CollectionViewCell
        }
        return getForecastItemsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.reuseIdentifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: getHourlyForecastItems())
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ForecastCell.reuseIdentifier, for: indexPath) as! ForecastCell
            
            // Determine if it's the first or last cell in the section
            let isFirstCell = indexPath.row == 0
            let isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
            
            // Apply border radius based on isFirstCell and isLastCell
            cell.applyBorderRadius(top: isFirstCell, bottom: isLastCell)
            
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
            return 120 // Hourly cell size
        }
        
        return 65 // Forecast cell size
    }
}
