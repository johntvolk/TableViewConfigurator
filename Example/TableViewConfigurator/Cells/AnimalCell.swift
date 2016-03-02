//
//  AnimalCell.swift
//  TableViewConfigurator
//
//  Created by John Volk on 3/1/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import TableViewConfigurator

class AnimalCell: UITableViewCell, ModelConfigurableTableViewCell {
    
    @IBOutlet var nameLabel: UILabel!;
    @IBOutlet var scientificNameLabel: UILabel!;
    
    override class func buildReuseIdentifier() -> String? {
        return "animalCell";
    }
    
    func configure(model: Animal) {
        self.nameLabel.text = model.name
        self.scientificNameLabel.text = model.scientificName;
    }
}
