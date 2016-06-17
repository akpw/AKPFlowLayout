//
//  AKPFlowLayout.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 18/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

/**
 Global / Sticky / Stretchy Headers using UICollectionViewFlowLayout.
 Works for iOS8 and above.
 */

public final class AKPFlowLayout: UICollectionViewFlowLayout {
    /// Layout configuration options
    public var layoutOptions: AKPLayoutConfigOptions = [.FirstSectionIsGlobalHeader,
                                                        .FirstSectionStretchable,
                                                        .SectionsPinToGlobalHeaderOrVisibleBounds]
    /// For stretchy headers, allowis limiting amount of stretch
    public var firsSectionMaximumStretchHeight = CGFloat.max
    
    // MARK: - Initialization
    override public init() {
        super.init()
        // For iOS9, needs to ensure the impl does not interfere with `sectionHeadersPinToVisibleBounds`
        // Seems to be no reasonable way yet to use Swift property observers with conditional compilation, 
        // so falling back to KVO
        if #available(iOS 9.0, *) {
            addObserver(self, forKeyPath: "sectionHeadersPinToVisibleBounds",
                                                    options: .New, context: &AKPFlowLayoutKVOContext)
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    deinit {
        if #available(iOS 9.0, *) {
            removeObserver(self, forKeyPath: "sectionHeadersPinToVisibleBounds", context: &AKPFlowLayoutKVOContext)
        }
    }

    // MARK: - 📐Custom Layout
    /// - returns:  AKPFlowLayoutAttributes class for handling layout attributes
    override public class func layoutAttributesClass() -> AnyClass {
        return AKPFlowLayoutAttributes.self
    }

    /// Returns layout attributes for specified rectangle, with added custom headers
    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard shouldDoCustomLayout else { return super.layoutAttributesForElementsInRect(rect) }
        
        guard var layoutAttributes = super.layoutAttributesForElementsInRect(rect) as? [AKPFlowLayoutAttributes],
              // calculate custom headers that should be confined in the rect
              let customSectionHeadersIdxs = customSectionHeadersIdxs(rect) else { return nil }
        
        // add the custom headers to the regular UICollectionViewFlowLayout layoutAttributes
        for idx in customSectionHeadersIdxs {
            let indexPath = NSIndexPath(forItem: 0, inSection: idx)
            if let attributes = super.layoutAttributesForSupplementaryViewOfKind(
                                                    UICollectionElementKindSectionHeader,
                                                    atIndexPath: indexPath) as? AKPFlowLayoutAttributes {
                layoutAttributes.append(attributes)
            }
        }
        // for section headers, need to adjust their attributes
        for attributes in layoutAttributes where
            attributes.representedElementKind == UICollectionElementKindSectionHeader {
                (attributes.frame, attributes.zIndex) = adjustLayoutAttributes(forSectionAttributes: attributes)
        }
        return layoutAttributes
    }
    
    /// Adjusts layout attributes for the custom section headers
    override public func layoutAttributesForSupplementaryViewOfKind(elementKind: String,
                                                             atIndexPath indexPath: NSIndexPath)
                                                                    -> UICollectionViewLayoutAttributes? {
        guard shouldDoCustomLayout else {
            return super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath) }
        
        guard let sectionHeaderAttributes = super.layoutAttributesForSupplementaryViewOfKind(
                                                            elementKind,
                                                            atIndexPath: indexPath)
                                                            as? AKPFlowLayoutAttributes else { return nil }
        // Adjust section attributes
        (sectionHeaderAttributes.frame, sectionHeaderAttributes.zIndex) =
                                        adjustLayoutAttributes(forSectionAttributes: sectionHeaderAttributes)
        return sectionHeaderAttributes
    }
    
    // MARK: - 🎳Invalidation
    /// - returns: `true`, unless running on iOS9 with `sectionHeadersPinToVisibleBounds` set to `true`
    override public func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        guard shouldDoCustomLayout else { return super.shouldInvalidateLayoutForBoundsChange(newBounds) }
        return true
    }
    
    /// Custom invalidation
    override public func invalidationContextForBoundsChange(newBounds: CGRect)
                                        -> UICollectionViewLayoutInvalidationContext {
        guard shouldDoCustomLayout,
              let invalidationContext = super.invalidationContextForBoundsChange(newBounds)
                                                as? UICollectionViewFlowLayoutInvalidationContext,
              let oldBounds = collectionView?.bounds
                                                else { return super.invalidationContextForBoundsChange(newBounds) }
        // Size changes?
        if oldBounds.size != newBounds.size {
            // re-query the collection view delegate for metrics such as size information etc.
            invalidationContext.invalidateFlowLayoutDelegateMetrics = true
        }
        
        // Origin changes?
        if oldBounds.origin != newBounds.origin {
            // find and invalidate sections that would fall into the new bounds
            guard let sectionIdxPaths = sectionsHeadersIDxs(forRect: newBounds) else {return invalidationContext}
            
            // then invalidate
            let invalidatedIdxPaths = sectionIdxPaths.map { NSIndexPath(forItem: 0, inSection: $0) }
            invalidationContext.invalidateSupplementaryElementsOfKind(
                UICollectionElementKindSectionHeader, atIndexPaths: invalidatedIdxPaths )
        }
        return invalidationContext
    }
    private var previousStretchFactor = CGFloat(0)
}

