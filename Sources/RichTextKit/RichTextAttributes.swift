//
//  RichTextAttributes.swift
//  RichText
//
//  Created by Alexey Rogatkin on 03/03/2020.
//  Copyright © 2020 Alexey Rogatkin. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString.Key {
    static let richParagraphAttributeKey : NSAttributedString.Key = NSAttributedString.Key("richParagraphAttribute")
}

protocol ParagraphAttribute {
    var sticky : Bool { get }
}

