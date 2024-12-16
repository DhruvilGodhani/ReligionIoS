//
//  updateVC.swift
//  ReligiousAPI
//
//  Created by ADMIN on 16/12/24.
//

import UIKit

class updateVC: UIViewController {

    @IBOutlet weak var sourceField: UITextField!
    @IBOutlet weak var quoteField: UITextField!
    @IBOutlet weak var religionField: UITextField!
    var selectedQuote: QuoteModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceField.text = selectedQuote.source
        quoteField.text = selectedQuote.quote
        religionField.text = selectedQuote.religion
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onUpdate(_ sender: Any) {
        let updatedQuote = QuoteModel(id: selectedQuote.id, religion: religionField.text!, quote: quoteField.text!, source: sourceField.text!)
        CDManager().updateFromCD(quote: updatedQuote)
//        reset()
    }
    
    func reset(){
        sourceField.text = ""
        quoteField.text = ""
        religionField.text = ""
    }

}
