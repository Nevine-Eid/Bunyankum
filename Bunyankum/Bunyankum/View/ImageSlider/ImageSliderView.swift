//
//  ImageSlide.swift
//  Exppo App
//
//  Created by Mina Thabet on 12/08/2020.
//  Copyright © 2020 HardTask. All rights reserved.
//


import UIKit
import ImageSlideshow
import SKPhotoBrowser

class ImageSliderView: UIView {

    @IBOutlet var bottomView: UIView!
    @IBOutlet var slider: ImageSlideshow!
    
    var images: [String] = ["https://fptshop.com.vn/Uploads/images/2015/Tin-Tuc/NHT/Thang5-2017/logo-Apple.jpg",
                            "https://img.ibxk.com.br///2014/08/20/20145753165590-t1200x480.jpg"]
    
    
    var onClickAction: (()->())? = nil
    
    var shouldOpenGallery: Bool = false
    var parent: UIViewController!
    var imagesLinks = [SKPhoto]()
    var timeInterval = 0
    var verticalPosotion: PageIndicatorPosition.Vertical = .under
    

    override func awakeFromNib() {
        super.awakeFromNib()
         initImageSlider()
        
    }
    
    
    
    /// init slider with the given images
    ///
    /// - Parameters:
    ///   - images: array of image urls
    ///   - openGallery: determine if should open the image gallery when clicking on any of the images or not, true for open the gallery
    func initWith(images: [String], shouldOpenGallery openGallery: Bool = false, withController controller: UIViewController,withTime time: Int,position:  PageIndicatorPosition.Vertical = .bottom) {
        self.images = images
        self.shouldOpenGallery = openGallery
        self.parent = controller
        self.timeInterval = time
        self.verticalPosotion = position
        
        imagesLinks.removeAll()
        for img in  images {
            
            let photo = SKPhoto.photoWithImageURL(img)
            photo.shouldCachePhotoURLImage = true // you can use image cache by true(NSCache)
            imagesLinks.append(photo)
        }
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapOnAd))
        slider.addGestureRecognizer(gestureRecognizer)
        initImageSlider()
        

        updateSliderInputs()
    }
}

//MARK: - ImageSlideShow
extension ImageSliderView {
    
    /// init image slider
    func initImageSlider() {
        slider.contentScaleMode = .scaleAspectFill
        slider.slideshowInterval = Double(timeInterval)
        slider.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: verticalPosotion)
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = hexStringToUIColor(hex: "D1BEB1")
        pageIndicator.pageIndicatorTintColor = hexStringToUIColor(hex: "EFEDE7")
        slider.pageIndicator = pageIndicator
        
        slider.activityIndicator = DefaultActivityIndicator()
        
        updateSliderInputs()
        
        slider.backgroundColor = hexStringToUIColor(hex: "ffffff")
        slider.bringSubviewToFront(bottomView)
    }
    
    func startTimer() {
        slider.unpauseTimer()
    }
    
    func stopTimer() {
        slider.pauseTimer()
    }
    
    
    @objc func didTapOnAd() {
        print("select image at index: \(slider.currentPage)")
        
        if imagesLinks.count > 0{
             // 2. create PhotoBrowser Instance, and present.
             let browser = SKPhotoBrowser(photos: imagesLinks)
             browser.initializePageIndex(slider.currentPage)
             parent.present(browser, animated: true, completion: {})
         }
        
        onClickAction?()
    }
    
    
    /// init image slider inputs from iamges array
    fileprivate func updateSliderInputs() {
        var inputs: [SDWebImageSource] = []
        
        for image in images {
            if let input = SDWebImageSource(urlString: image, placeholder: UIImage(named: "home_slider")) {
                inputs.append(input)
            }
        }
        
        slider.setImageInputs(inputs)
    }
}
