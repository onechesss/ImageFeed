//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by oneche$$$ on 07.06.2025.
//

import Foundation
@testable import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var loadCalled: Bool = false
    
    func load(request: URLRequest) {
        loadCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
}
