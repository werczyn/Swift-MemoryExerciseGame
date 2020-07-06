//
//  ViewController.swift
//  Zadanie3Pro
//
//  Created by werczyn on 05/12/2019.
//  Copyright © 2019 Polsko Japońska Akademia Technik Komputerowych. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var midleImageView: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet var imageViews: [UIImageView]!
    
    var time : Double = 1.0
    var score = 0
    var isAssigned = true
    var properImage : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        slider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }

    
    @IBAction func changeLevelSlider(_ sender: UISlider) {
        let value = sender.value
        
        if value == 0 {
            levelLabel.text = "Easy"
            time = 1
        }else if value < 50{
            levelLabel.text = "Medium"
            time = 0.75
        }else if value <= 99{
            levelLabel.text = "Hard"
            time = 0.5
        }else if value == 100{
            levelLabel.text = "Very Hard"
            time = 0.25
        }
        
    }
    
    
    @IBAction func startButtonClicked(_ sender: UIButton) {
        var numbers = [1,2,3,4,5,6,7,8].shuffled()
        
        let midNumber = Int.random(in: 1...8)
        midleImageView.image = UIImage(named: "images-\(midNumber)")
        
        for imageView in imageViews{
            let number = numbers.removeLast()
            imageView.image = UIImage(named: "images-\(number)")
            if imageView.image!.isEqual(midleImageView.image!){
                properImage = imageView
            }
        }
        
        if !isAssigned{
            score -= 1
            scoreLabel.text = "Score: \(score)"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            for imageView in self.imageViews{
                imageView.image = UIImage(systemName: "questionmark")
            }
            self.isAssigned = false
        }
    }
    
    
    @IBAction func imageTaped(_ sender: UIGestureRecognizer) {
        let tappedImageView = sender.view as! UIImageView
        
        if !isAssigned {
            if tappedImageView.isEqual(properImage){
                score += 2
                if score >= 10{
                    win()
                }
            }else{
                score -= 10
            }
            scoreLabel.text = "Score: \(score)"
            
            properImage!.image = midleImageView.image!
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.properImage?.image = UIImage(systemName: "questionmark")
            }
            
            isAssigned = true
        }
    }
    
    @IBAction func resetButtonClicked(_ sender: Any) {
        score = 0
        scoreLabel.text = "Score: \(score)"
        midleImageView.image = UIImage(systemName: "questionmark")
    }
    
    func win(){
        let alert = UIAlertController(title: "You win", message: "Do you want to play again?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: resetButtonClicked(_:)))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {action in
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        }))
        present(alert, animated: true)
    }
    
}
