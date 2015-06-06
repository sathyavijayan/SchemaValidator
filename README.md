# SchemaValidator

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
        "ni_number": [V.Size(6)],
    "devices": [
        "UDID": [V.Present]
    ]]]
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

```javascript
//println(err?.userInfo) will result in the following:
[devices.0: {
    UDID = ("is required.");
}, userInfo: {
    age = ("must be greater than or equal to 18");
}]
```

## Extensions

You can add your own validators to extend SchemaValidator. All you need to do is to make sure your validator conforms to (AnyObject?) -> (Bool,String?).

The optional param AnyObject? is the value for the key being validated.
The object returned should be a tuple containing a Bool that specifies whether validation failed (false) or passed (true) and an optional error message. Do make sure that you return a legible error message when the validation fails.

## Custom Error Messages

If you wish to override the default error messages, you can do so by setting SchemaValidator.messageProvider with a closure that conforms to (forKey:String) -> String. 

``` Support for error messages are very basic at the moment. Im working on making this better. Expect an update soon. ``` 

## Contributions

Contributions to this library will be greatly appreciated. If you write a validator that you think will be useful to others, please contribute via pull request. 

All I ask is for you to provide your validators as an extension to SchemaValidator. (see: DefaultValidators.swift)


## Author

Sathyavijayan Vittal, sathyavijayan@gmail.com

## License

SchemaValidator is available under the MIT license. See the LICENSE file for more info.
