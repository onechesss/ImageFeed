//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by oneche$$$ on 08.06.2025.
//

@testable import ImageFeed
import XCTest

class ImagesListTests: XCTestCase {
    func testImagesListViewDidLoadCalled() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut = storyboard.instantiateViewController(identifier: "ImagesListViewController") as? ImagesListViewController
        let presenterSpy = ImagesListPresenterSpy()
        sut?.presenter = presenterSpy
        presenterSpy.view = sut
        
        //when
        _ = sut?.view
        
        //then
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
}
