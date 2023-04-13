//
//  String + Extension.swift
//  AuthorizationApp
//
//  Created by Grigore on 10.04.2023.
//

import Foundation

/*
 Se scrie un  extension pentru String,   cand se va apela functia ,,isVAlid,, vom primi ori true ori false
 Am un String, iar prin intermediul predicatelor incepem sa filtram
 oare acel string corespunde cu parametrii care iam dat
 de aceea utilizam evaluate ca sa putem intelege corespunde sau nu
 */

extension String {
    
    //creez  enum care va contine validTypes
    enum ValidTypes {
        case name
        case mail
        case password
        case phone
    }
    
    enum Regex: String {
        //ca sa scriu regular expressions mai intai in acolade[] se scriu acele expresii care se permit dar in{} mai intai valoarea minima apoi prin virgula valoarea maxima
        case name = "[a-zA-Z]{1,}"
        case mail = "[a-zA-Z0-9._]+@[a-zA-Z]+\\.[a-zA-Z]{2,}"                          //company@gmail.com
        //parola obligatoriu treb sa aiba: o litera mare o litera mica, 6 caractere si un simbol
        case password = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}"
        case phone = "^\\d{2}-\\d{3}-\\d{3}$"  //0xx-xxx-xxx
    }
    
    //acum creez o metoda care va trebui sa verifice este valid textul nostru sau nu
    func isValid(validType: ValidTypes) -> Bool {
        
        //setez format pentru predicate, adica aici verific la corespundere:)
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validType {
        case .name: regex = Regex.name.rawValue
        case .mail: regex = Regex.mail.rawValue
        case .password: regex = Regex.password.rawValue
        case .phone: regex = Regex.phone.rawValue
//        default:
//            print("ceva")
        }
        
        
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
    
}
