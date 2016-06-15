//
//  AKPFlowLayoutAttributes.swift
//  AKPFlowLayout
//
//  Created by Arseniy on 14/6/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

public class AKPFlowLayoutAttributes: UICollectionViewLayoutAttributes {
    
    public var stretchFactor: CGFloat = 0
    
    public override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! AKPFlowLayoutAttributes
        copy.stretchFactor = stretchFactor
        return copy
    }
    
    public override func isEqual(object: AnyObject?) -> Bool {
        if let attributes = object as? AKPFlowLayoutAttributes {
            if attributes.stretchFactor == stretchFactor {
                return super.isEqual(object)
            }
        }
        return false
    }
    
}