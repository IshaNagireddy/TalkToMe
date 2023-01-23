//
//  FormView.swift
//  SuicideDetection
//
//  Created by Isha Nagireddy on 11/26/22.
//

import UIKit
import Foundation

class FormView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var slides = [CollectionViewOptions2(questionLabel: "Has this individual portrayed suicidal ideation?", descriptionLabel: "Suicidal ideation refers to thoughts of suicide including preoccupations with risk factors such as loss of job, loss of strong relationship, chronic disease, mental illness, or substance abuse."), CollectionViewOptions2(questionLabel: "Has this individual portrayed suicidal behavior?", descriptionLabel: "Does this person know what they would use to commit suicide? Do they know where they would commit suicide? Suicidal behavior refers to actions with higher risk. This includes active or a history of self-harm, and active planning to commit suicide."), CollectionViewOptions2(questionLabel: "Does this individual portray actions/thoughts related to a suicidal attempt?", descriptionLabel: "Do they know when and where they would commit suicide right now? Intent/attempt refers to any deliberate action that may result in intentional death, be it completed or not. This includes an individual calling for help, or writing a public goodbye note.")]
    
    var currentPage = 0
    var thoughts = false
    var plan  = false
    var intent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func yesClicked(_ sender: Any) {
        
        if currentPage == 2 {
            intent = true
            performSegue(withIdentifier: "unWindToMLOutput", sender: nil)
            
        }
        
        else {
            
            if currentPage == 0 {
                thoughts = true
            }
            
            if currentPage == 1 {
                plan = true
            }
            
            currentPage += 1
            pageControl.currentPage = currentPage
            
            if currentPage == 1 {
                image.image = UIImage(named: "signes-detresse-graph")
            }
            
            if currentPage == 2 {
                image.image = UIImage(named: "amhc_illustration")
            }
            
            let rect = self.collectionView.layoutAttributesForItem(at: IndexPath(row: currentPage, section: 0))?.frame
            self.collectionView.scrollRectToVisible(rect!, animated: true)
        }
    }
    
    @IBAction func noClicked(_ sender: Any) {
        
        if currentPage == 2 {
            performSegue(withIdentifier: "unWindToMLOutput", sender: nil)
        }
        
        else {
            
            currentPage += 1
            pageControl.currentPage = currentPage
            
            if currentPage == 1 {
                image.image = UIImage(named: "signes-detresse-graph")
            }
            
            if currentPage == 2 {
                image.image = UIImage(named: "amhc_illustration")
            }
            
            let rect = self.collectionView.layoutAttributesForItem(at: IndexPath(row: currentPage, section: 0))?.frame
            self.collectionView.scrollRectToVisible(rect!, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell2.identifier2, for: indexPath) as! CollectionViewCell2
        cell.setup(slide: slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x/width)
        
        if currentPage == 0 {
            image.image = UIImage(named: "suicide-prevention-responding-to-red-flags")
        }
        
        if currentPage == 1 {
            image.image = UIImage(named: "signes-detresse-graph")
        }
        
        if currentPage == 2 {
            image.image = UIImage(named: "amhc_illustration")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unWindToMLOutput" {
            let destination = segue.destination as! MLOutput
            destination.thoughts = thoughts
            destination.plan = plan
            destination.intent = intent
        }
    }
}
