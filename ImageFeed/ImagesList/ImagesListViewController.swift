//
//  ViewController.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 31.03.2026.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let inset: CGFloat = 12
        static let defaultCellHeight: CGFloat = 200
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private properties
    private let currentDate = Date()
    private let photoNames: [String] = Array(0..<20).map{ "\($0)" }
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
        
        let image = UIImage(named: photoNames[indexPath.row])
        viewController.image = image
    }
    
    private func configCell(
        for cell: ImagesListCell,
        with indexPath: IndexPath
    ) {
        guard let image = UIImage(named: photoNames[indexPath.row]) else {
            return
        }
        let buttonIconName = indexPath.row % 2 == 0 ? "Active Like" : "Inactive Like"
        let buttonIcon = UIImage(named: buttonIconName)

        cell.cellImageView.image = image
        cell.likeButton.setImage(buttonIcon, for: .normal)
        cell.dateLabel.text = dateFormatter.string(from: currentDate)
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoNames.count
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
        guard let image = UIImage(named: photoNames[indexPath.row]) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
}
