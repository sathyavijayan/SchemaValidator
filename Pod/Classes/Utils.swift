//
//  Utils.swift
//  SchemaValidator
//
//  Created by Sathyavijayan Vittal on 05/06/2015.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import Foundation

internal func < (left: NSNumber, right: NSNumber) -> Bool {
    var comparisonResult:NSComparisonResult = left.compare(right)
    return (comparisonResult == NSComparisonResult.OrderedAscending) ? true: false
}

internal func <= (left: NSNumber, right: NSNumber) -> Bool {
    var comparisonResult:NSComparisonResult = left.compare(right)
    return (comparisonResult == NSComparisonResult.OrderedAscending || comparisonResult == NSComparisonResult.OrderedSame) ? true: false
}

internal func > (left: NSNumber, right: NSNumber) -> Bool {
    var comparisonResult:NSComparisonResult = left.compare(right)
    return (comparisonResult == NSComparisonResult.OrderedDescending) ? true: false
}

internal func >= (left: NSNumber, right: NSNumber) -> Bool {
    var comparisonResult:NSComparisonResult = left.compare(right)
    return (comparisonResult == NSComparisonResult.OrderedDescending || comparisonResult == NSComparisonResult.OrderedSame) ? true: false
}
