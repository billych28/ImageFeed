//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 09.04.2026.
//
import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController, ErrorHandler {
    // MARK: - Constants
    private enum Constants {
        static let minZoom = 0.1
        static let maxZoom = 1.25
    }
    
    // MARK: - IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Properties
    var fullImageURL: String? {
        didSet {
            guard isViewLoaded, let fullImageURL else { return }
            
            setImageView()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = Constants.minZoom
        scrollView.maximumZoomScale = Constants.maxZoom
        scrollView.delegate = self
        setImageView()
    }
    
    // MARK: - IBAction
    @IBAction func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @IBAction func didTapShareButton() {
        guard let fullImageURL else { return }
        let share = UIActivityViewController(
            activityItems: [imageView.image ?? UIImage()],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    private func setImageView() {
        guard
            let fullImageURL,
            let url = URL(string: fullImageURL)
        else { return }

        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(let error):
                handleError(controller: self, error: error)
            }
        }
    }
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
