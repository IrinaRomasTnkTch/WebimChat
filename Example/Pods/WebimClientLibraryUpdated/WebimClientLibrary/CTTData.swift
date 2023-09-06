import Foundation

open class CTTData {
    
    public static var standard = CTTData(fileName: "userdata.dat")
    
    private var userData: [String: Any] = [:]
    
    private let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
        getData()
        
        initializeUserDataFile()
    }
    
    /**
     -objectForKey: will search the receiver's search list for a default with the key 'defaultName' and return it. If another process has changed defaults in the search list, NSUserDefaults will automatically update to the latest values. If the key in question has been marked as ubiquitous via a Defaults Configuration File, the latest value may not be immediately available, and the registered value will be returned instead.
     */
    open func object(forKey defaultName: String) -> Any? {
        getValueUserData(forKey: defaultName)
    }
    
    open func value(forKey defaultName: String) -> Any? {
        getValueUserData(forKey: defaultName)
    }
    
    /**
     -setObject:forKey: immediately stores a value (or removes the value if nil is passed as the value) for the provided key in the search list entry for the receiver's suite name in the current user and any host, then asynchronously stores the value persistently, where it is made available to other processes.
     */
    open func set(_ value: Any?, forKey defaultName: String) {
        setValueUserData(value, forKey: defaultName)
    }
    
    open func setValue(_ value: Any?, forKeyPath defaultName: String) {
        setValueUserData(value, forKey: defaultName)
    }
    
    /// -removeObjectForKey: is equivalent to -[... setObject:nil forKey:defaultName]
    open func removeObject(forKey defaultName: String) {
        userData.removeValue(forKey: defaultName)
        saveUserData()
    }
    
    /// -stringForKey: is equivalent to -objectForKey:, except that it will convert NSNumber values to their NSString representation. If a non-string non-number value is found, nil will be returned.
    open func string(forKey defaultName: String) -> String? {
        getValueUserData(forKey: defaultName)
    }
    
    /// -arrayForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSArray.
    open func array(forKey defaultName: String) -> [Any]? {
        getValueUserData(forKey: defaultName)
    }
    
    /// -dictionaryForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSDictionary.
    open func dictionary(forKey defaultName: String) -> [String : Any]? {
        getValueUserData(forKey: defaultName)
    }
    
    /// -dataForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSData.
    open func data(forKey defaultName: String) -> Data? {
        getValueUserData(forKey: defaultName)
    }
    
    /// -stringForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSArray<NSString *>. Note that unlike -stringForKey:, NSNumbers are not converted to NSStrings.
    open func stringArray(forKey defaultName: String) -> [String]? {
        getValueUserData(forKey: defaultName)
    }
    
    /**
     -integerForKey: is equivalent to -objectForKey:, except that it converts the returned value to an NSInteger. If the value is an NSNumber, the result of -integerValue will be returned. If the value is an NSString, it will be converted to NSInteger if possible. If the value is a boolean, it will be converted to either 1 for YES or 0 for NO. If the value is absent or can't be converted to an integer, 0 will be returned.
     */
    open func integer(forKey defaultName: String) -> Int {
        getValueUserData(forKey: defaultName) ?? 0
    }
    
    /// -floatForKey: is similar to -integerForKey:, except that it returns a float, and boolean values will not be converted.
    open func float(forKey defaultName: String) -> Float {
        getValueUserData(forKey: defaultName) ?? 0.0
    }

    
    /// -doubleForKey: is similar to -integerForKey:, except that it returns a double, and boolean values will not be converted.
    open func double(forKey defaultName: String) -> Double {
        getValueUserData(forKey: defaultName) ?? 0.0
    }
    
    /**
     -boolForKey: is equivalent to -objectForKey:, except that it converts the returned value to a BOOL. If the value is an NSNumber, NO will be returned if the value is 0, YES otherwise. If the value is an NSString, values of "YES" or "1" will return YES, and values of "NO", "0", or any other string will return NO. If the value is absent or can't be converted to a BOOL, NO will be returned.
     
     */
    open func bool(forKey defaultName: String) -> Bool {
        getValueUserData(forKey: defaultName) ?? false
    }
    
    /**
     -URLForKey: is equivalent to -objectForKey: except that it converts the returned value to an NSURL. If the value is an NSString path, then it will construct a file URL to that path. If the value is absent or can't be converted to an NSURL, nil will be returned.
     */
    open func url(forKey defaultName: String) -> URL? {
        getValueUserData(forKey: defaultName)
    }
    
    /// -setInteger:forKey: is equivalent to -setObject:forKey: except that the value is converted from an NSInteger to an NSNumber.
    open func set(_ value: Int, forKey defaultName: String) {
        setValueUserData(value, forKey: defaultName)
    }

    /// -setFloat:forKey: is equivalent to -setObject:forKey: except that the value is converted from a float to an NSNumber.
    open func set(_ value: Float, forKey defaultName: String) {
        setValueUserData(value, forKey: defaultName)
    }

    /// -setDouble:forKey: is equivalent to -setObject:forKey: except that the value is converted from a double to an NSNumber.
    open func set(_ value: Double, forKey defaultName: String) {
        setValueUserData(value, forKey: defaultName)
    }
    
    /// -setBool:forKey: is equivalent to -setObject:forKey: except that the value is converted from a BOOL to an NSNumber.
    open func set(_ value: Bool, forKey defaultName: String) {
        setValueUserData(value, forKey: defaultName)
    }
    
    /// -setURL:forKey is equivalent to -setObject:forKey
    open func set(_ url: URL?, forKey defaultName: String) {
        setValueUserData(url, forKey: defaultName)
    }
    
    /**
     -dictionaryRepresentation returns a composite snapshot of the values in the receiver's search list.
     */
    open func dictionaryRepresentation() -> [String : Any] {
        userData
    }
}

// MARK: private methods
extension CTTData {
    private func getValueUserData<T>(forKey defaultName: String) -> T? {
        return userData[defaultName] as? T
    }
    
    private func setValueUserData(_ value: Any?, forKey defaultName: String) {
        userData[defaultName] = value
        saveUserData()
    }
    
    private func saveUserData() {
        // Getting the path to a file
        if let fileURL = getFileURL() {
            do {
                // Saving a dictionary to a format file plist
                let data = try PropertyListSerialization.data(fromPropertyList: userData, format: .xml, options: 0)
                try data.write(to: fileURL)
                
                print("CTTData: Data successfully saved to file")
            } catch {
                print("CTTData: Error while saving data: \(error)")
            }
        }
    }
    
    private func getData() {
        // Reading data from a file
        if let fileURL = getFileURL() {
            do {
                let data = try Data(contentsOf: fileURL)
                print(fileURL.absoluteString)
                // Data decoding
                userData = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] ?? [:]
                    print("CTTData: Read Data: \(userData)")
            } catch {
                print("CTTData: Error while read data: \(error)")
            }
        }
    }
    
    private func getFileURL() -> URL? {
        if let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            return url.appendingPathComponent(fileName)
        }
        
        return nil
    }
    
    private func initializeUserDataFile() {
        if userData.isEmpty {
            for key in UserDefaults.standard.dictionaryRepresentation().keys {
                userData[key] = UserDefaults.standard.object(forKey: key)
            }
        }
    }
}
