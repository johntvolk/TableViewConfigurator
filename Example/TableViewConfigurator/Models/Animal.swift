//
//  Animal.swift
//  TableViewConfigurator
//
//  Created by John Volk on 3/1/16.
//  Copyright © 2016 John Volk. All rights reserved.
//

import TableViewConfigurator

class Animal: RowModel {

    var tag: Int?
    let name: String
    let scientificName: String
    
    init(name: String, scientificName: String) {
        self.name = name
        self.scientificName = scientificName
    }
}
