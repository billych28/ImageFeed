//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 03.04.2026.
//
import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    // MARK: - Constants
    enum Constants {
        static let reuseIdentifier = "ImagesListCell"
        static let gradientOffset: CGFloat = 16
        static let likeButtonIdentifier = "LikeButton"
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    // MARK: - Public properties
    var delegate: ImagesListCellDelegate?
    
    // MARK: - Private Properties
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        
        gradient.colors = [
            UIColor.ypBlack.withAlphaComponent(0.2).cgColor,
            UIColor.clear.cgColor
        ]
            
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
            
        return gradient
    }()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImageView.layer.addSublayer(gradientLayer)
        likeButton.accessibilityIdentifier = Constants.likeButtonIdentifier
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.kf.cancelDownloadTask()
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let image = UIImage(resource: isLiked ? .activeLike : .inactiveLike)
        likeButton.setImage(image, for: .normal)
    }
    
    func setDateLabel(with date: Date?) {
        if let date {
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.isHidden = true
        }
    }
    
    // MARK: - Private Methods
    private func updateGradientFrame() {
        let height = cellImageView.bounds.height - dateLabel.bounds.height
        let width = cellImageView.bounds.width - dateLabel.bounds.width
        
        gradientLayer.frame = CGRect(
            x: 0,
            y: height - 16,
            width: width,
            height: height
        )
    }
    
}
