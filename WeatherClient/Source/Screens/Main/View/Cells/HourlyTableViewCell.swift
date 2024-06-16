import UIKit

class HourlyTableViewCell: UITableViewCell {
    static let reuseIdentifier = "HourlyTableViewCell"
    
    private var hourlyData: [CDHourlyForecastItem] = []
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 12
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: HourlyCollectionViewCell.reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with hourlyData: [CDHourlyForecastItem]) {
        self.hourlyData = hourlyData
        collectionView.reloadData()
    }
}

extension HourlyTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.reuseIdentifier, for: indexPath) as! HourlyCollectionViewCell
        let hourlyWeather = hourlyData[indexPath.item]

        let timeText: String
        if indexPath.item == 0 {
            timeText = "Now"
        } else if let date = hourlyWeather.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ha" // Format to display hour in 12-hour format with AM/PM
            
            // Check if it's the first item of the day
            let previousHourlyWeather = hourlyData[indexPath.item - 1]
            if let previousDate = previousHourlyWeather.date,
               !Calendar.current.isDate(date, equalTo: previousDate, toGranularity: .day) {
                let dayOfWeek = date.dayOfWeek()
                timeText = "\(dayOfWeek) \(dateFormatter.string(from: date))"
            } else {
                timeText = dateFormatter.string(from: date)
            }
        } else {
            timeText = "-"
        }

        cell.configure(
            with: timeText,
            temperature: "\(Int(hourlyWeather.temperature.rounded()))°",
            weatherCondition: hourlyWeather.weatherCondition
        )
        return cell
    }
}

extension HourlyTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 100) // Adjust as needed
    }
}
