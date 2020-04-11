//
//  RichTextAttributes.swift
//  RichText
//
//  Created by Alexey Rogatkin on 29/02/2020.
//  Copyright © 2020 Alexey Rogatkin. All rights reserved.
//

import Foundation
import UIKit

struct MarkConfig {
    let position : UInt
    let config : ListAttribute.ListConfig
}

protocol MarksGenerator : CustomStringConvertible {
    func drawMark(config: MarkConfig, in rect: CGRect, using context: CGContext)
}

struct EmptyGenerator : MarksGenerator {
    func drawMark(config: MarkConfig, in rect: CGRect, using context: CGContext) {
        
    }
    
    var description: String {
        return " "
    }
}

struct ListAttribute : ParagraphAttribute, CustomStringConvertible {
    
    let sticky = true
    let marksGenerator : MarksGenerator
    let config : ListConfig
    
    func nextLevel() -> ListAttribute {
        return ListAttribute(marksGenerator: marksGenerator, config: config.next())
    }
    
    func previosLevel() -> ListAttribute? {
        guard let config = config.previous() else {
            return nil
        }
        return ListAttribute(marksGenerator: marksGenerator, config: config)
    }
    
    func replaceMarks(with generator: MarksGenerator) -> ListAttribute {
        return ListAttribute(marksGenerator: generator, config: config)
    }
    
    var description: String {
        return "list(\(marksGenerator))#\(config.rawValue)"
    }
}

extension ListAttribute {
    
    enum ListConfig : Int {
        case first
        case second
        case third
        case fourth
        case fifth
        case sixth
        case seventh
        case eighth
        case ninth

        func next() -> ListConfig {
            return ListConfig(rawValue: self.rawValue + 1) ?? self
        }
        
        func previous() -> ListConfig? {
            return ListConfig(rawValue: self.rawValue - 1)
        }
    }

}


