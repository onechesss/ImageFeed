//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by oneche$$$ on 08.06.2025.
//

import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let sut = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        presenter.view = sut
        sut.presenter = presenter
        
        //when
        _ = sut.view
        
        //then
        XCTAssertTrue(presenter.viewDidCalled)
    }
    
    func testViewControllerCallsUpdateAvatar() {
        //given
        let sut = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        presenter.view = sut
        sut.presenter = presenter
        
        //when
        _ = sut.view
        
        XCTAssertTrue(presenter.updateAvatarCalled)
    }
    
    func testNotificationTriggersAvatarUpdate() {
        //given
        let presenter = ProfilePresenterSpy()
        let sut = ProfileViewController()
        sut.presenter = presenter
        
        //when
        _ = sut.view
        NotificationCenter.default.post(
            name: ProfileImageService.didChangeNotification,
            object: nil
        )
        
        //then
        XCTAssertTrue(presenter.updateAvatarCalled)
    }
}
