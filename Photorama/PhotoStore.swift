//
//  PhotoStore.swift
//  Photorama
//
//  Created by Crispin Lloyd on 07/04/2020.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import UIKit

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error {
    case imageCreationError
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processPhotosRequest(data: data, response: response, error: error)
            OperationQueue.main.addOperation {
            completion(result)
            }
            
        }
        task.resume()

    }
    
    func fetchRecentPhotos(completion: @escaping (PhotosResult) -> Void) {
        
        let url = FlickrAPI.recentPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processPhotosRequest(data: data, response: response, error: error)
            OperationQueue.main.addOperation {
            completion(result)
            }
            
        }
        task.resume()

    }

    
    
    
    
    private func processPhotosRequest(data: Data?, response: URLResponse?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
            
        }
        
        //Print the status code and headerFields from the response object
        if let urlHTTPResponse =  response as? HTTPURLResponse {
            
            let httpStatusCode:Int = urlHTTPResponse.statusCode
            print("The status code for the response object returned by processPhotosRequest is: \(httpStatusCode)")
            
            let headerDictionary = urlHTTPResponse.allHeaderFields
            
            print("The header fields for the Response object returned by processPhotosRequest are:")
            
             for (key, header) in headerDictionary {
                print("Header key = \(key) Value = \(header)")
                }
            }

        
        return FlickrAPI.photos(fromJSON: jsonData)
        
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void)  {
        
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, response: response, error: error)
            OperationQueue.main.addOperation {
            completion(result)
            }
        }
        task.resume()
    }
    
    private func processImageRequest(data: Data?, response: URLResponse?, error: Error?) -> ImageResult {
        guard
        let imageData = data,
            let image = UIImage(data: imageData) else {
                
                //Couldn't create an image
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(PhotoError.imageCreationError)
                    
                }
        }
        
        //Print the status code and headerFields from the response object
        if let urlHTTPResponse =  response as? HTTPURLResponse {
            
            let httpStatusCode:Int = urlHTTPResponse.statusCode
            print("The status code for the response object returned by processImageRequest is: \(httpStatusCode)")
            
            let headerDictionary = urlHTTPResponse.allHeaderFields
            
            print("The header fields for the Response object returned by processImageRequest are:")
            
             for (key, header) in headerDictionary {
                print("Header key = \(key) Value = \(header)")
                }
            }

        
        return .success(image)
    }
    
            
}
