# TableViewConfigurator

[![CI Status](http://img.shields.io/travis/John Volk/TableViewConfigurator.svg?style=flat)](https://travis-ci.org/John Volk/TableViewConfigurator)
[![Version](https://img.shields.io/cocoapods/v/TableViewConfigurator.svg?style=flat)](http://cocoapods.org/pods/TableViewConfigurator)
[![License](https://img.shields.io/cocoapods/l/TableViewConfigurator.svg?style=flat)](http://cocoapods.org/pods/TableViewConfigurator)
[![Platform](https://img.shields.io/cocoapods/p/TableViewConfigurator.svg?style=flat)](http://cocoapods.org/pods/TableViewConfigurator)

A declarative approach to UITableView configuration that enables you to create thinner controllers with less of the error-prone delegate code that typically results from implementing UITableView-based interfaces.

## Installation

TableViewConfigurator is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TableViewConfigurator"
```

## Usage

`TableViewConfigurator` is based around the concepts of `RowConfiguration` and `SectionConfiguration`.

At the bottom of the conceptual hierachy is the `RowConfiguration`. A `RowConfiguration` allows you to specify individual rows or groups of rows that should appear in your `UITableView`. The two flavors it currently comes in are `ConstantRowConfiguration` and `ModelRowConfiguration`.

A `ConstantRowConfiguration` represents a single row in your `UITableView`. All it takes to create one is an implementation of the `ConfigurableTableViewCell` protocol that is specified in the constructor of `ConstantRowConfiguration` via a generic type parameter.

```swift
import UIKit
import TableViewConfigurator

class BasicCell: UITableViewCell, ConfigurableTableViewCell {

    override class func buildReuseIdentifier() -> String? {
        return "basicCell";
    }
    
    func configure() {
        self.textLabel?.text = "Basic Cell"
    }
}
```

```swift
let rowConfiguration = ConstantRowConfiguration<BasicCell>();
```

## Author

John Volk, john.t.volk@gmail.com

## License

TableViewConfigurator is available under the MIT license. See the LICENSE file for more info.
