//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by oneche$$$ on 27.05.2025.
//

import Foundation
import ProgressHUD

final class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    // ...
    
    func fetchPhotosNextPage() {
        DispatchQueue.main.async { UIBlockingProgressHUD.dismiss() }
        let nextPage = (lastLoadedPage ?? 0) + 1
        let request = makeRequestForImagesListService()
        let task = NetworkClient.shared.objectTask(for: request) { [weak self] (result: Result<PhotoResults, Error>) in
            guard let self else { return }
            switch result {
            case .success(let decodedData):
                for photo in decodedData.photos {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    let date = dateFormatter.date(from: photo.createdAt)
                    let photoForUI = Photo(id: photo.id, size: CGSize(width: photo.width, height: photo.width), createdAt: date, welcomeDescription: photo.description, thumbImageURL: photo.urls.thumb, largeImageURL: photo.urls.full, isLiked: photo.likedByUser)
                    DispatchQueue.main.async {
                        self.photos.append(photoForUI)
                    }
                }
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
            case .failure(let error):
                print("ошибка в ImagesListService.swift: \(error.localizedDescription) (строка 32)")
            }
            DispatchQueue.main.async { UIBlockingProgressHUD.dismiss() }
        }
        task?.resume()
    }
    
    private func makeRequestForImagesListService() -> URLRequest {
        guard let url = URL(string: "\(Constants.defaultBaseURL)/photos")
        else {
            print("ошибка в ImagesListService.swift: не получилось создать URL (строка 40)")
            return URLRequest(url: URL(string: "")!)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(OAuth2TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
}