// MARK: - 🕶Private Helpers
extension AKPFlowLayout {
    private var shouldDoCustomLayout: Bool {
        var requestForCustomLayout = layoutOptions.contains(.FirstSectionIsGlobalHeader) ||
                                     layoutOptions.contains(.FirstSectionStretchable) ||
                                     layoutOptions.contains(.SectionsPinToGlobalHeaderOrVisibleBounds)        
        // iOS9 supports sticky headers natively, so we should not
        // interfere with the the built-in functionality
        if #available(iOS 9.0, *) {
            requestForCustomLayout = requestForCustomLayout && !sectionHeadersPinToVisibleBounds
        }
        return requestForCustomLayout
    }

    private func zIndexForSection(section: Int) -> Int {
        return section > 0 ? 128 : 256
    }
    
    // Given a rect, calculates indexes of all confined section headers
    // _including_ the custom headers
    private func sectionsHeadersIDxs(forRect rect: CGRect) -> Set<Int>? {
        guard let layoutAttributes = super.layoutAttributesForElementsInRect(rect)
                                                    as? [AKPFlowLayoutAttributes] else {return nil}
        let sectionsShouldPin = layoutOptions.contains(.SectionsPinToGlobalHeaderOrVisibleBounds)
        
        var headersIdxs = Set<Int>()
        for attributes in layoutAttributes
                where attributes.visibleSectionHeader(sectionsShouldPin) {
            headersIdxs.insert(attributes.indexPath.section)
        }
        if layoutOptions.contains(.FirstSectionIsGlobalHeader) {
            headersIdxs.insert(0)
        }
        return headersIdxs
    }
    
    // Given a rect, calculates the indexes of confined custom section headers
    // _excluding_ the regular headers handled by UICollectionViewFlowLayout
    private func customSectionHeadersIdxs(rect: CGRect) -> Set<Int>? {
        guard let layoutAttributes = super.layoutAttributesForElementsInRect(rect),
              var sectionIdxs = sectionsHeadersIDxs(forRect: rect)  else {return nil}
        
        // remove the sections that should already be taken care of by UICollectionViewFlowLayout
        for attributes in layoutAttributes
            where attributes.representedElementKind == UICollectionElementKindSectionHeader {
                sectionIdxs.remove(attributes.indexPath.section)
        }
        return sectionIdxs
    }
    
    // Adjusts layout attributes of section headers
    private func adjustLayoutAttributes(forSectionAttributes
                                            sectionHeadersLayoutAttributes: AKPFlowLayoutAttributes)
                                                                                             -> (CGRect, Int) {
        guard let collectionView = collectionView else { return (CGRect.zero, 0) }
        let section = sectionHeadersLayoutAttributes.indexPath.section
        var sectionFrame = sectionHeadersLayoutAttributes.frame

        // 1. Establish the section boundaries:
        let (minY, maxY) = boundaryMetrics(forSectionAttributes: sectionHeadersLayoutAttributes)
        
        // 2. Determine the height and insets of the first section,
        //    in case it's stretchable or serves as a global header
        let (firstSectionHeight, firstSectionInsets) = firstSectionMetrics()
                                                                                                
        // 3. If within the above boundaries, the section should follow content offset
        //   (adjusting a few more things along the way)
        var offset = collectionView.contentOffset.y + collectionView.contentInset.top
        if (section > 0) {
            // The global section
            if layoutOptions.contains(.SectionsPinToGlobalHeaderOrVisibleBounds) {
                if layoutOptions.contains(.FirstSectionIsGlobalHeader) {
                    // A global header adjustment
                    offset += firstSectionHeight + firstSectionInsets.top
                }
                sectionFrame.origin.y = min(max(offset, minY), maxY)
            }
        } else {
            if layoutOptions.contains(.FirstSectionStretchable) && offset < 0 {
                // Stretchy header
                if firstSectionHeight - offset < firsSectionMaximumStretchHeight {
                    sectionFrame.size.height = firstSectionHeight - offset
                    sectionHeadersLayoutAttributes.stretchFactor = fabs(offset)
                    previousStretchFactor = sectionHeadersLayoutAttributes.stretchFactor
                } else {
                    // need to limit the stretch
                    sectionFrame.size.height = firsSectionMaximumStretchHeight
                    sectionHeadersLayoutAttributes.stretchFactor = previousStretchFactor
                }
                sectionFrame.origin.y += offset + firstSectionInsets.top
            } else if layoutOptions.contains(.FirstSectionIsGlobalHeader) {
                // Sticky header position needs to be relative to the global header
                sectionFrame.origin.y += offset + firstSectionInsets.top
            } else {
                sectionFrame.origin.y = min(max(offset, minY), maxY)
            }
        }
        return (sectionFrame, zIndexForSection(section))
    }
    
    private func boundaryMetrics(
                    forSectionAttributes sectionHeadersLayoutAttributes: UICollectionViewLayoutAttributes)
                                                                                        -> (CGFloat, CGFloat) {
            // get attributes for first and last items in section
            guard let collectionView = collectionView  else { return (0, 0) }
            let section = sectionHeadersLayoutAttributes.indexPath.section
            
            // Trying to use layoutAttributesForItemAtIndexPath for empty section would
            // cause EXC_ARITHMETIC in simulator (division by zero items)
            let lastInSectionIdx = collectionView.numberOfItemsInSection(section) - 1
            if lastInSectionIdx < 0 { return (0, 0) }
                                                                                            
            guard let attributesForFirstItemInSection = layoutAttributesForItemAtIndexPath(
                                            NSIndexPath(forItem: 0, inSection: section)),
                let attributesForLastItemInSection = layoutAttributesForItemAtIndexPath(
                                            NSIndexPath(forItem: lastInSectionIdx, inSection: section))
                else {return (0, 0)}
            let sectionFrame = sectionHeadersLayoutAttributes.frame
            
            // Section Boundaries:
            //   The section should not be higher than the top of its first cell
            let minY = attributesForFirstItemInSection.frame.minY - sectionFrame.height
            //   The section should not be lower than the bottom of its last cell
            let maxY = attributesForLastItemInSection.frame.maxY - sectionFrame.height
            return (minY, maxY)
    }
    
    private func firstSectionMetrics() -> (height: CGFloat, insets: UIEdgeInsets) {
        guard let collectionView = collectionView else { return (0, UIEdgeInsetsZero) }
        // height of the first section
        var firstSectionHeight = headerReferenceSize.height
        if let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout
                                                            where firstSectionHeight == 0 {
            firstSectionHeight = delegate.collectionView!(collectionView,
                                                          layout: self,
                                                          referenceSizeForHeaderInSection: 0).height
        }
        // insets of the first section
        var theSectionInset = sectionInset
        if let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout
                                                            where theSectionInset == UIEdgeInsetsZero {
            theSectionInset = delegate.collectionView!(collectionView,
                                                       layout: self,
                                                       insetForSectionAtIndex: 0)
        }
        return (firstSectionHeight, theSectionInset)
    }
}

// MARK: - KVO check for `sectionHeadersPinToVisibleBounds`
extension AKPFlowLayout {
     /// KVO check for `sectionHeadersPinToVisibleBounds`.
     /// For iOS9, needs to ensure the impl does not interfere with `sectionHeadersPinToVisibleBounds`
     override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?,
                                                change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &AKPFlowLayoutKVOContext {
            if let newValue = change?[NSKeyValueChangeNewKey],
                boolValue = newValue as? Bool where boolValue {
                print("AKPFlowLayout supports sticky headers by default, therefore " +
                    "the built-in functionality via sectionHeadersPinToVisibleBounds has been disabled")
                if #available(iOS 9.0, *) { sectionHeadersPinToVisibleBounds = false }
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}


private extension AKPFlowLayoutAttributes {
    // Determines if element is a section, or is a cell in a section with custom header
    func visibleSectionHeader(sectionsShouldPin: Bool) -> Bool {
        let isHeader = representedElementKind == UICollectionElementKindSectionHeader
        let isCellInPinnedSection = sectionsShouldPin && ( representedElementCategory == .Cell )
        return isCellInPinnedSection || isHeader
    }
}

private var AKPFlowLayoutKVOContext = 0












