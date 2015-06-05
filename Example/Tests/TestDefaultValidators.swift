//
//  TestDefaultValidators.swift
//  SchemaValidator
//
//  Created by Sathyavijayan Vittal on 04/06/2015.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import Foundation
import XCTest

class TestDefaultValidators: XCTestCase {
    
    typealias V = SchemaValidator

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPresent() {
        XCTAssertFalse(V.Present(nil).0, "Presence for Nil")
        XCTAssertTrue(V.Present("Hello").0, "Presence for a String")
        XCTAssertTrue(V.Present([1,2,3]).0, "Presence for an array")
        XCTAssertEqual(V.Present(nil).1!, ValidationMessages.message(forKey: "Present"), "Error message for Presence")
    }
    
    func testNotEmpty() {
        XCTAssertFalse(V.NotEmpty(nil).0, "Not Empty for Nil")
        XCTAssertFalse(V.NotEmpty([]).0, "Not Empty for Empty Array")
        XCTAssertFalse(V.NotEmpty([:]).0, "Not Empty for Empty Dictionary")
        XCTAssertFalse(V.NotEmpty("").0, "Not Empty for Empty String")
        
        XCTAssertTrue(V.NotEmpty([1,2,3]).0, "Not Empty for Array")
        XCTAssertTrue(V.NotEmpty(["name":"sats"]).0, "Not Empty for Dictionary")
        XCTAssertTrue(V.NotEmpty("sathya").0, "Not Empty for String")
        XCTAssertTrue(V.NotEmpty(Set([1,2,3])).0, "Not Empty for Set")
        
        XCTAssertEqual(V.NotEmpty(nil).1!, ValidationMessages.message(forKey: "NotEmpty"), "Error message for not empty")

    }
    
    
    func testInteger() {
        XCTAssertFalse(V.Integer(nil).0, "Integer for nil")
        XCTAssertFalse(V.Integer(5.6).0, "Integer for decimal type")
        XCTAssertFalse(V.Integer(NSNumber(float: 5.9)).0, "Integer for decimal type wrapped in NSNumber")
        XCTAssertFalse(V.Integer("Dummy").0, "Integer for a string type")

        XCTAssertTrue(V.Integer(12).0, "Integer for a Int type")
        XCTAssertEqual(V.Integer([1,2,3]).1!, ValidationMessages.message(forKey: "Integer"), "Error message for integer")
    }
    
    
    func testNumeric() {
        XCTAssertFalse(V.Numeric(nil).0, "Numeric for nil")
        XCTAssertFalse(V.Numeric("Dummy").0, "Integer for a string type")

        XCTAssertTrue(V.Numeric(5).0, "Numeric for int type")
        XCTAssertTrue(V.Numeric(5.6).0, "Numeric for decimal type")
        XCTAssertTrue(V.Numeric(NSNumber(float: 5.9)).0, "Numeric for decimal type wrapped in NSNumber")
        XCTAssertEqual(V.Numeric([1,2,3]).1!, ValidationMessages.message(forKey: "Numeric"), "Error message for Numeric")
    }
    
    func testEqual() {
        //String, Array, Dictionary, Int, Float
        XCTAssertFalse(V.Equals("Hello")("Hello World").0, "Equality of String")
        XCTAssertFalse(V.Equals("Hello")(nil).0, "Equality of String")
        XCTAssertFalse(V.Equals(1)(5).0, "Equality of String")
        XCTAssertFalse(V.Equals(5.6)(5).0, "Equality of String")
        
        XCTAssertTrue(V.Equals("Hello")("Hello").0, "Equality of String")
        XCTAssertTrue(V.Equals(1)(1.0).0, "Equality of numbers")
        XCTAssertTrue(V.Equals([1, 2, 3])([1, 2, 3]).0, "Equality of array")
        XCTAssertTrue(V.Equals([1: "One", 2: "Two"])([1: "One", 2: "Two"]).0, "Equality of array")
        var range:Range? = V.Equals([1,2,3])(5).1!.rangeOfString(ValidationMessages.message(forKey: "Equals"), options: nil, range: nil, locale: nil)
        XCTAssertTrue((range != nil), "Error message for Equals")
    }
    
