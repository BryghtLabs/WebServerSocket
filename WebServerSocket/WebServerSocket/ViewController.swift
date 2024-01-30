//
//  ViewController.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/29/24.
//

import UIKit

class ViewController: BaseViewController {
    
    @IBOutlet weak var urlTxtField: UITextField!
    
    @IBOutlet weak var loadURLBtn: UIButton!
    
    @IBOutlet weak var injectJSLbl: UILabel!
    
    @IBOutlet weak var injectJSSwitch: UISwitch!
    
    @IBOutlet weak var webServerOnLbl: UILabel!
    
    @IBOutlet weak var webServerOnSwitch: UISwitch!
    
    @IBOutlet weak var localSocketOnSwitchLbl: UILabel!
    
    @IBOutlet weak var localSocketOnSwitch: UISwitch!
    
    @IBOutlet weak var logTxtView: UITextView!
    
    @IBOutlet weak var clearLogBtn: UIButton!
    
    var injectScript: Bool = false
    
    var runAppWebSocket: Bool = false
    
    var currentLogTxt: String = "" {
        didSet {
            globalMainQueue.async {
                self.logTxtView.text = self.currentLogTxt
                let stringLength = self.currentLogTxt.count
                self.logTxtView.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
            }
        }
    }
    
    var isWebServerOn: Bool {
        return WebServer.shared.cdcServer?.isRunning ?? false
    }
    
    var isAppSocketOn: Bool {
        return AppWebSocket.shared.isSocketOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRootNavController()
        setupDelegates()
        setupTxtView()
        setupURLTxtField()
        initiateWebServerSocket()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setSwitches()
    }
    
    private func setRootNavController() {
        let navController = UINavigationController(rootViewController: self)
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = navController
    }
    
    private func setupURLTxtField() {
        self.urlTxtField.inputAccessoryView = self.keyboardDoneToolbar
        self.urlTxtField.delegate = self
    }
    
    private func setupTxtView() {
        self.logTxtView.layoutManager.allowsNonContiguousLayout = false
    }
    
    private func setSwitches() {
        self.injectJSSwitch.setOn(self.injectScript, animated: true)
        self.respondToInjectSwitch(isOn: self.injectScript)
        
        self.localSocketOnSwitch.setOn(runAppWebSocket, animated: true)
        self.respondToSocketOn(isOn: self.runAppWebSocket)
        
        self.webServerOnSwitch.setOn(isWebServerOn, animated: true)
        self.respondToWebServerSwitch(isOn: self.isWebServerOn)
    }
    
    private func setupDelegates() {
        WebServer.shared.appWebServerDelegate = self
        AppWebSocket.shared.appWebSocketDelegate = self
    }
    
    private func initiateWebServerSocket() {
        self.startWebServer()
        Utils.delayExecution(1) {
            self.startWebSocket()
        }
    }
    
    func startWebServer() {
        WebServer.shared.start()
    }
    
    func startWebSocket() {
        guard runAppWebSocket else { return }
        AppWebSocket.shared.start()
    }
    
    @IBAction func injectJSSwitch(_ sender: UISwitch) {
        respondToInjectSwitch(isOn: sender.isOn)
    }
    
    @IBAction func webServerOnSwitch(_ sender: UISwitch) {
        respondToWebServerSwitch(isOn: sender.isOn)
    }
    
    @IBAction func localSocketOnSwitch(_ sender: UISwitch) {
        respondToSocketOn(isOn: sender.isOn)
    }
    
    @IBAction func clearLogBtnClicked(_ sender: Any) {
        self.currentLogTxt = ""
    }
    
    @IBAction func loadURLBtnClicked(_ sender: UIButton) {
        self.loadUrlInWebView()
    }
    
    private func respondToInjectSwitch(isOn: Bool) {
        if isOn {
            injectScript = true
        } else {
            injectScript = false
        }
    }
    
    private func respondToWebServerSwitch(isOn: Bool) {
        if isOn {
            WebServer.shared.start()
        } else {
            WebServer.shared.stop()
        }
    }
    
    private func respondToSocketOn(isOn: Bool) {
        if isOn {
            AppWebSocket.shared.start()
        } else {
            AppWebSocket.shared.stopSocket()
        }
    }
    
    private func loadUrlInWebView() {
        guard self.urlTxtField.text?.isEmpty == false else { return }
        guard let urlString = self.urlTxtField.text else { return }
        (self.injectScript) ? loadUrlWithScript(url: urlString) : loadUrlWithNOScript(url: urlString)
    }
    
    private func loadUrlWithScript(url: String) {
        guard let script = Utils.getChessDotComSocketJavascript() else { return }
        DotComWebViewController.pushForSocket(parentVC: self, url: url, script: script)
    }
    
    private func loadUrlWithNOScript(url: String) {
        DotComWebViewController.pushForSocket(parentVC: self, url: url, script: nil)
        self.currentActiveTextField?.resignFirstResponder()
    }

}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.currentActiveTextField = textField
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.currentActiveTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.currentActiveTextField = nil
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.currentActiveTextField = nil
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
}

extension ViewController: AppWebSocketProtocol {
    
    func socketLog(log: String) {
        self.currentLogTxt += log
    }
    
}

extension ViewController: AppWebServerProtocol {
    func serverLog(log: String) {
        self.currentLogTxt += log
    }
}

