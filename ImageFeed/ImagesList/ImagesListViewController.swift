//
//  ViewController.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 31.03.2026.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    
    func updateTableViewAnimated()
    func onFetchFailed(with error: Error)
    func showProgress(isShowing: Bool)
}

final class ImagesListViewController: UIViewController, ErrorHandler, ImagesListViewControllerProtocol {
    
    // MARK: - Constants
    private enum Constants {
        static let inset: CGFloat = 12
        static let defaultCellHeight: CGFloat = 200
        static let showSingleImageSegueIdentifier = "ShowSingleImage"
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: ImagesListPresenterProtocol?
    
    // MARK: - Private properties
    private let currentDate = Date()
    private var photos: [Photo] = []
    private var imagesListServiceObserver: NSObjectProtocol?
    private var isLoading = false
    private lazy var dateFormatter = ISO8601DateFormatter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupImagesListObserver()
        presenter?.fetchNextPage()
        tableView.isPrefetchingEnabled = false
    }
    
    // MARK: - Public methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.showSingleImageSegueIdentifier:
            handleSingleImageViewSegue(segue: segue, sender: sender)
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(
            top: Constants.inset,
            left: 0,
            bottom: Constants.inset,
            right: 0
        )
    }
    
    private func setupImagesListObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListServiceConstants.didChangeNotification,
                object: nil,
                queue: .main
            ) {
                [weak self] _ in
                self?.updateTableViewAnimated()
            }
    }
    
    func updateTableViewAnimated() {
        guard let presenter else { return }
        let loadedPhotos = presenter.getPhotos()
        
        let oldCount = photos.count
        let newCount = loadedPhotos.count
        photos = loadedPhotos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func onFetchFailed(with error: Error) {
        handleError(controller: self, error: error)
    }
    
    func showProgress(isShowing: Bool) {
        if isShowing {
            UIBlockingProgressHUD.show()
        } else {
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func handleSingleImageViewSegue(
        segue: UIStoryboardSegue,
        sender: Any?
    ) {
        guard
            let viewController = segue.destination as? SingleImageViewController,
            let indexPath = sender as? IndexPath
        else {
            assertionFailure("Invalid segue destination")
            return
        }
        
        let fullImageURL = photos[indexPath.row].urls.full
        viewController.fullImageURL = fullImageURL
    }
    
    private func configCell(
        for cell: ImagesListCell,
        with indexPath: IndexPath
    ) {
        guard let imageURL = URL(string: photos[indexPath.row].urls.small) else {
            return
        }
        let photo = photos[indexPath.row]

        cell.cellImageView.kf.indicatorType = .activity
        cell.cellImageView.kf.setImage(
            with: imageURL,
            placeholder: UIImage(resource: .imageStub),
            options: []
        ) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                print("")
                tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure:
                Logger.shared.log(method: "configCell", error: "Image load error")
            }
        }
        cell.setIsLiked(photo.isLiked)
        cell.setDateLabel(with: dateFormatter.date(from: photo.createdAt ?? ""))
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.Constants.reuseIdentifier,
            for: indexPath
        )
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        imageListCell.delegate = self
        
        return imageListCell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(
            withIdentifier: Constants.showSingleImageSegueIdentifier,
            sender: indexPath
        )
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        
        if photos.isEmpty {
            let image = UIImage(resource: .imageStub)
            let imageWidth = image.size.width
            let scale = imageViewWidth / imageWidth
            let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
            return cellHeight
        } else {
            let photo = photos[indexPath.row]
            let scale = imageViewWidth / CGFloat(photo.width)
            let cellHeight = CGFloat(photo.height) * scale + imageInsets.top + imageInsets.bottom
            return cellHeight
        }
        
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == photos.count {
            presenter?.fetchNextPage()
        }
    }
    
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        presenter?.changeLike(id: photo.id, isLiked: photo.isLiked) { [weak self] in
            guard
                let self,
                let presenter
            else { return }
            
            self.photos = presenter.getPhotos()
            cell.setIsLiked(self.photos[indexPath.row].isLiked)
        }
    }
}