    func testSize() {
        XCTAssertFalse(V.Size(5)(nil).0, "Size of Nil")

        XCTAssertFalse(V.Size(5)("Hello World").0, "Size of String")
        XCTAssertTrue(V.Size(5)("Hello").0, "Size of String")
        
        XCTAssertFalse(V.Size(5)([1,2,3,4,5,6]).0, "Size of Array")
        XCTAssertTrue(V.Size(5)([1,2,3,4,5]).0, "Size of Array")

        XCTAssertFalse(V.Size(1)([1: "One", 2: "Two"]).0, "Size of Dictionary")
        XCTAssertTrue(V.Size(2)([1: "One", 2: "Two"]).0, "Size of Dictionary")

        XCTAssertFalse(V.Size(5)(Set([1,2,3,4,5,6])).0, "Size of Set")
        XCTAssertTrue(V.Size(5)(Set([1,2,3,4,5])).0, "Size of Set")
    }
    
    func testRegex() {
        XCTAssertFalse(V.Regex("^Hello")(nil).0, "Regex for nil")
        
        XCTAssertFalse(V.Regex("^Hello")("Oh Hello World").0, "Regex for incorrect string")
        XCTAssertTrue(V.Regex("^Hello")("Hello World").0, "Regex for correct string")
        XCTAssertFalse(V.Regex("^Hello")(5).0, "Regex for incorrect type")
        
        var range:Range? = V.Regex("^Hello")(5).1!.rangeOfString(ValidationMessages.message(forKey: "Regex"), options: nil, range: nil, locale: nil)
        XCTAssertTrue((range != nil), "Error message for Regex")
    }
    
    func testEmail() {
        let validEmails:[String] = [
            "sathyavijayan@icloud.com",
            "sathya.vijayan_v@icloud.com",
            "sathyavijayan@ios.samsara.co.uk"
        ]
        
        var results:[Bool] = validEmails.map {
            V.Email($0).0
        }
        
        XCTAssertFalse(contains(results, false), "Email for valid emails")
        
        let invalidEmails:[String] = [
            "sathyavijayan@icloud",
            "sathya.vij#$ayan_v@icloud.com",
            "sathya"
        ]
        
        var results_invalid:[Bool] = invalidEmails.map {
            V.Email($0).0
        }
        
        XCTAssertFalse(contains(results_invalid, true), "Email for invalid emails")
        
        XCTAssertEqual(V.Email("dummy").1!, ValidationMessages.message(forKey: "Email"), "Error message for Email")
    }
    
    func testURL() {
        let validURLs:[String] = [
            "http://www.google.com",
            "http://api.samsara.io",
            "localhost:7777",
            "http://isats:7777",
            "api.samsara.co.uk/v1",
            "google.com:8888"
        ]
        
        var results:[Bool] = validURLs.map {
            V.URL($0).0
        }

        XCTAssertFalse(contains(results, false), "URL for valid urls")
        
        let invalidURLs:[String] = [
            "samsara.io$v1"
        ]
        
        var results_invalid:[Bool] = invalidURLs.map {
            V.URL($0).0
        }
        
        XCTAssertFalse(contains(results_invalid, true), "URL for invalid URLs")
        
        XCTAssertEqual(V.URL("1#!dummy").1!, ValidationMessages.message(forKey: "URL"), "Error message for URL")
    }
    
    func testBetween() {
        XCTAssertFalse(V.Between(1, and: 10)(nil).0, "Between for nil")
        XCTAssertFalse(V.Between(1, and: 10)(50).0, "Between for invalid int")
        XCTAssertFalse(V.Between(1, and: 10)(50.766).0, "Between for invalid double")
        XCTAssertFalse(V.Between(1, and: 10)("string").0, "Between for invalid type")
        
        XCTAssertTrue(V.Between(1, and: 10)(5).0, "Between for int")
        XCTAssertTrue(V.Between(1, and: 10)(5.6).0, "Between for valid double")
        XCTAssertFalse(V.Between(1.56, and: 10)(1.55).0, "Between for invalid double")
        XCTAssertTrue(V.Between(6.6, and: 10)(8.6).0, "Between for valid double")
        
        var range:Range? = V.Between(1, and: 10)("string").1!.rangeOfString(ValidationMessages.message(forKey: "Between"), options: nil, range: nil, locale: nil)
        XCTAssertTrue((range != nil), "Error message for Between")
    }
    
