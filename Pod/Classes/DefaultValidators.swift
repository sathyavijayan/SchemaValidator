//
//  Validators.swift
//  SchemaValidator
//
//  Created by Sathyavijayan Vittal on 04/06/2015.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import Foundation

/**
Validations Supported:

|----+-------------+------------------+-------------------------------|
| No | Function    | Description      | Works On                      |
|----+-------------+------------------+-------------------------------|
|  1 | Present     | Is Not Nil       | AnyObject                     |

|  2 | Not Empty   | Is Not Empty.    | (String, Array, HashMap, Set) |

|  3 | Equals      | Is Equal to.     | AnyObject                     |
|  4 | Integer     | Is an Integer    | AnyObject                     |
|  5 | Numeric     | Is Numeric       | AnyObject                     |

|  6 | IsOfSize    | Is Of size       | String,Array,HashMap,Set      |
|  7 | Between     | Is Between       | Number (Int, Float, Double)   |
|  8 | LessThan    | Is less than     | Numbers (Int, Float, Double)  |
|  9 | GreaterThan | Is greater than  | Numbers (Int, Float, Double)  |

| 10 | Email       | Is Email         | String                        |
| 11 | URL         | Is URL           | String                        |
| 12 | Regex       | Does match Regex | String                        |
|    |             |                  |                               |
*/

extension SchemaValidator {
    /**
    Checks if the object passed is nil
    
    @returns True if object is not nil, false otherwise.
    */
    public class func Present(obj: AnyObject?) -> (Bool, String?) {
        if let o:AnyObject = obj {
            return  (true, nil)
        } else {
            return  (false, SchemaValidator.messageProvider(forKey: "Present"))
        }
    }
    
    /**
    Checks if the object passed is not empty. Works with Strings, Set, Array and Dictionary.
    Fails validation for other types.
    
    @returns True if object is not empty, false otherwise.
    */
    public class func NotEmpty(obj: AnyObject?) -> (Bool, String?) {
        var isEmpty:Bool = false
        
        if let o:AnyObject = obj {
            switch o {
            case let str as String:
                isEmpty = str.isEmpty
            case let arr as [AnyObject]:
                isEmpty = arr.isEmpty
            case let set as Set<NSObject>:
                isEmpty = set.isEmpty
            case let dict as [NSObject:AnyObject]:
                isEmpty = dict.isEmpty
            default:
                isEmpty = false
            }
        } else {
            isEmpty = true
        }
        
        var result:(Bool,String?) = (!isEmpty, (!isEmpty) ? nil: SchemaValidator.messageProvider(forKey: "NotEmpty"))
        
        return result
    }
    

    private static let intTypes:[CFNumberType] = [
        CFNumberType.SInt8Type,
        CFNumberType.ShortType,
        CFNumberType.SInt16Type,
        CFNumberType.SInt32Type,
        CFNumberType.SInt64Type,
        CFNumberType.IntType,
        CFNumberType.ShortType,
        CFNumberType.LongLongType,
        CFNumberType.LongType
    ]
    /**
    Checks if the object passed is an Int
    
    @returns True if object is an Integer, false otherwise.
    */
    public class func Integer(obj:AnyObject?) -> (Bool, String?) {
        var isInt:Bool = false
        
        if let n:NSNumber = obj as? NSNumber {
            var numberType:CFNumberType = CFNumberGetType(n)
            isInt = contains(intTypes, numberType) ? true : false
        }
        
        return (isInt, (isInt) ? nil: SchemaValidator.messageProvider(forKey: "Integer"))
    }
    
    /**
    Checks if the object passed is numeric.
    
    @returns True if the object passed is a number, false otherwise
    */
    public class func Numeric(obj: AnyObject?) -> (Bool,String?) {
        if let n:NSNumber = (obj as? NSNumber) {
            return  (true, nil)
        } else {
            return (false, SchemaValidator.messageProvider(forKey: "Numeric"))
        }
    }
    
    /**
    Checks if the object is equal to the value passed.
    
    @returns True if the object is equal to value, false otherwise
    */
    public class func Equals(value: NSObject) -> (AnyObject?) -> (Bool, String?) {
        
