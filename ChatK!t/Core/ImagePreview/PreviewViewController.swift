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
import WPMediaPicker
import AVKit
import RXPromise
import MBProgressHUD
import YPImagePicker

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
        if let asset = asset {
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

open class PreviewViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    open var fake: YPImagePicker?

    open var items = [PreviewItem]()
    open var views = [PreviewItem: PreviewView]()
    
    open var hud: MBProgressHUD?
    
    open var processing = [WPMediaAsset]()
    open var processed = [WPMediaAsset]()

    open var exporting = [WPMediaAsset]()
    open var exported = [WPMediaAsset]()
    
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
        
        var config = YPImagePickerConfiguration()
        
        config.isScrollToChangeModesEnabled = false
        config.onlySquareImagesFromCamera = false
        config.usesFrontCamera = false
        config.showsPhotoFilters = false
        config.showsVideoTrimmer = true

        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "AliyoopAlbum"

        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.hidesCancelButton = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
//        config.bottomMenuItemSelectedColour = UIColor(r: 38, g: 38, b: 38)
//        config.bottomMenuItemUnSelectedColour = UIColor(r: 153, g: 153, b: 153)
        config.maxCameraZoomFactor = 1.0
        
        config.library.minNumberOfItems = 1
        config.library.maxNumberOfItems = 8
        config.library.defaultMultipleSelection = false
        config.library.skipSelectionsGallery = true
        config.library.preSelectItemOnMultipleSelection = false
        
        config.video.minimumTimeLimit = 0
        config.video.libraryTimeLimit = 60
        config.video.fileType = .mov
        config.video.compression = AVAssetExportPresetHighestQuality
        
        if mode == .image {
            config.startOnScreen = .library
            config.screens = [.library, .photo]
            config.library.mediaType = .photo
        }
        // Video
        if mode == .video {
            config.startOnScreen = .library
            config.screens = [.library, .video]
            config.library.mediaType = .video
        }
        
        fake = YPImagePicker(configuration: config)
        fake?.didFinishPicking(completion: { [weak self] items, cancelled in
            DispatchQueue.main.async {
                if let photo = items.singlePhoto {
                    if let asset = photo.asset {
                        self?.addOrUpdate(id: asset.identifier(), image: photo.image)
                    }
                }
                else if let video = items.singleVideo {
                    if let phasset = video.asset {
                        PHImageManager.default().requestAVAsset(forVideo: phasset, options: nil, resultHandler: { asset, audiomix, _ in
                            DispatchQueue.main.async {
                                if let asset = asset as? AVURLAsset {
                                    self?.addOrUpdate(id: phasset.identifier(), asset: asset, image: video.thumbnail, duration: phasset.duration)
                                }
                            }
                        })
                    }
                } else {
                    for item in items {
                        switch item {
                        case .photo(let photo):
                            if let asset = photo.asset {
                                self?.addOrUpdate(id: asset.identifier(), image: photo.image)
                            }
                        case .video(let video):
                            if let phasset = video.asset {
                                PHImageManager.default().requestAVAsset(forVideo: phasset, options: nil, resultHandler: { asset, audiomix, _ in
                                    DispatchQueue.main.async {
                                        if let asset = asset as? AVURLAsset {
                                            self?.addOrUpdate(id: phasset.identifier(), asset: asset, image: video.thumbnail, duration: phasset.duration)
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
                self?.hidePicker(duration: 0.5)
                if cancelled && items.isEmpty {
                    self?.dismiss(animated: true)
                }
            }
        })
        
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

    public func addOrUpdate(id: String, asset: AVURLAsset?, image: UIImage? = nil, duration: TimeInterval) {
        let item = item(for: id) ?? PreviewItem(identifier: id, asset: asset, duration: duration)
        item.setAsset(asset)
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
                let fileURL = URL(fileURLWithPath: asset.url.path)
                
                let player = AVPlayer(url: fileURL.absoluteURL)
                
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

    public func thumbnail(_ url: URL) {
        let asset = AVURLAsset(url: url)
        
//        let ig = ALAssetImage
        
        
    }
    
//    public func mediaPickerControllerDidCancel(_ picker: WPMediaPickerViewController) {
//
//        processing.removeAll()
//        processed.removeAll()
//        exporting.removeAll()
//        exported.removeAll()
//
//        if items.isEmpty {
//            dismiss(animated: true)
//        } else {
//            hidePicker(duration: 0.5)
//        }
//    }
//
//    public func mediaPickerController(_ picker: WPMediaPickerViewController, didFinishPicking assets: [WPMediaAsset]) {
//
//        processing.removeAll()
//        processing.append(contentsOf: assets)
//        processed.removeAll()
//        exporting.removeAll()
//        exported.removeAll()
//
//        // Disable send button
//        hud = MBProgressHUD.showAdded(to: view, animated: true)
//        updateProcessing()
//
//        sendButton.isEnabled = false
//
//        let promise = addAssets(assets: assets)?.thenOnMain({ [weak self] success in
//            self?.finishedProcessing()
//            return success
//        }, { [weak self] error in
//            self?.finishedProcessing(error: error)
//            return error
//        })
//
//        if promise == nil {
//            finishedProcessing()
//        }
//
//        picker.clearSelectedAssets(false)
////        picker.dismiss(animated: true)
////        fake?.view.isHidden = true
//        hidePicker(duration: 0.5)
//  }
                                 
    public func updateProcessing() {
        if !processing.isEmpty && processing.count != processed.count {
            hud?.label.text = String(format: t(Strings.processed_of_), processed.count, processing.count)
        } else if !exporting.isEmpty && exporting.count != exported.count {
            hud?.label.text = String(format: t(Strings.exported_of_), exported.count, exporting.count)
        }
    }
        
    public func finishedProcessing(error: Error? = nil) {
        hud?.hide(animated: true)
        sendButton.isEnabled = true
        if let error = error {
            showError(message: error.localizedDescription)
        }
    }
    
//    public func addAssets(assets: [WPMediaAsset]) -> RXPromise? {
//        var promises = [RXPromise]()
//
//        for asset in assets {
//            if asset.assetType() == .image {
//                promises.append(addImageAsset(asset: asset))
//            }
//            if asset.assetType() == .video {
//                promises.append(addVideoAsset(asset: asset))
//            }
//        }
//
//        return RXPromise.all(promises)
//    }
    
//    public func addImageAsset(asset: WPMediaAsset) -> RXPromise {
//        let promise = RXPromise()
//
//        // TODO: Check this... is it too small?
//        let size = scrollView.frame.size
//        asset.image(with: size, completionHandler: { [weak self] image, error in
//            DispatchQueue.main.async {
//                if let image = image {
//                    self?.addOrUpdate(id: asset.identifier(), image: image)
//                    if image.size.equalTo(asset.pixelSize()) {
//                        self?.markAsProcessed(asset: asset)
//                        promise.resolve(withResult: image)
//                    }
//                }
//                if let error = error {
//                    self?.markAsProcessed(asset: asset)
//                    self?.showError(message: error.localizedDescription)
//                    promise.reject(withReason: error)
//                }
//            }
//        })
//
//        return promise
//    }

    public func markAsProcessing(asset: WPMediaAsset) {
        processing.append(asset)
        updateProcessing()
    }

    public func markAsProcessed(asset: WPMediaAsset) {
        processed.append(asset)
        updateProcessing()
    }

    public func markAsExporting(asset: WPMediaAsset) {
        exporting.append(asset)
        updateProcessing()
    }

    public func markAsExported(asset: WPMediaAsset) {
        exported.append(asset)
        updateProcessing()
    }

//    public func addVideoAsset(asset: WPMediaAsset) -> RXPromise {
//        let promise = RXPromise()
//
//        // TODO: Check this... is it too small?
//        let size = scrollView.frame.size
//
//        asset.image(with: size, completionHandler: { [weak self] image, error in
//            DispatchQueue.main.async {
//                if let image = image {
//                    self?.addOrUpdate(id: asset.identifier(), asset: nil, image: image, duration: asset.duration())
//                }
//                if let error = error {
//                    self?.showError(message: error.localizedDescription)
//                }
//            }
//        })
//
//        print("Asset Add: " + asset.identifier())
//        asset.videoAsset(completionHandler: { [weak self] video, error in
//
//            print("Asset Complete: " + asset.identifier())
//
//            if let video = video {
//                if let video = video as? AVURLAsset {
//                    DispatchQueue.main.async {
//                        self?.addOrUpdate(id: asset.identifier(), asset: video, duration: asset.duration())
//                        self?.markAsProcessed(asset: asset)
//                        promise.resolve(withResult: video)
//                        promise.reject(withReason: nil)
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self?.markAsProcessed(asset: asset)
//                    }
//                    if let exportSession = AVAssetExportSession(asset: video, presetName: AVAssetExportPresetHighestQuality) {
//
//                        // We need to export too
//                        DispatchQueue.main.async {
//                            self?.markAsExporting(asset: asset)
//                        }
//                        let fileURL = DownloadManager.downloadPath().appendingPathComponent(UUID().uuidString + ".mov")
//
//                        exportSession.outputURL = fileURL
//                        exportSession.outputFileType = .mov
//                        exportSession.exportAsynchronously(completionHandler: {
//                            let video = AVURLAsset(url: fileURL)
//                            DispatchQueue.main.async {
//                                self?.addOrUpdate(id: asset.identifier(), asset: video, duration: asset.duration())
//                                self?.markAsExported(asset: asset)
//                                promise.resolve(withResult: video)
//                            }
//                        })
//                    } else {
//                        promise.reject(withReason: nil)
//                    }
//
//                }
//            } else if let error = error {
//                self?.showError(message: error.localizedDescription)
//                self?.markAsProcessed(asset: asset)
//                promise.reject(withReason: error)
//            } else {
//                print("Don't go here")
//            }
//        })
//
//        return promise
//    }
    
    
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

}

