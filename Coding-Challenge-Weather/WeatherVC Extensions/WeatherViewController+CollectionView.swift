//
//  WeatherViewController+CollectionView.swift
//  Coding-Challenge-Weather
//
//  Created by Andres S. Hernandez G. on 5/31/23.
//

import UIKit

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherAttributes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherAttributeCell.reuseIdentifier, for: indexPath) as? WeatherAttributeCell else {
            return UICollectionViewCell()
        }
        
        let weatherAttribute = weatherAttributes[indexPath.item]
        cell.configure(with: weatherAttribute)
        
        return cell
    }
}
