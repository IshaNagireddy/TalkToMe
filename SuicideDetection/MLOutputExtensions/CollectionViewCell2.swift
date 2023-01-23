//
//  CollectionViewCell2.swift
//  SuicideDetection
//
//  Created by Isha Nagireddy on 11/26/22.
//

import UIKit

class CollectionViewCell2: UICollectionViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static let identifier2 = String(describing:CollectionViewCell2.self)
    
    func setup(slide: CollectionViewOptions2) {
        questionLabel.text = slide.questionLabel
        descriptionLabel.text = slide.descriptionLabel
    }
    
    
}
