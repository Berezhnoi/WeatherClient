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
            cell.configure(with: forecastItems)
            return cell
        }
        
        if indexPath.section == 1 {
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
            return 110 // Hourly cell size
        }
        
        return 65 // Forecast cell size
    }
    
    // Add a custom header view to create a gap between sections
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear // Set background color to clear or any desired color
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1 // Adjust the height as needed to create the gap
    }
}
