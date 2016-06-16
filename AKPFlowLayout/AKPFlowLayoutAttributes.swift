//
//  AKPFlowLayoutAttributes.swift
//  AKPFlowLayout
//
//  Created by Arseniy on 14/6/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

/// Layout Attributes class for AKPFlowLayout

public class AKPFlowLayoutAttributes: UICollectionViewLayoutAttributes {
    
    /// Set by AKPFlowLayout when managing section headers stretching
    /// Can be used further for e.g. reporting amount of stretch back to the collection view items
    public var stretchFactor: CGFloat = 0
    
    override public func copyWithZone(zone: NSZone) -> AnyObject {
        let aCopy = super.copyWithZone(zone) as! AKPFlowLayoutAttributes
        aCopy.stretchFactor = stretchFactor
        return aCopy
    }
    
    override public func isEqual(object: AnyObject?) -> Bool {
        if let attributes = object as? AKPFlowLayoutAttributes {
            if attributes.stretchFactor == stretchFactor {
                return super.isEqual(object)
            }
        }
        return false
    }
}