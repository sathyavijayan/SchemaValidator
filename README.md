# SchemaValidator

[![CI Status](http://img.shields.io/travis/Sathyavijayan Vittal/SchemaValidator.svg?style=flat)](https://travis-ci.org/Sathyavijayan Vittal/SchemaValidator)
[![Version](https://img.shields.io/cocoapods/v/SchemaValidator.svg?style=flat)](http://cocoapods.org/pods/SchemaValidator)
[![License](https://img.shields.io/cocoapods/l/SchemaValidator.svg?style=flat)](http://cocoapods.org/pods/SchemaValidator)
[![Platform](https://img.shields.io/cocoapods/p/SchemaValidator.svg?style=flat)](http://cocoapods.org/pods/SchemaValidator)

## Requirements

## Installation

SchemaValidator is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```swift
pod "SchemaValidator"
```

## Usage

You can use SchemaValidator to validate JSON like dictionary objects (for eg: anything that conforms to [NSObject:AnyObject] in Swift. 

To define a Schema do:

```swift
let schema:Schema = [
    "timestamp": [V.Present, V.Integer],
    "sourceId" : [V.Present],
    "userInfo" : [
    "email" : [V.Email],
    "age"   : [V.GreaterOrEqual(18)],
    "ni_number": [V.Size(6)]
    ]]
```
To validate an object against a schema do:

```swift
var user:[String:AnyObject] = [
    "timestamp": 123123,
    "sourceId" : "XDUUSD-1",
    "userInfo" : [
        "email": "sathya@icloud.com",
        "age"  : 17,
        "ni_number": "ABCDEF"],
    "devices": [
        ["name": "iPhone"],
        ["name": "iPad", "UDID": "XYX"]
    ]]

var err:NSError? = V.validate(schema, object: user)
```

The userInfo field within NSError contains a Dictionary that contains errors for all the fields that failed validation. If the value of the field itself is an array, the labels are postfixed with a .x (eg: devices.0).

## Author

Sathyavijayan Vittal, sathyavijayan@gmail.com

## License

SchemaValidator is available under the MIT license. See the LICENSE file for more info.
