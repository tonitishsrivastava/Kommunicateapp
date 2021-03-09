//
//  DetailViewController.swift
//  Kommunicate app
//
//  Created by Nitish Srivastava on 09/03/21.
//

import UIKit
import Kingfisher
import CoreML
import Vision

class DetailViewController: UIViewController {

    // Views inside this controller
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Get selected image data
    var selectedImageData: ImageData!
    // Get selected image
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        detailLbl.text = AppConstant.LOADING_MESSAGE
        selectedImageView.image = selectedImage
        selectedImageView.setContentBasedOnImage(image: selectedImage, height: imageHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpDetailNavigationTitle(navTitle: selectedImageData.byUser!)
        let url = URL(string: selectedImageData.regularUrl!)
        setUpAndIdentifyImage(url: url, placeHolderImage: selectedImage)
    }
    
    func setUpAndIdentifyImage(url: URL?, placeHolderImage: UIImage){
        imageHeight.constant = UIScreen.main.bounds.height/1.5
        selectedImageView.kf.setImage(with: url, placeholder: selectedImage, completionHandler : { image, error, cacheType, imageURL in
            if let img = image {
                self.selectedImageView?.setContentBasedOnImage(image: img, height: self.imageHeight)
                
                guard let ciImage = CIImage(image: img) else {
                    // couldn't convert UIImage to CIImage
                    return
                }
                
                self.detectScene(image: ciImage)
                self.activityIndicator.stopAnimating()
            }
            
        })
        selectedImageView.layer.cornerRadius = 8
        selectedImageView.clipsToBounds = true
    }
    
    func detectScene(image: CIImage) {
        detailLbl.text = AppConstant.DETECTING_MESSAGE
        
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: Inceptionv3(configuration: MLModelConfiguration()).model) else {
            // can't load Places ML model
            return
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    // unexpected result type from VNCoreMLRequest
                    return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.detailLbl.text = "\(Int(topResult.confidence * 100))\(AppConstant.PERCENTAGE_TEXT)\(topResult.identifier)"
                
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }

}
