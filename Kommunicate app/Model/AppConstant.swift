//
//  AppConstant.swift
//  Kommunicate app
//
//  Created by Nitish Srivastava on 09/03/21.
//

import Foundation

class AppConstant{
    
    // App constant
    
    static let APP_NAME = "ML Example"
    
    // VIEW Identifier constant
    
    static let CELL_IDENTIFIER = "image_cell"
    static let STORYBOARD_IDENTIFIER = "Main"
    static let DETAIL_VIEW_CONTROLLER_IDENTIFIER = "detail"
    
    // NetworkOpertion constant
    
    static let API_Key = "Client-ID coNJDVKCeOBoTe-5x6r2q2EbVJtHuJSocaZziyF_yWo"
    static let BASE_URL = "https://api.unsplash.com/search/photos?page=1&per_page=20&query="
    static let AUTHORIZATION = "Authorization"
    static let RESULT_KEY = "results"
    static let USER_KEY = "user"
    static let UPLOADED_BY_USERNAME_KEY = "name"
    static let URL_KEY = "urls"
    static let SMALL_KEY = "small"
    static let REGULAR_KEY = "regular"
    static let INTERNET_ISSUE = "Please connect to Internet and retry."
    static let SEARCHED_ISSUE = "Searched quota expire. Please try after sometime."
    
    // HomeViewController constant
    
    static let SEARCH_PLACEHOLDER = "Search images."
    static let PLACEHOLDER_IMAGE = "background_image"
    static let INTERNET_ISSUE_TITLE = "No Internet Connection"
    static let SEARCHED_ISSUE_TITLE = "Failed"
    static let SEARCH_IMAGE = "browsing"
    static let ERROR_IMAGE = "notfound"
    static let SEARCH_IMAGE_MESSAGE = "Make search."
    static let ERROR_MESSAGE = "Sorry we couldn't find any matches for"
    static let RETRY = "Retry"
    
    // DetailViewController constant
    
    static let LOADING_MESSAGE = "Loading data please wait."
    static let DETECTING_MESSAGE = "detecting scene..."
    static let PERCENTAGE_TEXT = "% it's "
    
}
