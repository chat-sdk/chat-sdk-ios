//
//  PreviewViewController.swift
//  ChatSDK
//
//  Created by Ben on 04/05/2022.
//

import Foundation
import UIKit
import ZLImageEditor
import NextGrowingTextView
import AVFoundation
import AVKit
import RXPromise
import MBProgressHUD
import TLPhotoPicker
import Photos
import SwiftUI

public enum MediaType {
    case image, video
}

open class PreviewItem: NSObject {
    
    open var id: String
    open var type: MediaType
    open var image: UIImage?
    open var asset: AVURLAsset?
    open var duration: TimeInterval = 0
    
    public init(identifier: String, image: UIImage?) {
        id = identifier
        self.type = .image
        self.image = image
        super.init()
    }

    public init(identifier: String, asset: AVURLAsset?, duration: TimeInterval) {
        id = identifier
        self.duration = duration
        self.type = .video
        super.init()
        setAsset(asset)
    }
    
    public func setAsset(_ asset: AVURLAsset?) {
        self.asset = asset
        if let asset = asset, image == nil {
            image = AssetHelper.thumbnailFor(asset: asset, time: 0)
        }
    }
    
    public static func == (lhs: PreviewItem, rhs: PreviewItem) -> Bool {
        return lhs.id == rhs.id
//        if let i1 = lhs.image, let i2 = rhs.image {
//            return i1.isEqual(i2)
//        }
//        if let a1 = lhs.asset, let a2 = rhs.asset {
//            return a1.isEqual(a2)
//        }
//        return false
    }
        
}

open class PreviewViewController: UIViewController, UIScrollViewDelegate, TLPhotosPickerViewControllerDelegate {
    
//    WPMediaPickerViewControllerDelegate

    
    open var imageView = UIImageView()
    
    @IBOutlet open weak var editButton: UIButton!
    @IBOutlet open weak var deleteButton: UIButton!
//    @IBOutlet weak var captionTextView: NextGrowingTextView!
    @IBOutlet open weak var scrollView: UIScrollView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet open weak var pageIndicator: UILabel!
    
    open var didFinishPickingImages: (([UIImage]) -> Void)?
    open var didFinishPickingVideos: (([AVURLAsset]) -> Void)?

    public let mode: MediaType
//    open var fake: WPNavigationMediaPickerViewController?
    open var fake: TLPhotosPickerViewController?

    open var items = [PreviewItem]()
    open var views = [PreviewItem: PreviewView]()
    
    open var hud: MBProgressHUD?
    
    open var processing = [PHAsset]()
    open var processed = [PHAsset]()
//
//    open var exporting = [WPMediaAsset]()
//    open var exported = [WPMediaAsset]()
    
    public init(mode: MediaType, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        self.mode = mode

        super.init(nibName: nibNameOrNil ?? String(describing: PreviewViewController.self), bundle: nibBundleOrNil ?? Bundle(for: PreviewViewController.self))
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        scrollView.addSubview(imageView)
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        
//        let options = WPMediaPickerOptions()
//        options.showMostRecentFirst = true
//        options.allowCaptureOfMedia = true
//        options.allowMultipleSelection = true
//        options.showSearchBar = false
//        options.showActionBar = false
//
//        if mode == .image {
//            options.filter = WPMediaType.image
//        }
//        // Video
//        if mode == .video {
//            options.filter = WPMediaType.video
//        }
        
        fake = TLPhotosPickerViewController()
        fake?.delegate = self
        fake?.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            
        }
        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 4
        configure.supportedInterfaceOrientations = .all

        if mode == .image {
            configure.allowedPhotograph = true
            configure.allowedVideoRecording = false
            configure.mediaType = .image
        }
        // Video
        if mode == .video {
            configure.allowedPhotograph = false
            configure.allowedVideoRecording = true
            configure.mediaType = .video
        }
        
