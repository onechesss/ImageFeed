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
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                    print(NetworkError.httpStatusCode(statusCode))
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
                print(NetworkError.urlRequestError(error))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
                print(NetworkError.urlSessionError)
            }
        })
        
        return task
    }
}
