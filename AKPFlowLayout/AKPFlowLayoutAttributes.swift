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
    
    /// Set by AKPFlowLayout when managing section heades stretching
    /// Typically used for reporting amount of stretch back to the collection view items
    public var stretchFactor: CGFloat = 0
    
    override public func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! AKPFlowLayoutAttributes
        copy.stretchFactor = stretchFactor
        return copy
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