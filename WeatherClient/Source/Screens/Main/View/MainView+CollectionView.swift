//
//  MainView+CollectionView.swift
//  WeatherClient
//
//  Created by rendi on 25.05.2024.
//

import UIKit

// MARK: - UICollectionViewDataSource
// MARK: - UICollectionViewDataSource
extension MainView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return getForecastItemsCount()
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.reuseIdentifier, for: indexPath) as! ForecastCell
            if let forecastItem = getForecastItemByIndex(indexPath.row) {
                let title = forecastItem.date?.dayOfWeek() ?? "-"
                let tempMin: String = "\(Int(forecastItem.tempMin.rounded()))"
                let tempMax: String = "\(Int(forecastItem.tempMax.rounded()))"
                cell.configure(title: title, tempMin: tempMin, tempMax: tempMax)
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width - 20, height: 100) // Current weather cell size
        } else {
            return CGSize(width: collectionView.frame.width - 20, height: 60) // Forecast cell size
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50) // Header view size
    }
}
