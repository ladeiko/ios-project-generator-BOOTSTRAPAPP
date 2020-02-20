//
//  ConfigServiceImpl.swift
//  BOOTSTRAPAPP
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import ViperServices

fileprivate struct Values: ConfigValues {
    
    static let defaults = ConfigServiceValuesDescriptors.reduce(into: [ConfigServiceValueKey: ConfigServiceValue]()) { $0[$1.name] = $1 }
    
    let allValues: [ConfigServiceValueKey: Any]
    
    static func normalize(_ values: [ConfigServiceValueKey: Any]) -> [ConfigServiceValueKey: Any] {
        var normalizedValues = values
        let defaults = Values.defaults
        defaults.keys.forEach { (key) in
            normalizedValues[key] = defaults[key]!.get(normalizedValues[key])
        }
        return normalizedValues
    }
    
    init(_ initialValues: [ConfigServiceValueKey: Any] = [ConfigServiceValueKey: Any]()) {
        self.allValues = Values.normalize(initialValues)
    }
    
    // MARK: - ConfigValues
    
    // DO NOT REMOVE THIS COMMENTS!!! Generator will use it as insertion point.
    // <Register new config properties implementations here>
    
    
    // <EXAMPLE BEGIN>
    var boolValue: Bool {
        get {
            return allValues[.boolValue] as! Bool
        }
    }
    
    var intValue: Int {
        get {
            return allValues[.intValue] as! Int
        }
    }
    
    var doubleValue: Double {
        get {
            return allValues[.doubleValue] as! Double
        }
    }
    
    var stringValue: String {
        get {
            return allValues[.stringValue] as! String
        }
    }
    
    var intEnumValue: IntEnumValue {
        get {
            return allValues[.intEnumValue] as! IntEnumValue
        }
    }
    
    var stringEnumValue: StringEnumValue {
        get {
            return allValues[.stringEnumValue] as! StringEnumValue
        }
    }
    // <EXAMPLE END>
    
}

extension Values: Encodable {
    
    enum CodingKeys: CodingKey {
        // <EXAMPLE BEGIN>
        case boolValue
        case intValue
        case doubleValue
        case stringValue
        case intEnumValue
        case stringEnumValue
        // <EXAMPLE END>
        
        // DO NOT REMOVE THIS COMMENTS!!! Generator will use it as insertion point.
        // <Register new config coding key here>
        
        case hello
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // <EXAMPLE BEGIN>
        try container.encode(boolValue, forKey: .boolValue)
        // <EXAMPLE END>
        
        // DO NOT REMOVE THIS COMMENTS!!! Generator will use it as insertion point.
        // <Decode new config value here>
    }
}

extension Values: Decodable {
    
    init(from decoder: Decoder) throws {
    
        var loaded = [ConfigServiceValueKey: Any]()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // <EXAMPLE BEGIN>
        if let value = try? container.decode(Bool.self, forKey: .boolValue) {
            loaded[.boolValue] = value
        }
        if let value = try? container.decode(Int.self, forKey: .intValue) {
            loaded[.intValue] = value
        }
        if let value = try? container.decode(Double.self, forKey: .doubleValue) {
            loaded[.doubleValue] = value
        }
        if let value = try? container.decode(String.self, forKey: .stringValue) {
            loaded[.stringValue] = value
        }
        if let value = try? container.decode(IntEnumValue.self, forKey: .intEnumValue) {
            loaded[.intEnumValue] = value
        }
        if let value = try? container.decode(StringEnumValue.self, forKey: .stringEnumValue) {
            loaded[.stringEnumValue] = value
        }
        // <EXAMPLE END>
        
        // DO NOT REMOVE THIS COMMENTS!!! Generator will use it as insertion point.
        // <Decode new config value here>
        
        self.allValues = Values.normalize(loaded)
    }
    
}

class ConfigServiceImpl: ViperService, ConfigService {
    
    private enum FetchError: Error {
        case invalidResponse
    }

    // MARK: - Vars
    
    private var fetching = false
    private var refetch = false
    private var bootCompleted = false
    private var values = Values()
    
    // MARK: - Life cycle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - ViperService

    func setupDependencies(_ container: ViperServicesContainer) -> [AnyObject]? {
        // TODO: Place your code here
        return nil
    }

    func boot(launchOptions: [UIApplication.LaunchOptionsKey: Any]?, completion: @escaping ViperServiceBootCompletion) {
        
        load()
        
        switch options.syncType {
        case .offline:
            self.bootCompleted = true
            completion(.succeeded)
            
        default:
            fetch { error, data in
                
                if error == nil {
                    let values = self.parse(data)
                    self.merge(values)
                }
                
                self.save()
                self.bootCompleted = true
                completion(.succeeded)
            }
        }
    }

    func shutdown(completion: @escaping ViperServiceShutdownCompletion) {
        // TODO: Place your code here
        completion()
    }
    
    // MARK: - Observers
    