        return {(obj:AnyObject?) -> (Bool,String?) in
            
            if let o:NSObject = (obj as? NSObject) {
                if o == value {
                    return (true, nil)
                }
            }
            var msg = SchemaValidator.messageProvider(forKey: "Equals")
            return  (false, "\(msg) \(value).")
        }
    }
    
    /**
    Checks if the object passed matches the Regular Expression.
    Note that this will work only for Strings. If the object is of
    a different type, the validation will just fail.
    
    @returns True if the object matches regex, false otherwise.
    */
    public class func Regex(regex: String, msg:String = " must match pattern") -> (AnyObject?) -> (Bool,String?) {
        return {(obj: AnyObject?) -> (Bool, String?) in
            if let o:NSString = (obj as? NSString) {
                return ((o.rangeOfString(regex, options: .RegularExpressionSearch).location != NSNotFound), nil)
            } else {
                return  (false, "\(msg) \(regex).")
            }
        }
    }
    
    /* TODO Regex Pattern for URL */
    private static let url_pattern = "^(?:(?:https?|ftp)://)?(?:\\S+(?::\\S*)?@)?(?:(?!10(?:\\.\\d{1,3}){3})(?!127(?:\\.\\d{1,3}){3})(?!169\\.254(?:\\.\\d{1,3}){2})(?!192\\.168(?:\\.\\d{1,3}){2})(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\x{00a1}-\\x{ffff}0-9]+-?)*[a-z\\x{00a1}-\\x{ffff}0-9]+)(?:\\.(?:[a-z\\x{00a1}-\\x{ffff}0-9]+-?)*[a-z\\x{00a1}-\\x{ffff}0-9]+)*(?:\\.(?:[a-z\\x{00a1}-\\x{ffff}]{2,}))?)(?::\\d{2,5})?(?:/[^\\s]*)?$"
    
    /**
    Checks if the object passed is an URL.
    Note that this will only work for Strings. If the object is of
    a different type, the validation will just fail.
    
    :returns: True if the object passed is an URL, false otherwise.
    */
    public class func URL(obj: AnyObject?) -> (Bool, String?) {
        var result = SchemaValidator.Regex(SchemaValidator.url_pattern)(obj)
        if result.0 {
            return (result.0, nil)
        } else {
            return (result.0, (SchemaValidator.messageProvider(forKey: "URL")))
        }
    }
    
    /* Regex Pattern for Email*/
    private static let email_pattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
    
    /**
    Checks if the object passed is an email.
    Note that this will work only for Strings. If the object is of
    a different type, the validation will just fail.
    
    :returns: True if the object passed is an Email, false otherwise.
    */
    public class func Email(obj: AnyObject?) -> (Bool, String?) {
        var result = SchemaValidator.Regex(SchemaValidator.email_pattern)(obj)
        if result.0 {
            return (result.0, nil)
        } else {
            return (result.0, SchemaValidator.messageProvider(forKey: "Email"))
        }
    }
    
    /**
    Checks if the object passed is of the given size. Works on String, Array, Set and Dictionary
    Fails validation for other types.
    
    @returns True if object is of given size, false otherwise.
    */
    public class func Size(size: Int) -> (AnyObject?) -> (Bool, String?) {
        
        return {(obj:AnyObject?) -> (Bool,String?) in
            
            var isOfSize:Bool = false
            
            if let o:AnyObject = obj  {
                switch o {
                case let str as String:
                    isOfSize = (count(str) == size) ? true: false
                case let arr as [AnyObject]:
                    isOfSize = (count(arr) == size) ? true: false
                case let set as Set<NSObject>:
                    isOfSize = (count(set) == size) ? true: false
                case let dict as [NSObject:AnyObject]:
                    isOfSize = (count(dict) == size) ? true: false
                default:
                    isOfSize = false
                }
            }
            
            var msg = SchemaValidator.messageProvider(forKey: "Size")
            var result:(Bool,String?) = (isOfSize, (!isOfSize) ? "\(msg) \(size)" : nil)
            
            return result
        }
    }

