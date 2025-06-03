//
//  ViewController.swift
//  ImageFeed
//
//  Created by oneche$$$ on 20.03.2025.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private var photos: [Photo] = []
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main) { [self] _ in
            DispatchQueue.main.async { self.updateTableViewAnimated() }
        }
        
        ImagesListService.shared.fetchPhotosNextPage()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("cleanPhotosInImagesList"), object: nil, queue: .main) { [weak self] _ in
            print("notification!")
            guard let self else { return }
            self.cleanPhotosAndTableViewInImagesListViewController()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            setImageForSingleImageViewController(indexPath: indexPath, viewController: viewController)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func setImageForSingleImageViewController(indexPath: IndexPath, viewController: SingleImageViewController) {
        let imageView = UIImageView()
        DispatchQueue.main.async { UIBlockingProgressHUD.show() }
        imageView.kf.setImage(with: URL(string: photos[indexPath.row].largeImageURL)) { result in
            switch result {
            case .success:
                let image = imageView.image
                viewController.image = image
                DispatchQueue.main.async { UIBlockingProgressHUD.dismiss() }
            case .failure:
                let alert = UIAlertController(title: "Что-то пошло не так. Попробовать ещё раз?", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "Не надо", style: .cancel)
                let anotherAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
                    self?.setImageForSingleImageViewController(indexPath: indexPath, viewController: viewController)
                }
                alert.addAction(action)
                alert.addAction(anotherAction)
                self.present(alert, animated: true)
            }
        }
    }
}



extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell , with: indexPath)
        
        func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
            let imageView = UIImageView()
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: URL(string: photos[indexPath.row].thumbImageURL), placeholder: UIImage(named: "placeholder")) { _ in
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            cell.delegate = self
            cell.imageInCell.image = imageView.image
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            cell.dateLabel.text = dateFormatter.string(from: photos[indexPath.row].createdAt ?? Date())
            if photos[indexPath.row].isLiked {
                cell.likeButton.setImage(UIImage(named: "like_button_on"), for: .normal)
            } else {
                cell.likeButton.setImage(UIImage(named: "like_button_off"), for: .normal)
            }
        }
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
    
    func cleanPhotosAndTableViewInImagesListViewController() {
        photos = []
        tableView.reloadData()
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = ImagesListService.shared.photos.count
        photos = ImagesListService.shared.photos
        if oldCount != newCount {
            DispatchQueue.main.async {
                self.tableView.performBatchUpdates {
                    var indexPaths: [IndexPath] = []
                    for i in oldCount..<newCount {
                        indexPaths.append(IndexPath(row: i, section: 0))
                    }
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                } completion: { _ in }
            }
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
      guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        ImagesListService.shared.changeLike(photoId: photo.id, isLike: photo.isLiked) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.photos = ImagesListService.shared.photos
                }
                cell.setIsLiked(photo: self.photos[indexPath.row])
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                let controller = UIAlertController(title: "Что-то пошло не так", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                controller.addAction(action)
                self.present(controller, animated: true)
            }
        }
    }
}
