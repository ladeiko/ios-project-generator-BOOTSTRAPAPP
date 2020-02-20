//
//  BundleInfoDictionaryMock.swift
//  BOOTSTRAPAPPTests
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import Foundation

fileprivate class BundleInfoDictionaryMockNSDictionary: NSMutableDictionary {
    
    private var dict: NSMutableDictionary
    
    override init(capacity numItems: Int) {
        dict = NSMutableDictionary.init(capacity: numItems)
        super.init()
    }
    
    override init() {
        dict = NSMutableDictionary()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        dict = NSMutableDictionary()
        super.init()
    }
    
    init(objects: UnsafePointer<AnyObject>?, forKeys keys: UnsafePointer<NSCopying>?, count cnt: Int) {
        dict = NSMutableDictionary(objects: objects, forKeys: keys, count: cnt)
        super.init()
        
    }
    
    override var count: Int {
        get {
            return dict.count
        }
    }
    
    override func keyEnumerator() -> NSEnumerator {
        return dict.keyEnumerator()
    }
    
    override func object(forKey aKey: Any) -> Any? {
        
        let obj = dict.object(forKey: aKey)
        
        guard let key = aKey as? String else {
            return obj
        }
        
        guard key == "CFBundleShortVersionString" else {
            return obj
        }
        
        guard Bundle.infoDictionaryCustomShortVersionString != nil else {
            return obj
        }
        
        return Bundle.infoDictionaryCustomShortVersionString
    }
}

extension Bundle {
    
    static var infoDictionaryCustomShortVersionString: String? {
        willSet {
            mockInfoDictionary()
        }
    }
    
    @objc(AppStateServiceTests_infoDictionary)
    func BundleInfoDictionaryMock_infoDictionary() -> NSDictionary {
        let original = BundleInfoDictionaryMock_infoDictionary()
        return BundleInfoDictionaryMockNSDictionary(dictionary: original)
    }
    
    private class func swizzleFromSelector(selector: Selector, toSelector: Selector, forClass:AnyClass!) {
        let originalMethod = class_getInstanceMethod(forClass, selector)!
        let swizzledMethod = class_getInstanceMethod(forClass, toSelector)!
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    private static var mockInfoDictionaryApplied = false
    private class func mockInfoDictionary() {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        guard mockInfoDictionaryApplied == false else {
            return
        }
        mockInfoDictionaryApplied = true
        swizzleFromSelector(selector: NSSelectorFromString("infoDictionary"),
                            toSelector: #selector(BundleInfoDictionaryMock_infoDictionary),
                            forClass: self)
    }
}
