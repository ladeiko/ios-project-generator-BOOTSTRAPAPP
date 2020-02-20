//
//  Services.swift
//  BOOTSTRAPAPP
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import ViperServices

protocol Services: ViperServicesContainer {
    
    // Sync version of shutdown, should be called while application termination
    func terminate()
    
}

