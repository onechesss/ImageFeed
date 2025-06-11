//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by oneche$$$ on 27.05.2025.
//

import Foundation
import ProgressHUD
import UIKit

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var photosAreFetching = false
    private lazy var dateFormatter = ISO8601DateFormatter()
    
    private init() { }
    
    func fetchPhotosNextPage() {
        guard !ImagesListService.shared.photosAreFetching else { return }
        ImagesListService.shared.photosAreFetching = true
        DispatchQueue.main.async { UIBlockingProgressHUD.dismiss() }
        let nextPage = (ImagesListService.shared.lastLoadedPage ?? 0) + 1
        let request = makeRequestForImagesListService(nextPage: nextPage)
        ImagesListService.shared.lastLoadedPage = nextPage
        let task = NetworkClient.shared.objectTask(for: request) { (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let decodedData):
                var newPhotos: [Photo] = []
                for photo in decodedData {
                    let date = ImagesListService.shared.dateFormatter.date(from: photo.createdAt)
                    let photoForUI = Photo(id: photo.id,
                                           size: CGSize(width: photo.width, height: photo.height),
                                           createdAt: date,
                                           welcomeDescription: photo.description,
                                           thumbImageURL: photo.urls.thumb,
                                           largeImageURL: photo.urls.full,
                                           isLiked: photo.likedByUser)
                    newPhotos.append(photoForUI)
                }
                DispatchQueue.main.async {
                    ImagesListService.shared.photos.append(contentsOf: newPhotos)
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: ImagesListService.shared)
                }
            case .failure(let error):
                print("ошибка в ImagesListService.swift: \(error.localizedDescription) (строка 49)")
            }
            DispatchQueue.main.async {
                ImagesListService.shared.photosAreFetching = false
                UIBlockingProgressHUD.dismiss() }
        }
        task?.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.defaultBaseURL)/photos/\(photoId)/like") else {
            print("ошибка в ImagesListService.swift: не получилось создать URL (строка 58)")
            return
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(OAuth2TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        if isLike {
            request.httpMethod = "DELETE"
        } else {
            request.httpMethod = "POST"
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("ошибка в ImagesListService.swift: \(error?.localizedDescription ?? "") (строка 70)")
                completion(.failure(error!)) // используем force-операцию так как error != nil
                return
            }
            guard data != nil else {
                print("ошибка в ImagesListService.swift: data == nil (строка 75)")
                return
            }
            guard response != nil else {
                print("ошибка в ImagesListService.swift: response == nil (строка 79)")
                return
            }
            DispatchQueue.main.async {
                if let index = ImagesListService.shared.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = ImagesListService.shared.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    ImagesListService.shared.photos.remove(at: index)
                    ImagesListService.shared.photos.insert(newPhoto, at: index)
                    completion(.success(Void()))
                }
            }
        }
        task.resume()
    }
    
    func cleanPhotos() {
        ImagesListService.shared.photos.removeAll()
    }
    
    private func makeRequestForImagesListService(nextPage: Int) -> URLRequest {
        guard let url = URL(string: "\(Constants.defaultBaseURL)/photos?page=\(nextPage)")
        else {
            print("ошибка в ImagesListService.swift: не получилось создать URL (строка 110)")
            return URLRequest(url: URL(string: "")!)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(OAuth2TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
}