        fake?.configure = configure
        
//        fake = YPImagePicker(configuration: config)
//        fake?.didFinishPicking(completion: { [weak self] items, cancelled in
//            DispatchQueue.main.async {
//                if let photo = items.singlePhoto {
//                    if let asset = photo.asset {
//                        self?.addOrUpdate(id: asset.identifier(), image: photo.image)
//                    }
//                }
//                else if let video = items.singleVideo {
//                    if let phasset = video.asset {
//                        PHImageManager.default().requestAVAsset(forVideo: phasset, options: nil, resultHandler: { asset, audiomix, _ in
//                            DispatchQueue.main.async {
//                                if let asset = asset as? AVURLAsset {
//                                    self?.addOrUpdate(id: phasset.identifier(), asset: asset, image: video.thumbnail, duration: phasset.duration)
//                                }
//                            }
//                        })
//                    }
//                } else {
//                    for item in items {
//                        switch item {
//                        case .photo(let photo):
//                            if let asset = photo.asset {
//                                self?.addOrUpdate(id: asset.identifier(), image: photo.image)
//                            }
//                        case .video(let video):
//                            if let phasset = video.asset {
//                                PHImageManager.default().requestAVAsset(forVideo: phasset, options: nil, resultHandler: { asset, audiomix, _ in
//                                    DispatchQueue.main.async {
//                                        if let asset = asset as? AVURLAsset {
//                                            self?.addOrUpdate(id: phasset.identifier(), asset: asset, image: video.thumbnail, duration: phasset.duration)
//                                        }
//                                    }
//                                })
//                            }
//                        }
//                    }
//                }
//                self?.hidePicker(duration: 0.5)
//                if cancelled && items.isEmpty {
//                    self?.dismiss(animated: true)
//                }
//            }
//        })
        
        // We use a fake picker so as this view is showing modally, it can
        // show the picker UI. at the
//        fake = WPNavigationMediaPickerViewController(options: options)
//        fake?.delegate = self
        
        if let fake = fake {
            addChild(fake)
            view.addSubview(fake.view)
            
            fake.view.keepInsets.equal = 0
            
            fake.didMove(toParent: self)
            fake.delegate = self;
        }
        
    }
    
//    public func centerImage() {
//        if let image = image {
//            let iw = image.size.width
//            let ih = image.size.height
//
//            let sw = UIScreen.main.bounds.width
//            let sh = UIScreen.main.bounds.height
//
//            // Get the AR of the image
//            let imageAR = iw / ih
//            let screenAR = sw / sh
//
//            var w = sw
//            var h = sh
//
//            if imageAR > screenAR {
//                h = w / imageAR
//            } else {
//                w = h * imageAR
//            }
//
//            imageView.keepWidth.equal = w
//            imageView.keepHeight.equal = h
//
//            // Get the dimensions of the image
//            scrollView.contentSize = CGSize(width: w, height: h)
//        }
//    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        centerImage()
//        center(scrollView: scrollView)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
//    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return imageView
//    }
//
//    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        center(scrollView: scrollView)
//    }
    
//    public func center(scrollView: UIScrollView) {
//        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
//        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
//        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
//    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
//        if let image = image {
//            ZLEditImageViewController.showEditImageVC(parentVC: self, animate: false, image: image, editModel: nil) { [weak self] (resImage, editModel) in
//                self?.setImage(resImage)
//            }
//        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        // Get the current page
        let index = currentPage()
        remove(index: index)
    }
    
    open func remove(index: Int) {
        if index >= 0 && index < items.count {
            items.remove(at: index)
        }
        if items.isEmpty {
            dismiss(animated: true)
        }
        updateScrollView()
    }
    
    public func addOrUpdate(id: String, image: UIImage) {
        let item = item(for: id) ?? PreviewItem(identifier: id, image: image)
        item.image = image
        addItem(item: item)
    }

    public func updateProgress(id: String, progress: Double, importing: Bool = false) {
        if let item = item(for: id) {
            if let view = views[item] {
                view.setProgress(progress: progress, importing: importing)
            }
        }
    }

    public func addOrUpdate(id: String, asset: AVURLAsset?, image: UIImage? = nil, duration: TimeInterval) {
        let item = item(for: id) ?? PreviewItem(identifier: id, asset: asset, duration: duration)
        item.setAsset(asset)
        if let image = image {
            item.image = image
        }
        item.duration = duration
        addItem(item: item)
    }

