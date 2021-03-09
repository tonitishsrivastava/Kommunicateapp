//
//  NetworkOperation.swift
//  Kommunicate app
//
//  Created by Nitish Srivastava on 09/03/21.
//

import Foundation
import Alamofire


class NetworkOperation{
    
    static let network = NetworkOperation()
    
    private init(){}
    
    func fetchImages(searchTerm: String, completion: @escaping (_ postImage: [ImageData]?,_ errorMessage: String?) -> Void){
        
        if (Reachability.isConnectedToNetwork()) {
            let header: HTTPHeaders = [
                AppConstant.AUTHORIZATION: AppConstant.API_Key
            ]
            let url = "\(AppConstant.BASE_URL)\(searchTerm)"
            print(url)
            Alamofire.request(url, headers: header).validate().responseJSON { response in
                guard response.result.isFailure else {
                    let data = response.result.value
                    self.blogFromOnlineData(data as Any, searchedKey: searchTerm){(posts) in
                        completion(posts, nil)
                    }
                    return
                }
                completion(nil,AppConstant.SEARCHED_ISSUE)
            }
        }else{
            completion(nil,AppConstant.INTERNET_ISSUE)
        }
    }
    
    func blogFromOnlineData(_ data: Any, searchedKey: String, completion: @escaping (_ postImage: [ImageData]?) -> Void) {
            let rootObject = data as! [String: Any]
            
            guard let postObjects = rootObject[AppConstant.RESULT_KEY] as? [[String: AnyObject]] else {
                completion(nil)
                return
            }
            let newPost =  postObjects.map({ (dic) -> ImageData in
                return ImageData(json: dic, searchedKey: searchedKey)
            })
            if newPost.count > 0 {
                completion(newPost)
            } else {
                completion(nil)
            }
    }
    
}