    @objc
    func sync() {
        
        switch options.syncType {
        case .offline:
            return
            
        default: break
        }
        
        self.runOnMain {
            
            guard self.fetching == false else {
                 self.refetch = true
                return
            }
            
             self.fetch { error, data in
                
                if let data = data {
                    let values = self.parse(data)
                    self.merge(values)
                }
                
                self.runOnMain {
                    self.fetching = false
                    if self.refetch {
                        self.refetch = false
                        self.sync()
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private class func equal(_ lhs: [ConfigServiceValueKey: Any], _ rhs: [ConfigServiceValueKey: Any]) -> Bool {
        guard lhs.count == rhs.count else {
            return false
        }
        
        for key in lhs.keys {
            guard let b = rhs[key] else {
                return false
            }
            let a = lhs[key]
            
            if let a = a as? Int, let b = b as? Int {
                if a != b {
                    return false
                }
            }
            else if let a = a as? Double, let b = b as? Double {
                if a != b {
                    return false
                }
            }
            else if let a = a as? Bool, let b = b as? Bool {
                if a != b {
                    return false
                }
            }
            else if let a = a as? String, let b = b as? String {
                if a != b {
                    return false
                }
            }
            else {
                return false
            }
        }
        
        return true
    }
    
    private func encrypt(_ data: Data) -> Data {
        return data
    }
    
    private func decrypt(_ data: Data) -> Data? {
        return data
    }
    
    private func load() {
        
        guard let data = UserDefaults.standard.data(forKey: options.storageKey) else {
            return
        }
        
        guard let decrypted = decrypt(data) else {
            return
        }
        
        let decoder = JSONDecoder()
        
        guard let newValues = try? decoder.decode(Values.self, from: decrypted) else {
            return
        }
        
        values = newValues
    }
    
    private func save() {
        
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(values) else {
            return
        }
        
        let encrypted = encrypt(data)
        UserDefaults.standard.set(encrypted, forKey: options.storageKey)
    }

    private func fetch(_ completion: @escaping ((_ error: Error?, _ data: Data?) -> Void)) {
        
        guard let url = options.url else {
            completion(nil, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = options.fetchTimeout
        
        let backgroundTask: UIBackgroundTaskIdentifier = self.runOnMain {
            return UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        }!
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error ) in
            
            defer {
                self.runOnMain {
                    UIApplication.shared.endBackgroundTask(backgroundTask)
                }
            }
            
            guard error == nil else {
                completion(error, nil)
                return
            }
            
            guard let http = response as? HTTPURLResponse, [200].contains(http.statusCode) else {
                completion(FetchError.invalidResponse, nil)
                return
            }
            
            guard let content = data else {
                completion(nil, nil)
                return
            }
            
            completion(nil, content)
        }
        
        task.resume()
    }
    
    private func parse(_ data: Data?) -> [String: AnyObject]? {
        
        guard let data = data else {
            return nil
        }
        
        guard let contentString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines), contentString.count > 0 else {
            return nil
        }
        
        switch contentString.prefix(1) {
        case "<":
            return (try? PropertyListSerialization.propertyList(from: data, format: nil)) as? [String: AnyObject]
            
        case "{":
            let jsonOptions = JSONSerialization.ReadingOptions(rawValue: 0)
            return (try? JSONSerialization.jsonObject(with: data, options: jsonOptions)) as? [String: AnyObject]
            
        default: return nil // TODO: maybe add dencryption
        }
        
    }
    
    private func merge(_ newValues: [String: AnyObject]?) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }

        let oldValues = values.allValues
        
        if let newValues = newValues {
            
            var updatedValues = values.allValues
            
            for (rawKey, value) in newValues {
                
                let key = rawKey.replacingOccurrences(of: "_", with: "").replacingOccurrences(of: "-", with: "")
                
                guard let supported = ConfigServiceValueKey(rawValue: key) else {
                    continue
                }
                
                guard let supportedValue = Values.defaults[supported] else {
                    continue
                }
                
                switch supportedValue.behavior {
                case .once:
                    if values.allValues[supported] != nil {
                        continue
                    }
                default: break
                }
            
                updatedValues[supported] = supportedValue.get(value) as AnyObject
            }
            
            values = Values(updatedValues)
        }
        
        if bootCompleted && (type(of: self).equal(oldValues, values.allValues) == false) {
            self.runOnMain { () -> Void in
                NotificationCenter.default.post(name: .ConfigServiceDidChangeValue, object: self, userInfo: nil)
            }
        }
    }
    
    private func runOnMain<T>(_ block: @escaping (() -> T?)) -> T? {
        if Thread.isMainThread {
            return block()
        }
        else {
            var t: T?
            DispatchQueue.main.sync {
                t = block()
            }
            return t
        }
    }
    
    // MARK: - ConfigService
    
    required init(options: ConfigServiceOptions) {
        self.options = options
        switch self.options.syncType {
        case .always:
            NotificationCenter.default.addObserver(self, selector: #selector(self.sync), name: UIApplication.didBecomeActiveNotification, object: nil)
        default: break
        }
    }
    
    let options: ConfigServiceOptions
    
    func update() {
        sync()
    }
    
    func valuesSnapshot() -> ConfigValues {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        return values
    }
    
}
