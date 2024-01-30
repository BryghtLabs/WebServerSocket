//
//  BaseViewController.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var presenterObject: AnyObject?
    
    @IBOutlet weak var viewManagerObject: AnyObject?
    
    var currentActiveTextField: UITextField?
    
    lazy var keyboardDoneToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: 320, height: 44))
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(keyboardDoneTapped))
        doneBtn.tintColor = UIColor.white
        toolbar.items = [flexible, doneBtn]
        toolbar.sizeToFit()
        return toolbar
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc func keyboardDoneTapped() {
        currentActiveTextField?.resignFirstResponder()
    }
    
}
