//
//  ImageDataExtractor.swift
//  GetImageEXIFData
//
//  Created by SomnicsAndrew on 2023/10/30.
//
import ImageIO
import UIKit
import CoreLocation
import Photos

class ImageDataExtractor {
    static var shared = ImageDataExtractor()

    func startExtractImage(image: UIImage) {
        if let exifData = getEXIFData(from: image) {
            print(exifData)
        }
    }

    func getAssetGPSLocation(asset: PHAsset) {
        getImageLocation(asset: asset) { locationCoordinate2D in
            if let location = locationCoordinate2D {
                print("Latitude: \(location.latitude), Longitude: \(location.longitude)")
            } else {
                print("Location data not available for this image.")
            }
        }
    }

    func getEXIFData(from image: UIImage) -> [String: Any]? {
        // Ensure the image has data
        guard let imageData = image.pngData() else { return nil }
        
        // Create a CGImageSource from the image data
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }

        // Get the image properties from the image source
        let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary?

        // Extract EXIF data
        let exifData = imageProperties?[kCGImagePropertyExifDictionary] as? [String: Any]
        
        
        let latitude = imageProperties?[kCGImagePropertyGPSLatitude] as? String
        let longitude = imageProperties?[kCGImagePropertyGPSLongitude] as? String

        print("test11 longitude, latitude: \(longitude), \(latitude)")
        return exifData
    }
    
    
    func getImageLocation(asset: PHAsset, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        // Make sure the asset has location data
        guard let location = asset.location else {
            completion(nil)
            return
        }
        
        // Get the coordinates from the location
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        completion(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }
}
