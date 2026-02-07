//
//  UserDefaultPropertyWrapper.swift
//  SwiftfulUI
//
//  Created by Nick Sarno.
//
import Foundation

public protocol UserDefaultsCompatible { }
extension Bool: UserDefaultsCompatible { }
extension Int: UserDefaultsCompatible { }
extension Float: UserDefaultsCompatible { }
extension Double: UserDefaultsCompatible { }
extension String: UserDefaultsCompatible { }
extension URL: UserDefaultsCompatible { }

@propertyWrapper
public struct UserDefault<Value: UserDefaultsCompatible> {
    private let key: String
    private let startingValue: Value

    public init(key: String, startingValue: Value) {
        self.key = key
        self.startingValue = startingValue
    }

    public var wrappedValue: Value {
        get {
            if let savedValue = UserDefaults.standard.value(forKey: key) as? Value {
                return savedValue
            } else {
                UserDefaults.standard.set(startingValue, forKey: key)
                return startingValue
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

@propertyWrapper
public struct UserDefaultEnum<T: RawRepresentable> where T.RawValue == String {
    private let key: String
    private let startingValue: T

    public init(key: String, startingValue: T) {
        self.key = key
        self.startingValue = startingValue
    }

    public var wrappedValue: T {
        get {
            if let savedString = UserDefaults.standard.string(forKey: key), let savedValue = T(rawValue: savedString) {
                return savedValue
            } else {
                UserDefaults.standard.set(startingValue.rawValue, forKey: key)
                return startingValue
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: key)
        }
    }
}
