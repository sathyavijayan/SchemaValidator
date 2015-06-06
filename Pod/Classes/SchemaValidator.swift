//
//  SchemaValidator.swift
//  SchemaValidator
//
//  Created by Sathyavijayan Vittal on 04/06/2015.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import Foundation

/**
Validators should follow the signature (AnyObject?) -> (Bool,String?) in order to be used in the SchemaValidator.

The Bool parameter in the tuple indicates whether the validation passed. 
The Optional String paramter contains the error message.
*/
public typealias Validator = (AnyObject?) -> (Bool, String?)

/**
The schema is a Dictionary of type [String:ValidationRule]

The ValidationRule can be an array of Validators, or another Dictionary of type [String:ValidationRule].
The former will apply for fields and the latter to validate child objects.
*/
public typealias Schema = [String:ValidationRule]

public let SchemaValidatorErrorDomain = "SchemaValidator"

/**

Utility to validate Dictionaries, specifically JSON like objects using a Schema. 
*/
public class SchemaValidator {
    
    public static var messageProvider:(forKey: String) -> String = ValidationMessages.message
            
    class func applyValidators(obj: AnyObject?, validators: [Validator]) -> [String]? {
        
        var errors:[String] = []
        
        for validator in validators {
            var result = validator(obj)
            
            if !result.0 {
                if let err = result.1 {
                    errors.append(err)
                } else {
                    errors.append("Unknown Error!")
                }
            }
        }
        
        if errors.count > 0 {
            return errors
        } else {
            return nil
        }
    }
    
    
    class func validateObject(schema: Schema, object: [String:AnyObject]) -> [String: AnyObject]? {
        var errors:[String:AnyObject] = [:]
        
        for (k,v) in schema {
            //v.type() could be:
            //a. Array[Validator]
            //b. Dictionary[String:VRule]
            switch(v.type()) {
            case .Array:
                if let errs = SchemaValidator.applyValidators(object[k], validators: v.object as! [Validator]) {
                    errors[k] = errs
                }
            case .Dictionary:
                if let subObject = object[k] as? [String:AnyObject] {
                    if let errs = validateObject(v.object as! Schema, object: subObject) {
                        errors[k] = errs
                    }
                } else if let subObjects = object[k] as? [[String:AnyObject]]{
                    for (index, subObject) in enumerate(subObjects) {
                        var key = "\(k).\(index)"
                        if let errs = validateObject(v.object as! Schema, object: subObject) {
                            errors[key] = errs
                        }
                    }
                } else {
                    //Err !
                    errors[k] = ["Unable to validate value for \(k). Should be an Object or Array of Objects."]
                    
                }
            default:
                errors[k] = ["Invalid Type in schema for \(k)."]
                
            }
        }
        
        return (errors.isEmpty) ? nil : errors
    }
    
    
    public class func validate(schema: Schema, object: [String:AnyObject]) -> NSError? {
        if let error = validateObject(schema, object: object) {
            return NSError(domain: SchemaValidatorErrorDomain, code: 0, userInfo: error)
        }
        
        return nil
    }
}
