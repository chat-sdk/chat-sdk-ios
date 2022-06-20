//
//  PreviewView.swift
//  ChatK!t
//
//  Created by Ben on 10/06/2022.
//

import Foundation
import FFCircularProgressView

open class PreviewView: UIView {
    
    @IBOutlet weak var progressView: FFCircularProgressView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet open weak var imageView: UIImageView!
    @IBOutlet open weak var playButton: UIButton!
    @IBOutlet open weak var timeLabel: UILabel!
    
    open var play: (() -> Void)?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        playButton.isHidden = true
        timeLabel.isHidden = true
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit

        activityView.isHidden = true
        
    }
    
    @IBAction func playButtonClicked(_ sender: Any) {
        play?()
    }
    
    open func bind(item: PreviewItem) {
        if let asset = item.asset {
            // Get the thumbnail
            imageView.image = item.image
            timeLabel.text = AudioMessageView.format(time: item.duration)
            timeLabel.isHidden = false
            playButton.isHidden = false
        }
        else if let image = item.image {
            imageView.image = image
            timeLabel.isHidden = true
            playButton.isHidden = true
        }

//        if item.type == .video && item.asset == nil {
//            activityView.isHidden = false
//        }
    }
    
    public func setProgress(progress: Double, importing: Bool = false) {
        if progress >= 0 && progress < 1 {
            progressView.progress = CGFloat(progress)
            playButton.isHidden = true
            activityView.isHidden = true
            progressView.isHidden = false
        } else {
            if importing {
                progressView.isHidden = true
//                playButton.isHidden = true
                activityView.isHidden = false
                activityView.startAnimating()
            } else {
                progressView.isHidden = true
                activityView.isHidden = true
//                playButton.isHidden = false
            }
        }
    }

}
