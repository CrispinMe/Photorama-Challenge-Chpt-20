//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Crispin Lloyd on 06/04/2020.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Foundation
import UIKit


class PhotosViewController: UIViewController {
    
    @IBOutlet var interestingPhotosButton: UIButton!
    @IBOutlet var recentPhotosButton: UIButton!

    
    
    @IBOutlet var imageView: UIImageView!
    
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func updateImageView(for photo: Photo) {
        store.fetchImage(for: photo) {
            (imageResult) -> Void in
            
            switch imageResult {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error downloading image: \(error)")
            }
        }
    }
    
    @IBAction func interestingPhotosButton_Click(){
            store.fetchInterestingPhotos {
                (photosResult) -> Void in
                
                switch photosResult {
                case let .success(photos):
                    print("Successfully found \(photos.count) photos")
                    
                    if let firstPhoto = photos.first {
                        self.updateImageView(for: firstPhoto)
                    }
                    
                case let .failure(error):
                    print("Error fetching interesting photos: \(error)")
                }
            }

        }
    
    @IBAction func recentPhotosButton_Click(){
        store.fetchRecentPhotos {
            (photosResult) -> Void in
            
            switch photosResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos")
                
                if let firstPhoto = photos.first {
                    self.updateImageView(for: firstPhoto)
                }
                
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
            }
        }

    }

    
    

}
