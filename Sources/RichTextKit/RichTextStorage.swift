//
//  RichTextStorage.swift
//  RichText
//
//  Created by Alexey Rogatkin on 29/02/2020.
//  Copyright © 2020 Alexey Rogatkin. All rights reserved.
//

import Foundation
import UIKit

private extension String {
    static let containerKey : String = "container"
}

final class RichTextStorage : NSTextStorage {
    
    private let container : NSTextStorage
    
    override var string: String {
        return container.string
    }
    
    override init() {
        container = NSTextStorage()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard
            let container = aDecoder.decodeObject(forKey: .containerKey) as? NSTextStorage
        else {
            return nil
        }
        self.container = container
        super.init(coder: aDecoder)
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(container, forKey: .containerKey)
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        return container.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        container.replaceCharacters(in: range, with: str)
        edited([.editedAttributes, .editedCharacters], range: range, changeInLength: str.utf16.count - range.length)
        endEditing()
    }
    
    override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        beginEditing()
        container.setAttributes(attrs, range: range)
        edited([.editedAttributes], range: range, changeInLength: 0)
        endEditing()
    }
    
    override func fixAttributes(in range: NSRange) {
        super.fixAttributes(in: range)
        print("Fix in \(range)")
        print("\(attributedSubstring(from: range))")
    }
    
}

extension RichTextStorage {
    
    enum ListLevelDirection {
        case nesting
        case flattening
    }
    
    func editListLevel(ranges: [NSRange], direction: ListLevelDirection) {
        beginEditing()
        for range in ranges {
            if let someAttribute = container.attribute(.richParagraphAttributeKey, at: range.location, effectiveRange: nil) {
                if let listAttribute = someAttribute as? ListAttribute {
                    switch direction {
                    case .nesting:
                        self.addAttribute(.richParagraphAttributeKey, value: listAttribute.nextLevel(), range: range)
                    case .flattening:
                        if let newAttrubte = listAttribute.previosLevel() {
                            self.addAttribute(.richParagraphAttributeKey, value: newAttrubte, range: range)
                        } else {
                            self.removeAttribute(.richParagraphAttributeKey, range: range)
                        }
                    }
                } else {
                    self.addAttribute(.richParagraphAttributeKey, value: ListAttribute(marksGenerator: EmptyGenerator(), config: .first), range: range)
                }
            } else {
                self.addAttribute(.richParagraphAttributeKey, value: ListAttribute(marksGenerator: EmptyGenerator(), config: .first), range: range)
            }
            edited([.editedAttributes], range: range, changeInLength: 0)
        }
        endEditing()
    }
    
}
