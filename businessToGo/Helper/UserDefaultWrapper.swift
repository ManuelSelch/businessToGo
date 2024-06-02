import Foundation

@propertyWrapper
struct UserDefaultWrapper<T: Codable> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }

            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)

            UserDefaults.standard.set(data, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
}

struct UserDefault {
    @UserDefaultWrapper(key: "isLocalLog", defaultValue: false)
    static var isLocalLog: Bool
    
    @UserDefaultWrapper(key: "isRemoteLog", defaultValue: false)
    static var isRemoteLog: Bool
    
    @UserDefaultWrapper(key: "isIntro", defaultValue: true)
    static var isIntro: Bool
}


