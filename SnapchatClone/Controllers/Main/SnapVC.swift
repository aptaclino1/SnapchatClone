//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Messiah on 11/10/23.
//

import UIKit
import ImageSlideshow
import Kingfisher


class SnapVC: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var selectedSnap: Snap?
    var inputArray = [KingfisherSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: self.view.bounds)
             backgroundImage.image = UIImage(named: "background")
             backgroundImage.contentMode = .scaleAspectFill
             self.view.addSubview(backgroundImage)
             self.view.sendSubviewToBack(backgroundImage)
        
      
        
        if let snap = selectedSnap {
            timeLabel.text = "Time Left: \(snap.timeDifference)"
            
            for imageUrl in snap.imageUrlArray {
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10 , width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
            imageSlideShow.backgroundColor = .clear
            
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
            pageIndicator.pageIndicatorTintColor = UIColor.black
            imageSlideShow.pageIndicator = pageIndicator
            
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLabel)
        }
         
    }
    
    
}
