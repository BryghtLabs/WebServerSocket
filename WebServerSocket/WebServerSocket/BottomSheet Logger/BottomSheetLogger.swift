//
//  BottomSheetLogger.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/10/24.
//  Copyright © 2024 Bryght Labs. All rights reserved.
//

import Foundation
import UIKit

class BottomSheetLogger: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var openingTitleLbl: UILabel!
    
    @IBOutlet weak var logTxtView: UITextView!
    
    @IBOutlet weak var logBtn: UIButton!
    
    @IBOutlet weak var clearLogBtn: UIButton!
    
    var allowLogging: Bool = true
    
    var currentLogTxt: String = "" {
        didSet {
            globalMainQueue.async {
                self.logTxtView.text = self.currentLogTxt
                if self.allowLogging {
                    let stringLength = self.currentLogTxt.count
                    self.logTxtView.scrollRangeToVisible(NSMakeRange((stringLength - 1), 0))
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adjustScrollViewContentSize()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func logBtnClicked(_ sender: Any) {
        globalMainQueue.async {
            self.allowLogging.toggle()
            if self.allowLogging {
                self.logBtn.setTitle("Stop Logging", for: .normal)
            } else {
                self.logBtn.setTitle("Start Logging", for: .normal)
            }
        }
    }
    
    @IBAction func clearLogBtnClicked(_ sender: Any) {
        DotComManager.shared.currentLogText = ""
        self.currentLogTxt = ""
    }
    
    private func setupDelegates() {
        WebServer.shared.appWebServerDelegate = self
        DotComManager.shared.dotComManagerDelegate = self
    }
    
    private func adjustScrollViewContentSize() {
        guard UIScreen.main.screenHeight == .Small else { return }
        globalMainQueue.async {
            let width = self.scrollView.contentSize.width
            self.scrollView.contentSize = CGSize(width: width, height: (UIScreen.main.bounds.height + 300))
        }
    }

    
    static func make() -> BottomSheetLogger? {
        UIStoryboard(name: "BottomSheetLogger", bundle: nil).instantiateViewController(withIdentifier: "BottomSheetLogger") as? BottomSheetLogger
    }
    
    @discardableResult
    static func pushBottomSheet(parentVC: BaseViewController?) -> BottomSheetLogger? {
        guard let vc = parentVC else { return nil }
        guard let bottomSheetLogger = BottomSheetLogger.make() else { return nil }
        bottomSheetLogger.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            if let sheet = bottomSheetLogger.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
        } else {
            // Fallback on earlier versions
        }

        vc.present(bottomSheetLogger, animated: true) {}
        return bottomSheetLogger
    }
    
    
    
}

extension BottomSheetLogger: DotComManagerProtocol {
    func dotComManagerLogLog(log: String) {
        self.currentLogTxt += log
    }
}

extension BottomSheetLogger: AppWebServerProtocol {
    func serverLog(log: String) {
        DotComManager.shared.currentLogText += log
        self.currentLogTxt += DotComManager.shared.currentLogText
    }
}
