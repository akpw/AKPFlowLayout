//
//  AKPLayoutConfigOptions.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 9/6/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import Foundation

/// AKPFlowLayout configuration options

public struct AKPLayoutConfigOptions: OptionSet {
    public static let firstSectionIsGlobalHeader =
                                AKPLayoutConfigOptions(rawValue: 1 << 0)
    public static let firstSectionStretchable =
                                AKPLayoutConfigOptions(rawValue: 1 << 1)
    public static let sectionsPinToGlobalHeaderOrVisibleBounds =
                                AKPLayoutConfigOptions(rawValue: 1 << 2)
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension AKPLayoutConfigOptions: CustomStringConvertible {
    public var descriptions: [String] {
        let optionsDescriptions = ["First Section Is Global Header",
                                   "First Section Stretchable",
                                   "Sections Pin To Global Header Or Visible Bounds"]
        var memberDescriptions = [String]()
        for (shift, description) in optionsDescriptions.enumerated()
                    where contains( AKPLayoutConfigOptions( rawValue: 1 << shift) ) {
            memberDescriptions.append(description)
        }
        return memberDescriptions
    }
    
    public var description: String {
        return descriptions.description
    }
}
