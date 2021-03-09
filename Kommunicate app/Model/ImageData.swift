//
//  ImageData.swift
//  Kommunicate app
//
//  Created by Nitish Srivastava on 09/03/21.
//

import Foundation

struct ImageData {
    let searchedKey: String!
    let regularUrl: String!
    let smallUrl:String!
    let byUser: String!
    
    init(json: [String: AnyObject], searchedKey: String) {
        
        self.searchedKey = searchedKey
        
        if let user = json[AppConstant.USER_KEY] as? [String: Any] {
            if let uploadedBy = user[AppConstant.UPLOADED_BY_USERNAME_KEY] as? String {
                self.byUser = uploadedBy
            } else {
                self.byUser = ""
            }
        }  else {
            self.byUser = ""
        }
        
        if let urls = json[AppConstant.URL_KEY] as? [String: Any]{
            if let smallImage = urls[AppConstant.SMALL_KEY] as? String{
                self.smallUrl = smallImage
            } else {
                self.smallUrl = ""
            }
            if let largeImage = urls[AppConstant.REGULAR_KEY] as? String{
                self.regularUrl = largeImage
            }  else {
                self.regularUrl = ""
            }
        } else {
            self.smallUrl = ""
            self.regularUrl = ""
        }
        
    }
    
}
