//
//  HomeViewController.swift
//  Kommunicate app
//
//  Created by Nitish Srivastava on 09/03/21.
//

import UIKit
import Kingfisher
import CHTCollectionViewWaterfallLayout
import SkeletonView


class HomeViewController: UIViewController, CHTCollectionViewDelegateWaterfallLayout {
    
    // To store image data
    var imageDataArray = [ImageData]() {
        didSet{
            self.imageCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
        }
    }
    // To preserve the current search term
    var currentSearchTerm: String?
    // To store image size based on indexpath
    var imageSizeArray = [CGSize]()
    // for timer to start network call
    var timer: Timer?
    
    // Views inside this controller
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        setupCollectionView()
        setUpCardView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpDefaultNavigation()
        self.imageCollectionView.isSkeletonable = true
        self.imageCollectionView.showAnimatedGradientSkeleton()
    }
    
    func setUpSearchBar(){
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.hexStringToUIColor(hex: "#FFF5D3")
        searchBar.placeholder = AppConstant.SEARCH_PLACEHOLDER
    }
    
    func setupCollectionView(){
        
        imageCollectionView.backgroundColor = UIColor.hexStringToUIColor(hex: "#FFF5D3")
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = 16.0
        layout.minimumInteritemSpacing = 16.0
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        // Collection view attributes
        self.imageCollectionView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        self.imageCollectionView.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        self.imageCollectionView.collectionViewLayout = layout
    }
    
    func setUpCardView(){
        cardView.backgroundColor = UIColor.hexStringToUIColor(hex: "#FFF5D3")
        cardView.isHidden = false
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, SkeletonCollectionViewDataSource{
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        
        return AppConstant.CELL_IDENTIFIER
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: AppConstant.CELL_IDENTIFIER, for: indexPath) as! ImageCollectionViewCell
        let imageData = imageDataArray[indexPath.row]
        cell.setupData(imageData: imageData) { (image) in
            if let img = image {
                cell.postImageView?.setContentBasedOnImage(image: img, height: cell.imageHeight)
                if self.imageSizeArray.count > indexPath.row{
                self.imageSizeArray[indexPath.row] = img.size
                }else{
                    self.imageSizeArray.append(img.size)
                }
                self.imageCollectionView.reloadItems(at: [indexPath])
            }
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: AppConstant.STORYBOARD_IDENTIFIER, bundle: nil)
        let cell = imageCollectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        let destinationViewController = storyBoard.instantiateViewController(withIdentifier: AppConstant.DETAIL_VIEW_CONTROLLER_IDENTIFIER) as! DetailViewController
        destinationViewController.selectedImageData = imageDataArray[indexPath.row]
        destinationViewController.selectedImage = cell.postImageView.image
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        if indexPath.row < imageSizeArray.count {
            return imageSizeArray[indexPath.row]
        }
        
        return CGSize(width: UIScreen.main.bounds.width/2.2, height: UIScreen.main.bounds.width/2.2)
    }
    
}

extension HomeViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.imageDataArray.removeAll()
        self.imageCollectionView.reloadData()
        cardView.isHidden = true
        self.activityIndicator.startAnimating()
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(output), userInfo: searchText, repeats: false)
    }
    
    @objc func output(){
        self.activityIndicator.stopAnimating()
        if timer?.userInfo != nil {
            if let searchText = timer?.userInfo as? String{
                if !searchText.isEmpty {
                    self.activityIndicator.startAnimating()
                    self.searchQuery(searchText: searchText)
                }else{
                    cardView.isHidden = false
                    cardImageView.image = UIImage(named: AppConstant.SEARCH_IMAGE)
                    cardMessageLabel.text = AppConstant.SEARCH_IMAGE_MESSAGE
                }
            }
        }
        timer?.invalidate()
    }
    
    func searchQuery(searchText: String){
        DispatchQueue.main.async {
            
            self.currentSearchTerm = searchText
            NetworkOperation.network.fetchImages(searchTerm: searchText, completion: { postData ,errorMsg  in
                self.imageCollectionView.showAnimatedGradientSkeleton()
                self.activityIndicator.stopAnimating()
                if let posts = postData {
                    for post in posts {
                        if (post.searchedKey == self.currentSearchTerm) {
                            self.imageDataArray.append(post)
                            self.imageCollectionView.reloadData()
                        }
                    }
                }else if (postData == nil && errorMsg == nil){
                    self.activityIndicator.stopAnimating()
                    self.cardView.isHidden = false
                    self.cardImageView.image = UIImage(named: AppConstant.ERROR_IMAGE)
                    self.cardMessageLabel.text = "\(AppConstant.ERROR_MESSAGE) \(searchText)"
                }else{
                    if let error = errorMsg{
                        var errorTitle = AppConstant.SEARCHED_ISSUE_TITLE
                        
                        if error == AppConstant.INTERNET_ISSUE{
                            errorTitle = AppConstant.INTERNET_ISSUE_TITLE
                        }
                        
                        let alert = UIAlertController(title: errorTitle, message: error, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: AppConstant.RETRY, style: UIAlertAction.Style.default, handler: { action in
                            DispatchQueue.main.async {
                                
                                if let search = self.currentSearchTerm,
                                    search != "" {
                                    self.searchQuery(searchText: search)
                                }
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
}
