//
//  CollectionViewCell.swift
//  SuicideDetection
//
//  Created by Isha Nagireddy on 11/23/22.
//

import UIKit
import Vision

class CollectionViewCell: UICollectionViewCell, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextViewDelegate {
    
    weak var Viewcontroller: UIViewController?
    static let identifier = String(describing:CollectionViewCell.self)
    var counter = 0
    static var input = ""
    
    
    @IBOutlet weak var recognizedTextView: UITextView!
    @IBOutlet weak var textBox: UITextView!
    @IBOutlet weak var imageInput: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var mainButton: UIButton!
    
    
    func setup(slide: CollectionViewOptions) {
        imageInput.isHidden = slide.imageShow
        uploadButton.isHidden = slide.buttonShow
        textBox.isHidden = slide.textShow
        recognizedTextView.isHidden = slide.labelShow
        convertButton.isHidden = slide.imageToTextButton
        
        textBox.delegate = self
        self.spinner.isHidden = true
        
    }
    
    @IBAction func uploadScreenshot(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        Viewcontroller?.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageInput.image = image
        }
        
        else {
            print("please input an IMAGE")
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textBox.text  == "Type here...." {
            textBox.text = ""
        }
    }
    
    @IBAction func convertingButtonClicked(_ sender: Any) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    
        guard let cgImage = self.imageInput.image!.cgImage else {return}
        
        DispatchQueue.global(qos: .default).async {
            //handler
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            //request
            let request = VNRecognizeTextRequest {[weak self] request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                    return
                }
                
                // combines observations and joined with commas
                let text = observations.compactMap({
                    $0.topCandidates(1).first!.string
                }).joined(separator: ",")
            
                DispatchQueue.main.async {
                    self!.spinner.stopAnimating()
                    self!.spinner.isHidden = true
                    self!.recognizedTextView.text = text
                }
            }
            
            //proccess request
            do {
                try handler.perform([request])
                
            }
            
            catch {
                print(error)
            }
        }
    }
    @IBAction func finalButtonClicked(_ sender: Any) {
        if ViewController.currentPage == 0 {
            CollectionViewCell.input = textBox.text
            if CollectionViewCell.input == "" || CollectionViewCell.input == "Type here...."{
                    //alert to please enter input
                    let alert = UIAlertController(title: "Please enter text.", message: "No text has been putted into the text box. Please input text. ", preferredStyle: .alert)
                    let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    alert.addAction(okay)
                    Viewcontroller?.present(alert, animated: true, completion: nil)
                }
                
                else {
                    Viewcontroller?.performSegue(withIdentifier: "segueToMLScreen", sender: nil)
                }
            
            }
            
            else {
                
                CollectionViewCell.input = recognizedTextView.text
                if CollectionViewCell.input == "" {
                    // alert please convert to text first (click on button)
                    let alert = UIAlertController(title: "Could not translate image.", message: "Make sure to input an image and click on the convert button. If you hvae tried this, we were not able to recognize any text on the image. Please try entering another image, or enter your input through the 1st slide. ", preferredStyle: .alert)
                    let okay = UIAlertAction(title: "okay", style: .default, handler: nil)
                    alert.addAction(okay)
                    Viewcontroller?.present(alert, animated: true, completion: nil)
                }
                
                else {
                    Viewcontroller?.performSegue(withIdentifier: "segueToMLScreen", sender: nil)
                }
            }
    }
    
    
    
}
    
