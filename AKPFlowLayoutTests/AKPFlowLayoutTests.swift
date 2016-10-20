//
//  AKPFlowLayoutTests.swift
//  AKPFlowLayoutTests
//
//  Created by Arseniy on 12/6/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import Quick
import Nimble
import AKPFlowLayout

class AKPFlowLayoutTests: QuickSpec {
    override func spec() {
        describe("AKPFlowLayout") {
            let akpFlowLayout: AKPFlowLayout = {
                $0.firsSectionMaximumStretchHeight = 200
                return $0
            }( AKPFlowLayout() )
            
            it("uses AKPFlowLayoutAttributes when creating layout attributes") {
                print(AKPFlowLayout.layoutAttributesClass)
                expect(AKPFlowLayout.layoutAttributesClass == AKPFlowLayoutAttributes.self).to(beTrue())
            }
            
            it("has all layout config options on by default") {
                expect(akpFlowLayout.layoutOptions.contains(.firstSectionIsGlobalHeader)).to(beTrue())
                expect(akpFlowLayout.layoutOptions.contains(.firstSectionStretchable)).to(beTrue())
                expect(akpFlowLayout.layoutOptions.contains(.sectionsPinToGlobalHeaderOrVisibleBounds)).to(beTrue())
            }
            
            it("when running on iSO9, it disables built-in sectionHeadersPinToVisibleBounds") {
                if #available(iOS 9.0, *) {
                    akpFlowLayout.sectionHeadersPinToVisibleBounds = false
                    expect(akpFlowLayout.sectionHeadersPinToVisibleBounds).to(beFalse())

                    akpFlowLayout.sectionHeadersPinToVisibleBounds = true
                    expect(akpFlowLayout.sectionHeadersPinToVisibleBounds).to(beFalse())
                }
            }
            
            it("has given firsSectionMaximumStretchHeight value") {
                expect(akpFlowLayout.firsSectionMaximumStretchHeight == 200).to(beTrue())
            }
            
        }
    }
}