    func testGreater() {
        XCTAssertFalse(V.Greater(5)(nil).0, "Greater for nil")
        XCTAssertFalse(V.Greater(5)("value").0, "Greater for invalid type")
        XCTAssertFalse(V.Greater(5)(4).0, "Greater for smaller int")
        XCTAssertFalse(V.Greater(5)(4.5).0, "Greater for smaller double")
        XCTAssertFalse(V.Greater(5.1)(5.0).0, "Greater for smaller double")
        XCTAssertFalse(V.Greater(5.1)(5).0, "Greater for smaller double")
        XCTAssertFalse(V.Greater(5)(5).0, "Greater for equal int")
        XCTAssertFalse(V.Greater(5)(5.0).0, "Greater for equal int")
        
        XCTAssertTrue(V.Greater(5)(6).0, "Greater for bigger int")
        XCTAssertTrue(V.Greater(5.5)(5.6).0, "Greater for bigger double")


        var range:Range? = V.Greater(5)(nil).1!.rangeOfString(ValidationMessages.message(forKey: "Greater"), options: nil, range: nil, locale: nil)
        XCTAssertTrue((range != nil), "Error message for Greater")
    }

    func testGreaterOrEqual() {
        XCTAssertFalse(V.GreaterOrEqual(5)(nil).0, "Greater for nil")
        XCTAssertFalse(V.GreaterOrEqual(5)("value").0, "Greater for invalid type")
        XCTAssertFalse(V.GreaterOrEqual(5)(4).0, "Greater for smaller int")
        XCTAssertFalse(V.GreaterOrEqual(5)(4.5).0, "Greater for smaller double")
        XCTAssertFalse(V.GreaterOrEqual(5.1)(5.0).0, "Greater for smaller double")
        XCTAssertFalse(V.GreaterOrEqual(5.1)(5).0, "Greater for smaller double")
        XCTAssertTrue(V.GreaterOrEqual(5)(5).0, "Greater for equal int")
        XCTAssertTrue(V.GreaterOrEqual(5)(5.0).0, "Greater for equal int")
        
        XCTAssertTrue(V.GreaterOrEqual(5)(6).0, "Greater for bigger int")
        XCTAssertTrue(V.GreaterOrEqual(5.5)(5.6).0, "Greater for bigger double")
        
        
        var range:Range? = V.GreaterOrEqual(5)(nil).1!.rangeOfString(ValidationMessages.message(forKey: "GreaterOrEqual"), options: nil, range: nil, locale: nil)
        XCTAssertTrue((range != nil), "Error message for GreaterOrEqual")
    }

    func testLess() {
        XCTAssertFalse(V.Less(5)(nil).0, "Less for nil")
        XCTAssertFalse(V.Less(5)("value").0, "Less for invalid type")
        XCTAssertTrue(V.Less(5)(4).0, "Less for smaller int")
        XCTAssertTrue(V.Less(5)(4.5).0, "Less for smaller double")
        XCTAssertTrue(V.Less(5.1)(5.0).0, "Less for smaller double")
        XCTAssertTrue(V.Less(5.1)(5).0, "Less for smaller double")
        XCTAssertFalse(V.Less(5)(5).0, "Less for equal int")
        XCTAssertFalse(V.Less(5)(5.0).0, "Less for equal int")
        
        XCTAssertFalse(V.Less(5)(6).0, "Less for bigger int")
        XCTAssertFalse(V.Less(5.5)(5.6).0, "Less for bigger double")
        
        
        var range:Range? = V.Less(5)(nil).1!.rangeOfString(ValidationMessages.message(forKey: "Less"), options: nil, range: nil, locale: nil)
        XCTAssertTrue((range != nil), "Error message for Less")
    }

    func testLessOrEqual() {
        XCTAssertFalse(V.LessOrEqual(5)(nil).0, "Less for nil")
        XCTAssertFalse(V.LessOrEqual(5)("value").0, "Less for invalid type")
        XCTAssertTrue(V.LessOrEqual(5)(4).0, "Less for smaller int")
        XCTAssertTrue(V.LessOrEqual(5)(4.5).0, "Less for smaller double")
        XCTAssertTrue(V.LessOrEqual(5.1)(5.0).0, "Less for smaller double")
        XCTAssertTrue(V.LessOrEqual(5.1)(5).0, "Less for smaller double")
        XCTAssertTrue(V.LessOrEqual(5)(5).0, "Less for equal int")
        XCTAssertTrue(V.LessOrEqual(5)(5.0).0, "Less for equal int")
        
        XCTAssertFalse(V.LessOrEqual(5)(6).0, "Less for bigger int")
        XCTAssertFalse(V.LessOrEqual(5.5)(5.6).0, "Less for bigger double")
        
        
        var range:Range? = V.LessOrEqual(5)(nil).1!.rangeOfString(ValidationMessages.message(forKey: "LessOrEqual"), options: nil, range: nil, locale: nil)
        XCTAssertTrue((range != nil), "Error message for LessOrEqual")
    }
}