    /**
    Checks if the object passed is between the given numbers. Works on Numeric Types.
    Fails validation for other types.
    
    @returns True if object is between the given numbers, false otherwise.
    */
    public class func Between(start: NSNumber, and end: NSNumber) -> (AnyObject?) -> (Bool, String?) {
        
        return {(obj:AnyObject?) -> (Bool,String?) in
            
            var isBetween = false
            
            if let n:NSNumber = obj as? NSNumber {
                NSLog("%%%%%$$$$ \(n)   \(obj)")
                if (n >= start && n <= end) {
                    isBetween = true
                }
            }
            
            var message:String = SchemaValidator.messageProvider(forKey: "Between")
            
            var result:(Bool,String?) = (isBetween, (!isBetween) ?
                "\(message) \(start) & \(end)" : nil)
            
            return result
        }
    }
    

    /**
    Checks if the object passed is less than the    given number. Works on Numeric Types.
    Fails validation for other types.
    
    @returns True if object is less than the given number, false otherwise.
    */
    public class func Less(value: NSNumber) -> (AnyObject?) -> (Bool, String?) {
        
        return {(obj:AnyObject?) -> (Bool,String?) in
            
            var isLessThan:Bool = false
            
            if let n:NSNumber = obj as? NSNumber {
                isLessThan = (n < value) ? true : false
            }
            
            var message:String = SchemaValidator.messageProvider(forKey: "Less")

            var result:(Bool,String?) = (isLessThan, (!isLessThan) ?
                "\(message) \(value)" : nil)
            
            return result
        }
    }
    
    /**
    Checks if the object passed is less than or equal to the given number. Works on Numeric Types.
    Fails validation for other types.
    
    @returns True if object is less than or equal to the given number, false otherwise.
    */
    public class func LessOrEqual(value: NSNumber) -> (AnyObject?) -> (Bool, String?) {
        
        return {(obj:AnyObject?) -> (Bool,String?) in
            
            var isLessThanEqual:Bool = false
            
            if let n:NSNumber = obj as? NSNumber {
                isLessThanEqual = (n <= value) ? true : false
            }
            
            var message:String = SchemaValidator.messageProvider(forKey: "LessOrEqual")
            
            var result:(Bool,String?) = (isLessThanEqual, (!isLessThanEqual) ?
                "\(message) \(value)" : nil)
            
            return result
        }
    }

    /**
    Checks if the object passed is greater than the given number. Works on Numeric Types.
    Fails validation for other types.
    
    @returns True if object is greater than the given number, false otherwise.
    */
    public class func Greater(value: NSNumber) -> (AnyObject?) -> (Bool, String?) {
        
        return {(obj:AnyObject?) -> (Bool,String?) in
            
            var isGreaterThan:Bool = false
            
            if let n:NSNumber = obj as? NSNumber {
                isGreaterThan = (n > value) ? true : false
            }
            
            var message:String = SchemaValidator.messageProvider(forKey: "Greater")
            
            var result:(Bool,String?) = (isGreaterThan, (!isGreaterThan) ?
                "\(message) \(value)" : nil)
            
            return result
        }
    }

    /**
    Checks if the object passed is greater than the given number. Works on Numeric Types.
    Fails validation for other types.
    
    @returns True if object is greater than the given number, false otherwise.
    */
    public class func GreaterOrEqual(value: NSNumber) -> (AnyObject?) -> (Bool, String?) {
        
        return {(obj:AnyObject?) -> (Bool,String?) in
            
            var isGreaterThanOrEqual:Bool = false
            
            if let n:NSNumber = obj as? NSNumber {
                isGreaterThanOrEqual = (n >= value) ? true : false
            }
            
            var message:String = SchemaValidator.messageProvider(forKey: "GreaterOrEqual")
            
            var result:(Bool,String?) = (isGreaterThanOrEqual, (!isGreaterThanOrEqual) ?
                "\(message) \(value)" : nil)
            
            return result
        }
    }

}