//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 03.04.2026.
//
import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - Constants
    enum Constants {
        static let reuseIdentifier = "ImagesListCell"
        static let gradientOffset: CGFloat = 16
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
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
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImageView.layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
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
