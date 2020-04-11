//
//  RichTextLayoutManager.swift
//  RichText
//
//  Created by Alexey Rogatkin on 28/02/2020.
//  Copyright © 2020 Alexey Rogatkin. All rights reserved.
//

import Foundation
import UIKit


final class RichTextLayoutManager : NSLayoutManager {
    
    weak var view : RichTextView?
    
    override func invalidateGlyphs(forCharacterRange charRange: NSRange, changeInLength delta: Int, actualCharacterRange actualCharRange: NSRangePointer?) {
        super.invalidateGlyphs(forCharacterRange: charRange, changeInLength: delta, actualCharacterRange: actualCharRange)
    }
    
    override func invalidateLayout(forCharacterRange charRange: NSRange, actualCharacterRange actualCharRange: NSRangePointer?) {
        super.invalidateLayout(forCharacterRange: charRange, actualCharacterRange: actualCharRange)
    }
    
    override func invalidateDisplay(forGlyphRange glyphRange: NSRange) {
        super.invalidateDisplay(forGlyphRange: glyphRange)
    }
    
    override func invalidateDisplay(forCharacterRange charRange: NSRange) {
        super.invalidateDisplay(forCharacterRange: charRange)
    }
    
    override func processEditing(for textStorage: NSTextStorage, edited editMask: NSTextStorage.EditActions, range newCharRange: NSRange, changeInLength delta: Int, invalidatedRange invalidatedCharRange: NSRange) {
        super.processEditing(for: textStorage, edited: editMask, range: newCharRange, changeInLength: delta, invalidatedRange: invalidatedCharRange)
    }
    
    override func setLineFragmentRect(_ fragmentRect: CGRect, forGlyphRange glyphRange: NSRange, usedRect: CGRect) {
        guard let storage = textStorage else {
            super.setLineFragmentRect(fragmentRect, forGlyphRange: glyphRange, usedRect: usedRect)
            return
        }
        let paragraphAttribute = storage.attribute(.richParagraphAttributeKey, at: characterIndexForGlyph(at: glyphRange.location), effectiveRange: nil)
        let padding = RichAttributesStyling.retrievePadding(for: paragraphAttribute)
        super.setLineFragmentRect(fragmentRect.rectByMovingLeftBorder(by: padding), forGlyphRange: glyphRange, usedRect: usedRect.movedRect(by: CGPoint(x: padding, y: 0)))
    }
    
    override func setExtraLineFragmentRect(_ fragmentRect: CGRect, usedRect: CGRect, textContainer container: NSTextContainer) {
        super.setExtraLineFragmentRect(fragmentRect, usedRect: usedRect, textContainer: container)
    }
    
    override func lineFragmentRect(forGlyphAt glyphIndex: Int, effectiveRange effectiveGlyphRange: NSRangePointer?) -> CGRect {
        return super.lineFragmentRect(forGlyphAt: glyphIndex, effectiveRange: effectiveGlyphRange)
    }
    
    override func lineFragmentRect(forGlyphAt glyphIndex: Int, effectiveRange effectiveGlyphRange: NSRangePointer?, withoutAdditionalLayout flag: Bool) -> CGRect {
        return super.lineFragmentRect(forGlyphAt: glyphIndex, effectiveRange: effectiveGlyphRange, withoutAdditionalLayout: flag)
    }
    
    override func lineFragmentUsedRect(forGlyphAt glyphIndex: Int, effectiveRange effectiveGlyphRange: NSRangePointer?) -> CGRect {
        return super.lineFragmentUsedRect(forGlyphAt: glyphIndex, effectiveRange: effectiveGlyphRange)
    }
    
    override func lineFragmentUsedRect(forGlyphAt glyphIndex: Int, effectiveRange effectiveGlyphRange: NSRangePointer?, withoutAdditionalLayout flag: Bool) -> CGRect {
        return super.lineFragmentUsedRect(forGlyphAt: glyphIndex, effectiveRange: effectiveGlyphRange, withoutAdditionalLayout: flag)
    }
    
    override func setGlyphs(_ glyphs: UnsafePointer<CGGlyph>, properties props: UnsafePointer<NSLayoutManager.GlyphProperty>, characterIndexes charIndexes: UnsafePointer<Int>, font aFont: UIFont, forGlyphRange glyphRange: NSRange) {
        super.setGlyphs(glyphs, properties: props, characterIndexes: charIndexes, font: aFont, forGlyphRange: glyphRange)
    }
    
    override var extraLineFragmentRect: CGRect {
        return super.extraLineFragmentRect
    }
    
}

private extension CGRect {
    
    func rectByMovingLeftBorder(by value: CGFloat) -> CGRect {
        let adjusted = self.width > value ? value : self.width
        return CGRect(x: self.origin.x + adjusted, y: self.origin.y, width: self.width - adjusted, height: self.height)
    }
    
    func movedRect(by vector: CGPoint) -> CGRect {
        return CGRect(x: self.origin.x + vector.x, y: self.origin.y + vector.y, width: self.width, height: self.height)
    }
    
}
