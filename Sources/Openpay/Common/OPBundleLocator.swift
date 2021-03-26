//
//  OPBundleLocator.swift
//  Openpay
//
//  Created by june chen on 3/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

class OPBundleLocator: NSObject {
    static var resourcesBundle: Bundle = {
        var resourcesBundle: Bundle?
        // If the framework is integrated using SPM, then Bundle.module abstracts away the detail
        // of the bundle’s actual location.
        #if SWIFT_PACKAGE
        resourcesBundle = Bundle.module
        #endif

        // If using Cocoapods statically linking the framework,
        // and the framework specifies .resource_bundles in the podspec,
        // then Cocoapods will generate the Openpay.bundle to store resources.
        if resourcesBundle == nil {
            resourcesBundle = Bundle(path: "Openpay.bundle")
        }

        // If using Cocoapods dynamically linking the framework,
        // and the framework specifies .resource_bundles in the podspec,
        // then Cocoapods will generate the Openpay.bundle for resources and put
        // that folder inside .framework bundle. So the path of the resources bundle is
        // Openpay.framework/Openpay.bundle.
        if resourcesBundle == nil {
            // This might be the same as the previous check if not using a dynamic framework
            if let path = Bundle(for: OPBundleTag.self).path(forResource: "Openpay", ofType: "bundle") {
                resourcesBundle = Bundle(path: path)
            }
        }

        // If using Carthage dynamic linking the framework, then the resources location is Openpay.framework.
        if resourcesBundle == nil {
            resourcesBundle = Bundle(for: OPBundleTag.self)
        }

        if let resourcesBundle = resourcesBundle {
            return resourcesBundle
        } else {
            // main bundle (for people dragging all the framework files into their project)
            return Bundle.main
        }
    }()
}

private class OPBundleTag {}
