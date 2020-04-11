//
//  RechTextView.swift
//  RichText
//
//  Created by Alexey Rogatkin on 29/02/2020.
//  Copyright © 2020 Alexey Rogatkin. All rights reserved.
//

import Foundation
import UIKit

final class RichTextView : UITextView {
    
    override var keyCommands: [UIKeyCommand]? {
        let nest = UIKeyCommand(input: "\t", modifierFlags: [], action: #selector(nesting), discoverabilityTitle: "Nesting list")
        let flatten = UIKeyCommand(input: "\t", modifierFlags: [.alternate], action: #selector(flattening), discoverabilityTitle: "Flattening list")
        return [nest, flatten]
    }
    
    override var selectedTextRange: UITextRange? {
        get {
            return super.selectedTextRange
        }
        set {
            super.selectedTextRange = newValue
        }
    }
    
    private var richStorage : RichTextStorage {
        return (textStorage as? RichTextStorage) ?? RichTextStorage()
    }
    
    private func isExtraParagraphPosition(_ position: UITextPosition) -> Bool {
        return tokenizer.rangeEnclosingPosition(position, with: .paragraph, inDirection: UITextDirection.storage(.backward)) == nil
            && tokenizer.rangeEnclosingPosition(position, with: .paragraph, inDirection: UITextDirection.storage(.forward)) == nil
    }
    
    private func rangesForListAttributeChanges() -> PerLineAttributesChanges? {
        guard let selectedRange = selectedTextRange else {
            return nil
        }
        
        let paragraph : (UITextPosition) -> UITextRange? = {
            self.tokenizer.rangeEnclosingPosition($0, with: .paragraph, inDirection: UITextDirection.storage(.backward))
        }
        
        var textRanges : [UITextRange] = []
        var cursor : UITextPosition = selectedRange.start
        while let ongoingParagraph = paragraph(cursor),
            compare(cursor, to: endOfDocument) == .orderedAscending,
            compare(cursor, to: selectedRange.end) != .orderedDescending {
                guard
                    let adjustedEnd = position(from: ongoingParagraph.end, offset: 1),
                    let ajustedOngoingParagraph = textRange(from: ongoingParagraph.start, to: adjustedEnd)
                else {
                    textRanges.append(ongoingParagraph)
                    break
                }
                textRanges.append(ajustedOngoingParagraph)
                
                cursor = ajustedOngoingParagraph.end
        }
        
        guard textRanges.isEmpty == false else {
            guard let paragraph = paragraph(cursor) else {
                return PerLineAttributesChanges(storageRanges: [], extralineInvolved: true)
            }
            return PerLineAttributesChanges(storageRanges: [storageRange(from: paragraph)], extralineInvolved: false)
        }
        
        return PerLineAttributesChanges(storageRanges: textRanges.map(storageRange), extralineInvolved: compare(selectedRange.end, to: endOfDocument) == .orderedSame)
        
    }
    
    private func storageRange(from range: UITextRange) -> NSRange {
        let location = offset(from: beginningOfDocument, to: range.start)
        let length = offset(from: range.start, to: range.end)
        return NSRange(location: location, length: length)
    }
    
    @objc func nesting() {
        guard let ranges = rangesForListAttributeChanges() else {
            return
        }
        richStorage.editListLevel(ranges: ranges.storageRanges, direction: .nesting)
    }
    
    @objc func flattening() {
        guard let ranges = rangesForListAttributeChanges() else {
            return
        }
        richStorage.editListLevel(ranges: ranges.storageRanges, direction: .flattening)
    }
    
    init(frame: CGRect = .zero, textContainer: RichTextContainer = RichTextContainer()) {
        let storage = RichTextStorage()
        let manager = RichTextLayoutManager()
        storage.addLayoutManager(manager)
        manager.addTextContainer(textContainer)
        super.init(frame: frame, textContainer: textContainer)

        manager.view = self
    }
    
    override func textStyling(at position: UITextPosition, in direction: UITextStorageDirection) -> [NSAttributedString.Key : Any]? {
        let result = super.textStyling(at: position, in: direction)
        return result
    }
    
    override func insertText(_ text: String) {
        super.insertText(text)
    }
    
    override func deleteBackward() {
        super.deleteBackward()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

struct PerLineAttributesChanges : CustomStringConvertible {
    let storageRanges : [NSRange]
    let extralineInvolved : Bool
    
    var description: String {
        return """
        <PerLineAttributesChanges
            \(storageRanges.map { "\($0)" }.joined(separator: " - "))
            \(extralineInvolved ? "with" : "without") extra line fragment
        >
        """
    }
}
