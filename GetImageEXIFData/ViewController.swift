//
//  ViewController.swift
//  GetImageEXIFData
//
//  Created by SomnicsAndrew on 2023/10/30.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ImageDataExtractor.shared.startExtractImage(image: UIImage(named: "testImage")!)
    
        PhotoLibraryManager().fetchPhotos()
    }


}

