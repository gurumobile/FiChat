//
//  Channel.swift
//  FiChat
//
//  Created by sambo on 5/3/17.
//  Copyright © 2017 sambo. All rights reserved.
//

import Foundation

internal class Channel {
    internal let id: String
    internal let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
