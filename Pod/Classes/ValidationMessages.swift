//
//  ValidationMessages.swift
//  SchemaValidator
//
//  Created by Sathyavijayan Vittal on 04/06/2015.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import Foundation

public class ValidationMessages {
    /**
    Note that the design for error messages will be changed
    in future versions.
    */
    public static let messages:[String:String] = [
        "Present": "is required.",
        "Integer": "must be an Integer.",
        "Equals" : "is not equal to",
        "Numeric": "must be a number",
        "Regex":"must match pattern ",
        "URL" : "must be an URL.",
        "Email": "must be an Email.",
        "Size": "must be of size",
        "Between": "must be between",
        "Less": "must be less than",
        "LessOrEqual": "must be less than or equal to",
        "Greater": "must be greater than",
        "GreaterOrEqual": "must be greater than or equal to"]
    
    /**
    Returns Error Message for Key.
    :returns: Error Message for a given key.
    */
    public class func message(forKey key: String) -> String {
        if let msg = ValidationMessages.messages[key] {
            return msg
        }
        return "Error"
    }
    
}
