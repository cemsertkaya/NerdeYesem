//
//  photoGalleryController.swift
//  NerdeYesem
//
//  Created by Cem Sertkaya on 12.11.2020.
//  Copyright © 2020 Cem Sertkaya. All rights reserved.
//

import UIKit
import SwiftPhotoGallery

//I implemented Swift
class photoGalleryController: UIViewController,SwiftPhotoGalleryDataSource, SwiftPhotoGalleryDelegate
{
    var photos = [UIImage]()
    var photosUrl = [String]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
        for item in photosUrl
        {
            let url = URL(string: item as! String)
            let data = try? Data(contentsOf:url!)
            let image = UIImage(data: data!)
            photos.append(image!)
        }
        gallery.backgroundColor = UIColor.black
        gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
        gallery.currentPageIndicatorTintColor = UIColor.white
        gallery.hidePageControl = false
        present(gallery, animated: true, completion: nil)
        
    }
    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        return photos.count
    }

    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
        return photos[forIndex]
    }
    
    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        dismiss(animated: true, completion: nil)
    }
    
}
