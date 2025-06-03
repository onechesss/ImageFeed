//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by oneche$$$ on 13.05.2025.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    static let shared = SplashViewController()
    
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = OAuth2TokenStorage.shared.token {
            fetchProfile(token)
            switchToTabBarController()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let authViewController = storyboard.instantiateViewController(identifier: "AuthViewController") as? AuthViewController else { return }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                guard let self else { return }
                switch result {
                case .success(let token):
                    OAuth2TokenStorage.shared.token = token
                    AuthViewController().webViewViewControllerDidCancel(WebViewViewController())
                    self.switchToTabBarController()
                    self.fetchProfile(token)
                case .failure(let error):
                    print("ошибка в SplashViewController: \(error.localizedDescription) (строка 62)")
                    let alert = UIAlertController(title: "Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Ок", style: .default)
                    alert.addAction(alertAction)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        ProfileService.shared.fetchProfile(token) { [weak self] profile in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
            }
            ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
            guard let self = self else { return }
                switchToTabBarController()
        }
    }
}

// MARK: setup view
extension SplashViewController {
    private func setupView() {
        view.backgroundColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LaunchScreen symbol")
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
    }
}
