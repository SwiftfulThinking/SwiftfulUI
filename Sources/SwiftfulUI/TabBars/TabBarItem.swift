//
//  TabBarItem.swift
//  
//
//  Created by Nick Sarno on 4/8/22.
//

import Foundation
import UIKit

public struct TabBarItem: Hashable {
    let title: String?
    let iconName: String?
    let image: UIImage?
    
    public init(title: String?, iconName: String? = nil, image: UIImage? = nil) {
        self.title = title
        self.iconName = iconName
        self.image = image
    }
}