//    public func addOrUpdate(id: String, asset: PHAsset?, image: UIImage? = nil, duration: TimeInterval) {
//        let item = item(for: id) ?? PreviewItem(identifier: id, asset: asset, duration: duration)
//        item.setAsset(asset)
//        item.duration = duration
//        addItem(item: item)
//    }

    public func item(for id: String) -> PreviewItem? {
        for item in items {
            if item.id == id {
                return item
            }
        }
        return nil
    }
    
    public func addItem(item: PreviewItem) {
        var scrollTo = false
        if !items.contains(item) {
            items.append(item)
            scrollTo = true
        }
        updateScrollView(scrollTo: scrollTo)
    }
    
    public func updateScrollView(scrollTo:Bool = false) {
        var i = 0
        let width = Float(scrollView.frame.width)
        let height = Float(scrollView.frame.height)
        for item in items {
            
            var view = views[item]
            if view == nil {
                view = .fromNib()
                views[item] = view
                scrollView.addSubview(view!)
            }
            
            view?.play = { [weak self] in
                self?.playVideo(item: item)
            }
            
            view?.setViewFrameX(Float(i) * width)
            view?.setViewFrameY(0)
            view?.setViewFrameHeight(height)
            view?.setViewFrameWidth(width)

            view?.bind(item: item)
            i += 1
        }
        scrollView.contentSize = CGSize(width: CGFloat(width) * CGFloat(i), height: scrollView.frame.height)
        if scrollTo {
            scrollView.setContentOffset(CGPoint(x: CGFloat(width) * CGFloat(i - 1), y: 0), animated: false)
        }
        updateTextPosition()
    }
    
    open func playVideo(item: PreviewItem) {
        if let asset = item.asset {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
//                let fileURL = URL(fileURLWithPath: asset.url.path)
                
                let player = AVPlayer(url: asset.url)
                
                let playerController = AVPlayerViewController()
                playerController.player = player
                present(playerController, animated: true, completion: nil)
            } catch {
                showError(error: error)
            }
        }
    }
        
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
//        present(picker, animated: true, completion: nil)
//        fake?.view.isHidden = false
        showPicker(duration: 0.5)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if mode == .image {
            var images = [UIImage]()
            for item in items {
                if let image = item.image {
                    images.append(image)
                }
            }
            didFinishPickingImages?(images)
        }
        if mode == .video {
            var assets = [AVURLAsset]()
            for item in items {
                if let asset = item.asset {
                    assets.append(asset)
                }
            }
            didFinishPickingVideos?(assets)
        }
        dismiss(animated: true)
    }
    
    func fixImageOrientation(_ image: UIImage)->UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? image
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fake?.viewDidLayoutSubviews()
    }
    
    public func setDidFinishPicking(images callback: @escaping (([UIImage]) -> Void)) {
        didFinishPickingImages = callback
    }

    public func setDidFinishPicking(videos callback: @escaping (([AVURLAsset]) -> Void)) {
        didFinishPickingVideos = callback
    }
        
    public func finishedProcessing(error: Error? = nil) {
        hud?.hide(animated: true)
        sendButton.isEnabled = true
        if let error = error {
            showError(message: error.localizedDescription)
        }
    }
    
    public func hidePicker(duration: CGFloat = 0) {
        UIView.animate(withDuration: duration, delay: 0, animations: { [weak self] in
            self?.fake?.view.alpha = 0
        })
    }

    public func showPicker(duration: CGFloat = 0) {
        UIView.animate(withDuration: duration, delay: 0, animations: { [weak self] in
            self?.fake?.view.alpha = 1
        })
    }

    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateTextPosition()
    }
    
    public func updateTextPosition() {
        let count = items.count
        // Work out the page
        let page = currentPage() + 1
        
        if count == 0 {
            pageIndicator.text = ""
        } else {
            pageIndicator.text = String(format: "%i/%i", page, count)
        }
        
    }
    
    public func currentPage() -> Int {
        return Int(round(scrollView.contentOffset.x / scrollView.frame.width))
    }

    open func dismissPhotoPicker(withPHAssets: [PHAsset]) {
    }

    open func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // Get the assets
        for asset in withTLPHAssets {
            if asset.type == .photo || asset.type == .livePhoto {
                addImage(asset: asset)
            }
            if asset.type == .video {
                addVideo(asset: asset)
            }
        }
        hidePicker(duration: 0.5)
    }
    
    open func addImage(asset: TLPHAsset) {
        if let ph = asset.phAsset {
            processing.append(ph)
            updateSendingButton()

            let image = ph.thumbnailImage(size: thumbnailSize(2.0))
            addOrUpdate(id: ph.localIdentifier, image: image)
            
            asset.cloudImageDownload(progressBlock: { [weak self] progress in
                DispatchQueue.main.async {
                    self?.updateProgress(id: ph.localIdentifier, progress: progress)
                }
            }, completionBlock: { [weak self] image in
                self?.processed.append(ph)
                self?.updateSendingButton()
                DispatchQueue.main.async {
                    self?.updateProgress(id: ph.localIdentifier, progress: 1)
                    if let image = image {
                        self?.addOrUpdate(id: ph.localIdentifier, image: image)
                    }
                }
            })

        }
    }
    
    open func thumbnailSize(_ multiplier: CGFloat) -> CGSize {
//        return CGSize(width: scrollView.frame.size.width / 5.0, height: scrollView.frame.size.height / 5.0)
        return CGSize(width: scrollView.frame.size.width * multiplier, height: scrollView.frame.size.height * multiplier)
    }
    
    open func addVideo(asset: TLPHAsset) {
        if let ph = asset.phAsset {
            processing.append(ph)
            updateSendingButton()

//            let image = ph.thumbnailImage(size: thumbnailSize(0.1))
            DispatchQueue.main.async { [weak self] in
                self?.addOrUpdate(id: ph.localIdentifier, asset: nil, image: nil, duration: ph.duration)
            }
            
            ph.thumbnailImageAsync(size: thumbnailSize(2.0)).thenOnMain({ [weak self] success in
                if let image = success as? UIImage {
                    self?.addOrUpdate(id: ph.localIdentifier, asset: nil, image: image, duration: ph.duration)
                }
                return success
            }, nil)
            
            asset.exportVideoFile(options: nil, outputURL: nil, outputFileType: .mov, progressBlock: { [weak self] progress in
                DispatchQueue.main.async {
                    self?.updateProgress(id: ph.localIdentifier, progress: progress, importing: false)
                }
            }, completionBlock: { [weak self] url, mimeType in

                DispatchQueue.main.async {
                    self?.updateProgress(id: ph.localIdentifier, progress: 1.0, importing: true)
                }

                AssetHelper.asset(asset: ph).thenOnMain({ asset in
                    if let asset = asset as? AVURLAsset {
                        
                        self?.processed.append(ph)
                        self?.updateSendingButton()
                        
                        self?.updateProgress(id: ph.localIdentifier, progress: 1, importing: false)
                        self?.addOrUpdate(id: ph.localIdentifier, asset: asset, image: nil, duration: ph.duration)
                    } else {
                        // Need to export
//                        self?.importFailed(id: ph.localIdentifier, error: nil)
                    }
                    return asset
                }, { [weak self] error in
                    // Need to export
//                    self?.importFailed(id: ph.localIdentifier, error: error)
                    return error
                })
            })
        }
    }
    
    open func updateSendingButton() {
        DispatchQueue.main.async { [weak self] in
            if let this = self {
                if this.processing.count == this.processed.count {
                    self?.sendButton.isEnabled = true
                } else {
                    self?.sendButton.isEnabled = false
                }
            }
        }
    }
    
    open func importFailed(id: String, error: Error?) {
        var i = 0
        for item in items {
            if item.id == id {
                break
            }
            i += 1
        }
        remove(index: i)
    }

    open func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        let dismiss = withTLPHAssets.isEmpty && items.isEmpty
        fake?.selectedAssets.removeAll()
        fake?.collectionView.reloadData()
        return dismiss
    }

    open func dismissComplete() {
        
    }

    open func photoPickerDidCancel() {
        if items.isEmpty {
            dismiss(animated: true)
        } else {
            hidePicker(duration: 0.5)
        }
    }

    open func canSelectAsset(phAsset: PHAsset) -> Bool {
        return true
    }

    open func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        
    }

    open func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        
    }

    open func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        
    }
    
}

