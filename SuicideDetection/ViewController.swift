//
//  ViewController.swift
//  SuicideDetection
//
//  Created by Isha Nagireddy on 11/23/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var slides = [CollectionViewOptions(imageShow: true, textShow: false, buttonShow: true, labelShow: true, imageToTextButton: true), CollectionViewOptions(imageShow: false, textShow: true, buttonShow: false, labelShow: false, imageToTextButton: false)]
    static var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.setup(slide: slides[indexPath.row])
        cell.Viewcontroller = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        ViewController.currentPage = Int(scrollView.contentOffset.x/width)
        pageControl.currentPage = ViewController.currentPage
    }
}

