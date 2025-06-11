//
//  ImagesListViewControllerFake.swift
//  ImageFeedTests
//
//  Created by oneche$$$ on 08.06.2025.
//

import Foundation
@testable import ImageFeed

final class ImagesListViewControllerFake: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    var cleanPhotosAndTableViewInImagesListViewControllerCalled = false
    
    func viewDidLoad() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("cleanPhotosInImagesList"), object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            self.cleanPhotosAndTableViewInImagesListViewController()
        }
    }
    
    func cleanPhotosAndTableViewInImagesListViewController() {
        cleanPhotosAndTableViewInImagesListViewControllerCalled = true
    }
}
