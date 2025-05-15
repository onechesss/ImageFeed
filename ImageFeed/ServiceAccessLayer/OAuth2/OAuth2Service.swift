//
//  Untitled.swift
//  ImageFeed
//
//  Created by oneche$$$ on 01.05.2025.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let request = makeOAuthTokenRequest(code: code)
        
        let task = NetworkClient().data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(response.accessToken))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task?.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com"),
        let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else { print("не удалось создать baseURL или url"); return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
}
