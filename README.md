AKPFlowLayout
============

![Language](https://img.shields.io/badge/language-Swift%202-orange.svg)
![License](https://img.shields.io/badge/License-MIT%20License-blue.svg)



AKPFlowLayout is a custom Collection View layout with configurable global header and pinnable, stretchable sections.


## Blogs
* [Custom UICollectionView: Global Headers](http://www.akpdev.com/articles/2016/06/16/CollectionView-I.html)


## Sample App
* [SwiftNetworkImages](https://github.com/akpw/SwiftNetworkImages)


## Features

* A custom `UICollectionViewFlowLayout`-based layout with support for:
 - Global section headers
 - Sticky section headers 
 - Pinnable, stretchable sections

* Fully configurable

* Built for performace, using custom invalidation context

* Written in Swift 3 and Xcode 8

## Requirements
* iOS 8+
* Xcode 8
* Swift 3

## Installation

#### [CocoaPods](http://cocoapods.org) (recommended)

````sh
use_frameworks!
pod 'AKPFlowLayout', :git => 'https://github.com/akpw/AKPFlowLayout'
````
The explicit `:git` path above is due to the current [CocoaPods issue](https://github.com/CocoaPods/CocoaPods/issues/5663)


#### [Carthage](https://github.com/Carthage/Carthage)
1. Add AKPFlowLayout to your [`Cartfile`](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):
    ```
    github "akpw/AKPFlowLayout"
    ```
2. Follow the [Carthage instructions on adding frameworks](https://github.com/Carthage/Carthage/blob/master/README.md#adding-frameworks-to-an-application) for further reference


## Docs		
 [Initial docs][docsLink], generated with [jazzy](https://github.com/realm/jazzy) and hosted by [GitHub Pages](https://pages.github.com).


## Building the project

1) Clone the repository

```bash
$ git clone https://github.com/akpw/AKPFlowLayout
```

2) Run carthage.sh

```bash
$ cd AKPFlowLayout
$ ./carthage.sh
```

3) Open the workspace in Xcode

```bash
$ open "AKPFlowLayout.xcworkspace"
```

4) Compile and test in Xcode




[docsLink]:https://akpw.github.io//AKPFlowLayout/index.html




