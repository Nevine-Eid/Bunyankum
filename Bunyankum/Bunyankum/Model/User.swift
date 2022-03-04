//
//  User.swift
//  GarGor
//
//  Created by Mina Thabet on 22/07/2020.
//  Copyright © 2020 HardTask. All rights reserved.
//

import Foundation

class User: Codable{
    
    static let shared = User()

    var id: Int = 0
    var Token : String = ""
    var ExpireDate : String = ""
    var RefreshToken : String = ""
    var isGuest = true
    var lang: String = ""
    var currency = ""
    var weightName = ""
    var CartCount = 0
    var notificationCount = 0
    var fromCart = false
    var catId: [Int] = []
    var catName = ""
    var isSelectLanguage = false
    var selectedCatId = 0
    var selectedCatName = ""
    var isCourses = false

    init(){
        getStoredData()
    }
    
    func storeData(){
        sharedPref.shared.setSharedValue("id", value: self.id )
        sharedPref.shared.setSharedValue("Token", value: self.Token )
        sharedPref.shared.setSharedValue("ExpireDate", value: self.ExpireDate)
        sharedPref.shared.setSharedValue("RefreshToken", value: self.RefreshToken)
        sharedPref.shared.setSharedValue("lang", value: self.lang)
        sharedPref.shared.setSharedValue("weightName", value: self.weightName)
        sharedPref.shared.setSharedValue("CartCount", value: self.CartCount)
        sharedPref.shared.setSharedValue("currency", value: self.currency)
        sharedPref.shared.setSharedValue("isGuest", value: self.isGuest)
        sharedPref.shared.setSharedValue("isSelectLanguage", value: self.isSelectLanguage)
        getStoredData()

    }
    
     func getStoredData(){
        self.id = sharedPref.shared.getSharedValue(forKey: "id") as? Int ?? 0
        self.Token = sharedPref.shared.getSharedValue(forKey: "Token") as? String ?? ""
        self.ExpireDate = sharedPref.shared.getSharedValue(forKey: "ExpireDate") as? String ?? ""
        self.RefreshToken = sharedPref.shared.getSharedValue(forKey: "RefreshToken") as? String ?? ""
        self.lang = sharedPref.shared.getSharedValue(forKey: "lang") as? String ?? ""
        self.CartCount = sharedPref.shared.getSharedValue(forKey: "CartCount") as? Int ?? 0
        self.weightName = sharedPref.shared.getSharedValue(forKey: "weightName") as? String ?? ""
        self.currency = sharedPref.shared.getSharedValue(forKey: "currency") as? String ?? ""
        self.isGuest = sharedPref.shared.getSharedValue(forKey: "isGuest") as? Bool ?? false
        self.isSelectLanguage = sharedPref.shared.getSharedValue(forKey: "isSelectLanguage") as? Bool ?? false

    }
    
    func logout(){
        sharedPref.shared.removeValue(forKey: "id")
        sharedPref.shared.removeValue(forKey: "Token")
        sharedPref.shared.removeValue(forKey: "ExpireDate")
        sharedPref.shared.removeValue(forKey: "RefreshToken")
        sharedPref.shared.removeValue(forKey: "lang")
        sharedPref.shared.removeValue(forKey: "weightName")
        sharedPref.shared.removeValue(forKey: "CartCount")
        sharedPref.shared.removeValue(forKey: "isGuest")
//        sharedPref.shared.removeValue(forKey: "currency")
        getStoredData()
    }

}
