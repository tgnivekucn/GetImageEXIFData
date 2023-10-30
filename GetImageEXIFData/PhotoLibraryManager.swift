//
//  PhotoLibraryManager.swift
//  GetImageEXIFData
//
//  Created by SomnicsAndrew on 2023/10/30.
//

import UIKit
import Photos

class PhotoLibraryManager {

    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        case .restricted, .denied, .limited:
            completion(false)
        @unknown default:
            completion(false)
        }
    }

    func fetchPhotos() {
        // Ensure we have permission to access the photo library
        checkPhotoLibraryPermission { [weak self] hasPermission in
            guard hasPermission, let self = self else { return }
            
            // Fetch the photos
            let fetchOptions = PHFetchOptions()
            let sortOrder = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchOptions.sortDescriptors = sortOrder
            
            let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            assets.enumerateObjects { (asset, index, stop) in
                ImageDataExtractor.shared.getAssetGPSLocation(asset: asset)
            }
        }
    }

    private func fetchImage(for asset: PHAsset) {
        // Retrieve the image for the asset
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            if let data = data, let image = UIImage(data: data) {
                // Use the image
                DispatchQueue.main.async {
                    // Update your UI with the image on the main thread
                }
            }
        }
    }
}
