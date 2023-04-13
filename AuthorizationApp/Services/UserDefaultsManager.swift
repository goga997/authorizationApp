//
//  UserDefaultsManager.swift
//  AuthorizationApp
//
//  Created by Grigore on 12.04.2023.
//

import Foundation


//imitatie la o baza de date :)

class DataBase {
    //folosesc singleTon
    static let shared = DataBase()
    
    
    enum SettingsKeys: String {
       case userKey
        case activeUser
        
    }
    
    let defaults = UserDefaults.standard
    let userKey = SettingsKeys.userKey.rawValue
    let activeUserKey = SettingsKeys.activeUser.rawValue
    
    var users: [User] {
        get {
            if let data = defaults.value(forKey: userKey) as? Data {
                return try! PropertyListDecoder().decode([User].self, from: data)
            } else {
                return [User]()
            }
        }
        
        set {
            //Codam datele noastre in Data, apoi le salvam, adica incercam sa primim mai intii data
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: userKey)
            }
        }
    }
    
    func saveUser(firstName: String, lastName: String, phone: String, mail: String, password: String, age: Date) {
        
        let user = User(firstName: firstName, lastName: lastName, phone: phone, mail: mail, password: password, age: age)
        users.insert(user, at: 0)
    }
    
    
    var activeUser: User? {
        get {
            if let data = defaults.value(forKey: activeUserKey) as? Data {
                return try! PropertyListDecoder().decode(User.self, from: data)
            } else {
                return nil
            }
        }
        
        set {
            //Codam datele noastre in Data, apoi le salvam, adica incercam sa primim mai intii data
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: activeUserKey)
            }
        }
    }
    
    func saveActiveuser(user: User) {
        activeUser = user
    }
    
}
