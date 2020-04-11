//
//  RichAttributesStyling.swift
//  RichText
//
//  Created by Alexey Rogatkin on 03/04/2020.
//  Copyright © 2020 Alexey Rogatkin. All rights reserved.
//

import Foundation
import UIKit

struct RichAttributesStyling {
    
    static func retrievePadding(for paragrapgAttribute: Any?) -> CGFloat {
        guard let listAttribute = paragrapgAttribute as? ListAttribute else {
            return 0.0
        }
        return 32.0 * CGFloat(listAttribute.config.rawValue + 1)
    }
}
