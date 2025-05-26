//
//  Untitled.swift
//  ImageFeed
//
//  Created by oneche$$$ on 01.05.2025.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                print("ошибка в Oauth2Service.swift: task != nil, lastCode == code (строка 29)")
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                print("ошибка в Oauth2Service.swift: task == nil, lastCode == code (строка 35)")
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code)
        else {
            print("ошибка в Oauth2Service.swift: не удалось создать URLRequest (строка 45)")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = NetworkClient.shared.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            self.task = nil
            self.lastCode = nil
            switch result {
            case .success(let decodedData):
                completion(.success(decodedData.accessToken))
            case .failure(let error):
                print("ошибка в Oauth2Service.swift: \(error.localizedDescription) (строка 57)")
            }
        }
        self.task = task
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
              ) else {
            print("ошибка в Oauth2Service.swift: не удалось создать baseURL или url (строка 75)")
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
}
