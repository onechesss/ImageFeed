//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by oneche$$$ on 08.06.2025.
//

import Foundation

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    var dateFormatter: DateFormatter { get set }
    
    func viewDidLoad()
}



class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    func viewDidLoad() {
        ImagesListService.shared.fetchPhotosNextPage()
    }
}
