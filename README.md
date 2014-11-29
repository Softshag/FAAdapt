# FAAdapt

[![CI Status](http://img.shields.io/travis/Rasmus Kildevæld/FAAdapt.svg?style=flat)](https://travis-ci.org/Rasmus Kildevæld/FAAdapt)
[![Version](https://img.shields.io/cocoapods/v/FAAdapt.svg?style=flat)](http://cocoadocs.org/docsets/FAAdapt)
[![License](https://img.shields.io/cocoapods/l/FAAdapt.svg?style=flat)](http://cocoadocs.org/docsets/FAAdapt)
[![Platform](https://img.shields.io/cocoapods/p/FAAdapt.svg?style=flat)](http://cocoadocs.org/docsets/FAAdapt)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

FAAdapt is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "FAAdapt"

## Example 
A model:

```objective-c

@interface Blog : NSObject 

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSSet *comments;

@end

```

The object to map

```objective-c

NSDictionary *dict = @{
    @"t": @"title",
    @"b": @"body"
};

```

## Author

Rasmus Kildevæld, admin@softshag.dk

## License

FAAdapt is available under the MIT license. See the LICENSE file for more info.

