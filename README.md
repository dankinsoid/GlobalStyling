# GlobalStyling

[![CI Status](https://img.shields.io/travis/dankinsoid/GlobalStyling.svg?style=flat)](https://travis-ci.org/dankinsoid/GlobalStyling)
[![Version](https://img.shields.io/cocoapods/v/GlobalStyling.svg?style=flat)](https://cocoapods.org/pods/GlobalStyling)
[![License](https://img.shields.io/cocoapods/l/GlobalStyling.svg?style=flat)](https://cocoapods.org/pods/GlobalStyling)
[![Platform](https://img.shields.io/cocoapods/p/GlobalStyling.svg?style=flat)](https://cocoapods.org/pods/GlobalStyling)


## Description
This repository provides

## Example

```swift

```
## Usage

 
## Installation

1. [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.
```swift
// swift-tools-version:5.7
import PackageDescription

let package = Package(
  name: "SomeProject",
  dependencies: [
    .package(url: "https://github.com/dankinsoid/GlobalStyling.git", from: "0.0.1")
  ],
  targets: [
    .target(name: "SomeProject", dependencies: ["GlobalStyling"])
  ]
)
```
```ruby
$ swift build
```

2.  [CocoaPods](https://cocoapods.org)

Add the following line to your Podfile:
```ruby
pod 'GlobalStyling'
```
and run `pod update` from the podfile directory first.

## Author

dankinsoid, voidilov@gmail.com

## License

GlobalStyling is available under the MIT license. See the LICENSE file for more info.
