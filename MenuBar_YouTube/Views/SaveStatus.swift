//
//  SaveStatus.swift
//  MenuBar_YouTube
//
//  Created by MitsukiGoto on 2020/01/24.
//  Copyright © 2020 五島充輝. All rights reserved.
//

import Foundation

class SaveStatus {
    var isChanged:NSInteger=0
    
    static let shared = SaveStatus()
    private init() {
    }
}
