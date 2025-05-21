//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by oneche$$$ on 11.05.2025.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

struct NetworkClient {
    static let shared = NetworkClient()
    private init() { }
    
    func objectTask<T: Decodable>(
            for request: URLRequest,
            completion: @escaping (Result<T, Error>) -> Void
        ) -> URLSessionTask? {
            let decoder = JSONDecoder()
            let task = data(for: request) { (result: Result<Data, Error>) in
                switch result {
                case .success(let data):
                    do {
                        let decodedData = try decoder.decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        print("Ошибка декодирования: \(error.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            return task
        }
    
    func data(
        for request: URLRequest?,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask? {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        guard let request = request else { return nil }
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print("error on 60 (NetworkClient):=\(NetworkError.httpStatusCode(statusCode))")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print(NetworkError.urlRequestError(error))
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print(NetworkError.urlSessionError)
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        return task
    }
}
