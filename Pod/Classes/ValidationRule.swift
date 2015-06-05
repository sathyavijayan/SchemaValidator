//
//  ValidationRule.swift
//  SchemaValidator
//
//  Created by Sathyavijayan Vittal on 04/06/2015.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import Foundation


public enum ValidationRuleType :Int{
    case Array
    case Dictionary
    case Unknown
    case Validator
    case Null
    case Error
}

public class ValidationRule: Swift.ArrayLiteralConvertible, Swift.DictionaryLiteralConvertible {
    
    /// Private object
    private var _object: Any?
    
    /// Private type
    private var _type: ValidationRuleType = .Null
    
    private var _error: NSError?
    
    public required init(object: Any?) {
        self.object = object
    }
    
    public required convenience init(arrayLiteral elements: Validator...) {
        self.init(object: elements)
    }
    
    public required convenience init(dictionaryLiteral elements: (String, ValidationRule)...) {
        var dict: [String: ValidationRule] = [:]
        for t in elements {
            dict[t.0] = t.1
        }
        self.init(object: dict)
    }
    
    public required convenience init(_ validator: Validator) {
        self.init(object: validator)
    }
    
    /// Object in JSON
    public var object: Any? {
        get {
            return _object
        }
        set {
            _object = newValue
            switch newValue {
            case let validator as Validator:
                _type = .Validator
            case let array as [Validator]:
                _type = .Array
            case let dictionary as [String : ValidationRule]:
                _type = .Dictionary
            default:
                _type = .Unknown
                _object = NSNull()
                _error = NSError(domain: SchemaValidatorErrorDomain, code: 1, userInfo: [NSLocalizedDescriptionKey: "It is a unsupported type"])
            }
        }
    }
    
    public func type() -> ValidationRuleType {
        return _type
    }
}
