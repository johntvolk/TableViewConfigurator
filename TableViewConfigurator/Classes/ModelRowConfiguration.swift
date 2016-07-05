//
//  ModelRowConfiguration.swift
//  Pods
//
//  Created by John Volk on 3/1/16.
//  Copyright © 2016 John Volk. All rights reserved.
//

import UIKit

public class ModelRowConfiguration<CellType: ModelConfigurableTableViewCell, ModelType where CellType: UITableViewCell, CellType.ModelType == ModelType>: RowConfiguration {

    private let models: [ModelType]?
    private let modelGenerator: (() -> [ModelType])?
    
    private var heightGenerator: ((model: ModelType) -> CGFloat)?
    private var estimatedHeightGenerator: ((model: ModelType) -> CGFloat)?
    private var additionalConfig: ((cell: CellType, model: ModelType) -> Void)?
    private var selectionHandler: ((model: ModelType) -> Bool)?
    private var hideWhen: ((model: ModelType) -> Bool)?
    
    public init(models: [ModelType]) {
        self.models = models
        self.modelGenerator = nil
    }
    
    public init(modelGenerator: () -> [ModelType]) {
        self.modelGenerator = modelGenerator
        self.models = nil
    }
    
    public func heightGenerator(heightGenerator: (model: ModelType) -> CGFloat) -> Self {
        self.heightGenerator = heightGenerator
        return self
    }
    
    public func estimatedHeightGenerator(estimatedHeightGenerator: (model: ModelType) -> CGFloat) -> Self {
        self.estimatedHeightGenerator = estimatedHeightGenerator
        return self
    }
    
    public func additionalConfig(additionalConfig: (cell: CellType, model: ModelType) -> Void) -> Self {
        self.additionalConfig = additionalConfig
        return self
    }
    
    public func selectionHandler(selectionHandler: (model: ModelType) -> Bool) -> Self {
        self.selectionHandler = selectionHandler
        return self
    }
    
    public func hideWhen(hideWhen: (model: ModelType) -> Bool) -> Self {
        self.hideWhen = hideWhen
        return self
    }
    
    override internal func numberOfRows(countHidden: Bool) -> Int {
        let models = generateModels()
        
        if let hideWhen = self.hideWhen where !countHidden {
            return models.reduce(0) { (totalRows, model) -> Int in
                return totalRows + (hideWhen(model: model) ? 0 : 1)
            }
        }
        
        return models.count
    }
    
    override func rowIsVisible(row: Int) -> Bool? {
        if row < numberOfRows(true) {
            if let hideWhen = self.hideWhen {
                return !hideWhen(model: generateModels()[row])
            }
            
            return true
        }
        
        return nil
    }
    
    override func cellForRow(row: Int, inTableView tableView: UITableView) -> UITableViewCell? {
        if row < numberOfRows(false) {
            let reuseId = self.cellReuseId ?? CellType.buildReuseIdentifier()

            if let cell = tableView.dequeueReusableCellWithIdentifier(reuseId) as? CellType {
                return configureCell(cell, forRow: row)
            }
        }
        
        return nil
    }
    
    override func refreshCellForRow(row: Int, withIndexPath indexPath: NSIndexPath, inTableView tableView: UITableView) {
        if row < numberOfRows(false) {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? CellType {
                configureCell(cell, forRow: row)
            }
        }
    }
    
    private func configureCell(cell: CellType, forRow row: Int) -> CellType {
        let model = self.selectModelForRow(row)
        
        cell.configure(model)
        
        if let additionalConfig = self.additionalConfig {
            additionalConfig(cell: cell, model: model)
        }
        
        return cell
    }
    
    override func heightForRow(row: Int) -> CGFloat? {
        if let heightGenerator = self.heightGenerator where row < numberOfRows(false) {
            return heightGenerator(model: selectModelForRow(row))
        }
        
        return super.heightForRow(row)
    }
    
    override func estimatedHeightForRow(row: Int) -> CGFloat? {
        if let estimatedHeightGenerator = self.estimatedHeightGenerator where row < numberOfRows(false) {
            return estimatedHeightGenerator(model: selectModelForRow(row))
        }
        
        return super.estimatedHeightForRow(row)
    }
    
    override internal func didSelectRow(row: Int) -> Bool? {
        if row < numberOfRows(false) {
            return self.selectionHandler?(model: selectModelForRow(row))
        }
        
        return nil
    }
    
    private func selectModelForRow(row: Int) -> ModelType {
        let models = generateModels()
        
        if let hideWhen = self.hideWhen {
            var unhiddenTotal = 0
            
            for model in models {
                unhiddenTotal += (hideWhen(model: model) ? 0 : 1)
                
                if unhiddenTotal - 1 == row {
                    return model
                }
            }
        }
        
        return models[row]
    }
    
    private func generateModels() -> [ModelType]! {
        if let models = self.models {
            return models
        }
        
        return self.modelGenerator!()
    }
}