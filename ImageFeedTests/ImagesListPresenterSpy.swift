//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by oneche$$$ on 08.06.2025.
//

import Foundation
@testable import ImageFeed

class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var viewDidLoadCalled = false
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}
