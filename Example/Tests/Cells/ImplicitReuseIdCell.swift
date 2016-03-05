//
//  ImplicitReuseIdCell.swift
//  TableViewConfigurator
//
//  Created by John Volk on 3/3/16.
//  Copyright © 2016 John Volk. All rights reserved.
//

import UIKit

class ImplicitReuseIdCell: ConfigurableCell {

    static let REUSE_ID = "implicitReuseIdCell";
    
    override class func buildReuseIdentifier() -> String? {
        return ImplicitReuseIdCell.REUSE_ID;
    }
}
