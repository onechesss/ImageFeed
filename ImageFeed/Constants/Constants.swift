//
//  Constants.swift
//  ImageFeed
//
//  Created by oneche$$$ on 15.04.2025.
//
import Foundation

enum Constants {
    static let accessKey = "F8aG75pJNLt2MYNJzE541qzxCEHKs0qxN96acIgtrGo"
    
    static let secretKey = "eW4Z9lINnHGizUS8HCnF7_sOInqkoK8UVj1O-79nm5c"
    
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
    static let accessScope = "public+read_user+write_user+read_photos+write_photos+write_likes+write_followers+read_collections+write_collections"
    
    static let defaultBaseURL: URL = URL(string: "https://api.unsplash.com")!
}
