//
//  ModelRowConfigurationSpec.swift
//  TableViewConfigurator
//
//  Created by John Volk on 3/4/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import TableViewConfigurator

class ModelRowConfigurationSpec: QuickSpec {
    
    private static let MODEL_CONFIGURABLE_CELL_REUSE_ID = "modelConfigurableCell";
    private let things = [Thing(name: "Tree"), Thing(name: "Frisbee"), Thing(name: "Hatchback")];
    
    override func spec() {
        describe("a model row configuration") {
            var tableView: UITableView!;
            var rowConfiguration: ModelRowConfiguration<ModelConfigurableCell, Thing>!;
            var implicitIdRowConfiguration: ModelRowConfiguration<ModelImplicitReuseIdCell, Thing>!;
            
            beforeEach {
                tableView = UITableView();
                tableView.registerClass(ModelConfigurableCell.self, forCellReuseIdentifier: ModelRowConfigurationSpec.MODEL_CONFIGURABLE_CELL_REUSE_ID);
                tableView.registerClass(ModelImplicitReuseIdCell.self, forCellReuseIdentifier: ModelImplicitReuseIdCell.REUSE_ID);
                rowConfiguration = ModelRowConfiguration(models: self.things);
                implicitIdRowConfiguration = ModelRowConfiguration(models: self.things);
            }
            
            describe("its cell reuse id") {
                it("is set correctly when explicitly defined") {
                    expect(rowConfiguration.cellReuseId(ModelRowConfigurationSpec.MODEL_CONFIGURABLE_CELL_REUSE_ID).cellReuseId)
                        .to(equal(ModelRowConfigurationSpec.MODEL_CONFIGURABLE_CELL_REUSE_ID));
                }
            }
            
            describe("its produced cell") {
                it("is the correct type when cellReuseId explicitly defined") {
                    let cell = rowConfiguration
                        .cellReuseId(ModelRowConfigurationSpec.MODEL_CONFIGURABLE_CELL_REUSE_ID)
                        .cellForRow(0, inTableView: tableView);
                    
                    expect(cell).to(beAnInstanceOf(ModelConfigurableCell));
                }
                
                it("is the correct type when cellReuseId implicitly defined") {
                    expect(implicitIdRowConfiguration.cellForRow(0, inTableView: tableView)).to(beAnInstanceOf(ModelImplicitReuseIdCell));
                }
                
                it("is nil when asking for non-existant row") {
                    expect(implicitIdRowConfiguration.cellForRow(3, inTableView: tableView)).to(beNil());
                }
                
                it("is configured correctly") {
                    let cell = implicitIdRowConfiguration.cellForRow(1, inTableView: tableView) as? ModelImplicitReuseIdCell;
                    
                    expect(cell).toNot(beNil());
                    expect(cell?.model).toNot(beNil());
                    expect(cell?.model?.name).to(equal("Frisbee"));
                }
            }
            
            describe("its height") {
                it("is set correctly for existant row") {
                    expect(rowConfiguration.height(100.0).heightForRow(0))
                        .to(equal(100.0));
                }
                
                it("is nil when asking for non-existant row") {
                    expect(rowConfiguration.height(100.0).heightForRow(3))
                        .to(beNil());
                }
            }
            
            describe("its estimated height") {
                it("is set correctly for existant row") {
                    expect(rowConfiguration.estimatedHeight(200.0).estimatedHeightForRow(0))
                        .to(equal(200.0));
                }
                
                it("is nil when asking for non-existant row") {
                    expect(rowConfiguration.estimatedHeight(100.0).estimatedHeightForRow(3))
                        .to(beNil());
                }
            }
            
            describe("its row count") {
                context("when visible") {
                    it("is correct") {
                        expect(rowConfiguration.numberOfRows()).to(equal(3));
                    }
                }
                
                context("when hidden") {
                    it("is correct") {
                        expect(rowConfiguration.hideWhen({ return $0 === self.things[0] || $0 === self.things[2] }).numberOfRows()).to(equal(1));
                    }
                }
            }
            
            describe("its selection handler") {
                it("is invoked when selected") {
                    var selectionHandlerInvoked = false;
                    
                    rowConfiguration.selectionHandler({ (model) -> Bool in
                        selectionHandlerInvoked = true; return true;
                    }).didSelectRow(2);
                    
                    expect(selectionHandlerInvoked).to(beTrue());
                }
                
                it("is not invoked when selecting non-existant row") {
                    var selectionHandlerInvoked = false;
                    
                    rowConfiguration.selectionHandler({ (model) -> Bool in
                        selectionHandlerInvoked = true; return true;
                    }).didSelectRow(5);
                    
                    expect(selectionHandlerInvoked).to(beFalse());
                }
            }
            
            describe("its additional config") {
                it("is applied when retrieving a cell") {
                    let cell = implicitIdRowConfiguration
                        .additionalConfig({ (cell, model) -> Void in
                            cell.additionallyConfigured = true;
                        }).cellForRow(2, inTableView: tableView) as? ModelImplicitReuseIdCell;
                    
                    expect(cell).toNot(beNil());
                    expect(cell?.additionallyConfigured).to(beTrue());
                }
            }
        }
    }
}