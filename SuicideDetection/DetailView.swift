//
//  DetailView.swift
//  SuicideDetection
//
//  Created by Isha Nagireddy on 11/27/22.
//

import UIKit

class DetailView: UIViewController {
    @IBOutlet weak var titeleLabel: UILabel!
    @IBOutlet weak var levelOfRiskLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var definitionDescription: UILabel!
    @IBOutlet weak var howCanIHelp: UILabel!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var suicidalCaregiverButton: UIButton!
    @IBOutlet weak var suicidalHotlineButton: UIButton!
    @IBOutlet weak var Call911Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if MLOutput.prediciton == "No risk - Supportive" {
            levelOfRiskLabel.text = "No risk - Supportive"
            levelOfRiskLabel.textColor = .systemGreen
            
            definitionDescription.text = "The supportive level refers to the idea that an individual is engaging in discussion, but with no language that expresssed any history of being at-risk in the past or present. Some may identify themselves as having backgrounds in mental health care, while others don't define their motive for interacting. This is the lowest level of risk."
            helpLabel.text = "This individual is not suicidal. No extra actions need to be taken."
            suicidalCaregiverButton.isHidden = true
            suicidalHotlineButton.isHidden = true
            Call911Button.isHidden = true
        }
        
        if MLOutput.prediciton == "Low risk - Indicator" {
            levelOfRiskLabel.text = "Low risk - Indicator"
            levelOfRiskLabel.textColor = .green
            
            definitionDescription.text = "The indicator level refers to those using at risk-language however are not actively experiencing general or acute symptoms. Oftentimes, thse individuals would engage in conversation in a supportive manner and share personal history while using at-risk vocabulary. These users might express divorce, chronic illness, death in the family, suicide of loved one, which are all risk factors, but are said in empathy."
            
            helpLabel.text = "This individual is not suicidal. No extra actions need to be taken."
            suicidalCaregiverButton.isHidden = true
            suicidalHotlineButton.isHidden = true
            Call911Button.isHidden = true
            
        }
        
        if MLOutput.prediciton == "Low medium risk - Ideation" {
            
            levelOfRiskLabel.text = "Low medium risk - Ideation"
            levelOfRiskLabel.textColor = .yellow
            
            definitionDescription.text = "Suicidal ideation refers to thoughts of suicide including preoccupations with risk factors such as loss of job, loss of strong relationship, chronic disease, mental illness, or substance abuse."
            
            helpLabel.text = "This individual is suicidal. Provide support as a suicidal caregiver (click on the button below to learn how). If extra support is needed, reach out to a crisis line."
            suicidalCaregiverButton.isHidden = false
            suicidalHotlineButton.isHidden = false
            Call911Button.isHidden = true
        }
        
        if MLOutput.prediciton == "Medium risk - Behavior" {
            levelOfRiskLabel.text = "Medium risk - Behavior"
            levelOfRiskLabel.textColor = .orange
            
            definitionDescription.text = "This person know what they would use to commit suicide and where they would commit suicide. Suicidal behavior refers to actions with higher risk. This includes active or a history of self-harm, and active planning to commit suicide. Actions include cutting, using blunt force, violence, heavy susbtance abuse, and actions involving death."
            
            helpLabel.text = "This person is suicidal. Refer this person to a suicidal crisis line."
            
            suicidalCaregiverButton.isHidden = true
            suicidalHotlineButton.isHidden = false
            Call911Button.isHidden = true
            
        }
        
        if MLOutput.prediciton == "High risk -  Attempt" {
            levelOfRiskLabel.text = "High risk -  Attempt"
            levelOfRiskLabel.textColor = .red
            
            definitionDescription.text = "The individual knows where they would commit suicide right now. Attempt refers to any deliberate action that may result in intentional death, be it completed or not. This includes an individual calling for help, or writing a public goodbye note."
            
            helpLabel.text = "This person is suicidal. Call emergency services or 911."
            
            suicidalCaregiverButton.isHidden = true
            suicidalHotlineButton.isHidden = true
            Call911Button.isHidden = false
        }
        
        
        
        
    }
    
    @IBAction func caregiverClicked(_ sender: Any) {
    }
    
    @IBAction func hotlineClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to call the suicide hotline?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
            let url = URL(string: "tel://5083612532")!
            UIApplication.shared.open(url)
        })
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func Call911Clicked(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to call 911?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
            let url = URL(string: "tel://5083612532")!
            UIApplication.shared.open(url)
            
        })
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
