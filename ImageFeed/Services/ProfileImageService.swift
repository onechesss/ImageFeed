//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by oneche$$$ on 19.05.2025.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
        
    private init() { }
    
    private(set) var avatarURL: String?
    
    private enum NetworkError: Error {
        case codeError
    }
    
    
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (UserResult) -> Void) {
        let request = makeRequestForProfileImageService(username: username)
        guard let request else { return }
        
        let task = NetworkClient.shared.objectTask(for: request) { (result: Result<UserResult, Error>) in
            switch result {
            case .success(let decodedData):
                ProfileImageService.shared.avatarURL = decodedData.profileImage.small
                completion(decodedData)
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": decodedData.profileImage.small])
            case .failure(let error):
                print("ошибка в ProfileImageService.swift: \(error.localizedDescription) (строка 39)")
            }
        }
        task?.resume()
    }
        
    private func makeRequestForProfileImageService(username: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseURL)/users/\(username)") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(OAuth2TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
}
