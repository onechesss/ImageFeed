//
//  ProfileService.swift
//  ImageFeed
//
//  Created by oneche$$$ on 18.05.2025.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private init() { }
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Profile) -> Void) {
        let stringForURL = "\(Constants.defaultBaseURL)\("/me")"
        guard let url = URL(string: stringForURL) else { return }
        
        let request = makeRequestForProfileService(url: url, token: token)

        let task = NetworkClient.shared.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let decodedData):
                let profile = Profile(username: decodedData.username,
                                      name: decodedData.firstName + " " + decodedData.lastName,
                                      bio: decodedData.bio ?? "")
                completion(profile)
            case .failure(let error):
                print("ошибка в ProfileService.swift: \(error.localizedDescription) (строка 32)")
            }
        }
        task?.resume()
    }
    
    private func makeRequestForProfileService(url: URL, token: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}

