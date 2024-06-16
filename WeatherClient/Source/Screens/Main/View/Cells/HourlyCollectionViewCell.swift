import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "HourlyCollectionViewCell"
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeLabel, weatherIconImageView, temperatureLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center // Use .center to avoid conflicts with alignment
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8) // Added bottom constraint with constant -8
        ])
    }
    
    func configure(with time: String, temperature: String, weatherCondition: String?) {
        timeLabel.text = time
        temperatureLabel.text = temperature
        if let weatherCondition = weatherCondition, let iconImage = UIImage(named: weatherCondition) {
            weatherIconImageView.image = iconImage
        }
    }
}
