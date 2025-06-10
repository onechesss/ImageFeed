//
//  ViewController.swift
//  ImageFeed
//
//  Created by oneche$$$ on 20.03.2025.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
}



final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    @IBOutlet private var tableView: UITableView!
    
    var presenter: ImagesListPresenterProtocol?
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        presenter = ImagesListPresenter()
        presenter?.view = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.async { self.updateTableViewAnimated() }
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("cleanPhotosInImagesList"), object: nil, queue: .main) { [weak self] _ in
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
        guard let presenter else { return }
        imageView.kf.setImage(with: URL(string: presenter.photos[indexPath.row].largeImageURL)) { result in
            switch result {
            case .success:
                let image = imageView.image
                viewController.image = image
                DispatchQueue.main.async { UIBlockingProgressHUD.dismiss() }
            case .failure:
                DispatchQueue.main.async { UIBlockingProgressHUD.dismiss() }
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
        guard let presenter else { return 0 }
        let imageSize = presenter.photos[indexPath.row].size
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
        guard let presenter else { return 0 }
        return presenter.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell , with: indexPath)
        
        func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
            guard let presenter else { return }
            let imageView = UIImageView()
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: URL(string: presenter.photos[indexPath.row].thumbImageURL), placeholder: UIImage(named: "placeholder")) { _ in
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            cell.delegate = self
            cell.imageInCell.image = imageView.image
            presenter.dateFormatter.dateStyle = .medium
            presenter.dateFormatter.timeStyle = .none
            if let date = presenter.photos[indexPath.row].createdAt {
                cell.dateLabel.text = presenter.dateFormatter.string(from: date)
            }
            else {
                cell.dateLabel.text = ""
            }
            if presenter.photos[indexPath.row].isLiked {
                cell.likeButton.setImage(UIImage(named: "like_button_on"), for: .normal)
            } else {
                cell.likeButton.setImage(UIImage(named: "like_button_off"), for: .normal)
            }
        }
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter else { return }
        if indexPath.row + 1 == presenter.photos.count {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
    
    func cleanPhotosAndTableViewInImagesListViewController() {
        guard var presenter else { return }
        presenter.photos = []
        tableView.reloadData()
    }
    
    private func updateTableViewAnimated() {
        guard var presenter else { return }
        let oldCount = presenter.photos.count
        let newCount = ImagesListService.shared.photos.count
        presenter.photos = ImagesListService.shared.photos
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
      guard let indexPath = tableView.indexPath(for: cell),
            var presenter
        else { return }
        let photo = presenter.photos[indexPath.row]
        UIBlockingProgressHUD.show()
        ImagesListService.shared.changeLike(photoId: photo.id, isLike: photo.isLiked) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    presenter.photos = ImagesListService.shared.photos
                }
                cell.setIsLiked(photo: presenter.photos[indexPath.row])
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
