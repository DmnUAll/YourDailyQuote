//
//  ViewController.swift
//  YourDailyQuote
//
//  Created by Илья Валито on 29.08.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        QuoteManager.delegate = self
        
        addShadows(to: quoteLabel)
        addShadows(to: authorLabel)
        addShadows(to: infoButton)
        addShadows(to: updateButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppLogic.loadUserDefaults()
    }
    
    private func addShadows(to uiElement: UIView) {
        uiElement.layer.shadowColor = UIColor.black.cgColor
        uiElement.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        uiElement.layer.shadowOpacity = 0.15
        uiElement.layer.shadowRadius = 1.0
        uiElement.layer.masksToBounds = false
        uiElement.layer.cornerRadius = 4.0
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Info", message: "You can update the quote 3 times per day.\n\(AppLogic.updates)/3 updates did for today.", preferredStyle: .alert)
        let gotItAction = UIAlertAction(title: "Got it!", style: .default, handler: nil)
        alertController.addAction(gotItAction)
        show(alertController, sender: self)
    }
    
    @IBAction func infoTapped() {
        showAlert()
    }
    
    @IBAction func updateQuoteTapped() {
        if AppLogic.updates < 3 {
            activityIndicator.startAnimating()
            quoteLabel.isHidden = true
            authorLabel.isHidden = true
            QuoteManager.performRequest()
            AppLogic.updates += 1
        } else {
            showAlert()
        }
    }
}

extension MainViewController: QuoteManagerDelegate {
    func updateUI() {
        DispatchQueue.main.async {
            self.quoteLabel.text = AppLogic.quote
            self.authorLabel.text = AppLogic.author
            self.quoteLabel.isHidden = false
            self.authorLabel.isHidden = false
            self.activityIndicator.stopAnimating()
        }
    }
}
