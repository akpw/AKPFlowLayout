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
            let akpFlowLayout: AKPCollectionViewFlowLayout = {
                return $0
            }( AKPCollectionViewFlowLayout() )
            
            it("has all layout config options on by default") {
                expect(akpFlowLayout.layoutOptions.contains(.FirstSectionIsGlobalHeader)).to(beTrue())
                expect(akpFlowLayout.layoutOptions.contains(.FirstSectionStretchable)).to(beTrue())
                expect(akpFlowLayout.layoutOptions.contains(.SectionsPinToGlobalHeaderOrVisibleBounds)).to(beTrue())
            }
            
            it("replaces built-in sectionHeadersPinToVisibleBounds") {
                akpFlowLayout.sectionHeadersPinToVisibleBounds = true
                expect(akpFlowLayout.sectionHeadersPinToVisibleBounds).to(beFalse())
            }
        }
    }
}
