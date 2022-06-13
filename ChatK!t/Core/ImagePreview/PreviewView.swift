//
//  PreviewView.swift
//  ChatK!t
//
//  Created by Ben on 10/06/2022.
//

import Foundation

open class PreviewView: UIView {
    
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
    }
    
    @IBAction func playButtonClicked(_ sender: Any) {
        play?()
    }
    
    open func bind(item: PreviewItem) {
        activityView.isHidden = true
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
        if item.type == .video && item.asset == nil {
            activityView.isHidden = false
        }
    }

}
