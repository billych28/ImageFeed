//
//  ViewController.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 31.03.2026.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController, ErrorHandler {
    
    // MARK: - Constants
    private enum Constants {
        static let inset: CGFloat = 12
        static let defaultCellHeight: CGFloat = 200
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private properties
    private let imagesListService = ImagesListService.shared
    private let currentDate = Date()
    private var photos: [Photo] = []
    private var imagesListServiceObserver: NSObjectProtocol?
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupImagesListObserver()
        imagesListService.fetchPhotosNextPage { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                updateTableViewAnimated()
            case .failure(let error):
                self.handleError(controller: self, error: error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case GlobalConstants.showSingleImageSegueIdentifier:
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
        
        // TODO заменить на передачу url
        viewController.image = UIImage(named: "Image stub")
    }
    
    private func configCell(
        for cell: ImagesListCell,
        with indexPath: IndexPath
    ) {
        guard let imageURL = URL(string: photos[indexPath.row].urls.thumb) else {
            return
        }
        let buttonIconName = indexPath.row % 2 == 0 ? "Active Like" : "Inactive Like"
        let buttonIcon = UIImage(named: buttonIconName)

        cell.cellImageView.kf.indicatorType = .activity
        cell.cellImageView.kf.setImage(
            with: imageURL,
            placeholder: UIImage(named: "Image stub"),
            options: []
        ) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                print("")
                tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print("Ошибка при загрузке картинки ленты: \(error)")
            }
        }
        cell.likeButton.setImage(buttonIcon, for: .normal)
        cell.dateLabel.text = dateFormatter.string(from: currentDate)
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        
        photos = imagesListService.photos
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateTableViewAnimated()
        return photos.count
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
            withIdentifier: GlobalConstants.showSingleImageSegueIdentifier,
            sender: indexPath
        )
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: "Image stub") else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(_):
                    updateTableViewAnimated()
                case .failure(let error):
                    handleError(controller: self, error: error)
                }
            }
        }
    }
    
}
