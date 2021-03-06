//
//  TestSchemaValidator.swift
//  SchemaValidator
//
//  Created by Sathyavijayan Vittal on 05/06/2015.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import XCTest

class TestSchemaValidator: XCTestCase {
    
    typealias V = SchemaValidator
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
    TODO: Add more tests.
    */
    
    func testValidate() {
        
        let schema:Schema = [
            "timestamp": [V.Present, V.Integer],
            "sourceId" : [V.Present],
            "userInfo" : [
                "email" : [V.Email],
                "age"   : [V.GreaterOrEqual(18)],
                "ni_number": [V.Size(6)]
            ],
            "devices": [
                "UDID": [V.Present]
            ]
        ]
        
        var user:[String:AnyObject] = [
            "timestamp": 123123,
            "sourceId" : "XDUUSD-1",
            "userInfo" : [
                "email": "sathya@icloud.com",
                "age"  : 17,
                "ni_number": "ABCDEF"
            ],
            "devices": [
                ["name": "iPhone", "UDID": "YYY"],
                ["name": "iPad", "UDID": "XYX"]
            ]
        ]
        
        var err:NSError? = V.validate(schema, object: user)
        XCTAssertNotNil(err, "Validation should fail for incorrect object")
        
        var userInfo = user["userInfo"] as! [String:AnyObject]
        userInfo["age"] = 18
        user["userInfo"] = userInfo
        var err1:NSError? = V.validate(schema, object: user)
        XCTAssertNil(err1, "Validation should succeed for correct object")
    }
    
    func testMessages() {
        SchemaValidator.messageProvider = {(forKey:String) -> String in
            return "Error"
        }
        
        XCTAssertEqual(V.Equals(5)(6).1!, "Error 5.", "Replacing messageProvider should replace the error message")
    }
}
