//
//  MLOutput.swift
//  SuicideDetection
//
//  Created by Isha Nagireddy on 11/25/22.
//

import UIKit
import CoreML
import CoreData
import PorterStemmer2

class MLOutput: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var detectionLabel: UILabel!
    @IBOutlet weak var announcingLabel: UILabel!
    @IBOutlet weak var levelOfRiskLabel: UILabel!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var confirmationButton: UIButton!
    
    var input = CollectionViewCell.input
    var afterProccessing = [String()]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var suicidal_value = Float32()
    var non_suicidal_value = Float32()
    var total_suicidal = Float32()
    var total_non_suicidal = Float32()
    
    static var MLPrediciton = Bool()
    static var prediciton = String()
    
    var thoughts: Bool? {
        willSet {
            if thoughts == true && plan == false && intent == false {
                detectionLabel.text = "It is likely that this person is talking about suicide."
                levelOfRiskLabel.text = "Low medium risk - Ideation"
                levelOfRiskLabel.textColor = .yellow
            }
            
            else if thoughts == false && plan == false && intent == false {
                detectionLabel.text = "It is likely that this person is talking about suicide."
                levelOfRiskLabel.text = "Low risk - Indicator"
                levelOfRiskLabel.textColor = .systemGreen
            }
            
            else if MLOutput.MLPrediciton == false && thoughts == false && plan == false && intent == false {
                detectionLabel.text = "It is likely that this person is not talking about suicide."
                levelOfRiskLabel.text = "No risk - Supportive"
                levelOfRiskLabel.textColor = .green
            }
        }
    }
    
    var plan: Bool? {
        willSet {
            if plan == true && intent == false {
                detectionLabel.text = "It is likely that this person is talking about suicide."
                levelOfRiskLabel.text = "Medium risk - Behavior"
                levelOfRiskLabel.textColor = .orange
            }
        }
    }
    
    var intent: Bool? {
        willSet {
            if intent == true {
                detectionLabel.text = "It is likely that this person is talking about suicide."
                levelOfRiskLabel.text = "High risk -  Attempt"
                levelOfRiskLabel.textColor = .red
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

            let tagger = NSLinguisticTagger(tagSchemes:[.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
            let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
            
            tagger.string = input
                let range = NSRange(location:0, length: input.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { tag, tokenRange, stop in
                    let word = (input as NSString).substring(with: tokenRange)
                    print(word)
                    afterProccessing.append(word)
                }
        
        let length = afterProccessing.count
        if  let stemmer = PorterStemmer(withLanguage: .English) {
            for i in 0...length - 1 {
                let stemmedWord = stemmer.stem(afterProccessing[i])
                print(stemmedWord)
                afterProccessing[i] = stemmedWord
            }
            
        }
        
            // fetch core data
            
            let fetchRequest: NSFetchRequest<Frequency>
            fetchRequest = Frequency.fetchRequest()
            
            let frequencyData = try! context.fetch(fetchRequest)
            
            
            for word in afterProccessing {
                suicidal_value = 0
                non_suicidal_value = 0
                
                let suicidal_key = String(word) + " 1"
                let non_suicidal_key = String(word) + " 0"
                
                let range = frequencyData.count
                for i in 0...range - 1 {
                    if suicidal_key == frequencyData[i].key {
                        suicidal_value = suicidal_value + frequencyData[i].value
                    }
                    
                    if non_suicidal_key == frequencyData[i].key {
                        non_suicidal_value = non_suicidal_value + frequencyData[i].value
                    }
                }
                
                total_suicidal = Float32(total_suicidal + suicidal_value)
                total_non_suicidal = total_non_suicidal + non_suicidal_value
            }
            
            // scaling features
            let total_suicidal_scaled = (total_suicidal - 18112.601623044306) / 42423.07485052825
            let total_non_suicidal_scaled = (total_non_suicidal - 18112.601623044306) / 42423.07485052825
            
            let shape1x2 = [1, 2] as [NSNumber]
            guard let multiArray1x2 = try? MLMultiArray(shape: shape1x2, dataType: .float32) else {
                return
            }
            
            let firstElement = [0,0] as [NSNumber]
            let secondElement = [0,1] as [NSNumber]
            
            multiArray1x2[firstElement] = NSNumber(value: total_suicidal_scaled)
            multiArray1x2[secondElement] = NSNumber(value: total_non_suicidal_scaled)
            print(multiArray1x2)
            
            do {
                
                let configuration = MLModelConfiguration()
                let model = try CoreML_model(configuration: configuration)
                let input = CoreML_modelInput(dense_input: multiArray1x2)
                
                let output = try model.prediction(input: input)
                print(output)
                print(output.Identity[0])
                let probability = Float64(truncating: output.Identity[0])
                
                if probability >= 0.5 {
                    MLOutput.MLPrediciton = true
                    detectionLabel.text = "It is likely that this person is talking about suicide."
                }
                
                if probability < 0.5 {
                    MLOutput.MLPrediciton = false
                    detectionLabel.text = "It is likely that this person is not talking about suicide."
                }
                
                
            }
            
            catch {
                print("error")
            }
    }
    
    @IBAction func moreInfoButtonClicked(_ sender: Any) {
        MLOutput.prediciton = levelOfRiskLabel.text!
        performSegue(withIdentifier: "toDetailView", sender: nil)
    }
    
    @IBAction func confirmingButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "segueToFormScreen", sender: nil)
    }
    
    @IBAction func unwindToMLOutput(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? FormView {
            
            thoughts = sourceViewController.thoughts
            plan = sourceViewController.plan
            intent = sourceViewController.intent
        }
    }
    
}
