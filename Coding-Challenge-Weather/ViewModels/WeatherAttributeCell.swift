//
//  WeatherAttributeCell.swift
//  Coding-Challenge-Weather
//
//  Created by Andres S. Hernandez G. on 5/31/23.
//

import Foundation
import UIKit

class WeatherAttributeCell: UICollectionViewCell {
    
    // MARK: - Properties & UI Components
    static let reuseIdentifier = "WeatherAttributeCell"
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup Methods
    
    func setupUI() {
        contentView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        contentView.layer.cornerRadius = 8.0
        contentView.clipsToBounds = true
        
        // Add and configure iconImageView, nameLabel, and valueLabel as subviews
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(valueLabel)
        
        // Set up constraints for the subviews
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            
            nameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            valueLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Public Configuration Method
    
    func configure(with weatherAttribute: WeatherAttribute) {
        nameLabel.text = weatherAttribute.name
        iconImageView.image = UIImage(systemName: weatherAttribute.iconName)
        valueLabel.text = weatherAttribute.value
    }
}
