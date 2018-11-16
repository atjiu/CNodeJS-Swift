//
//  LoginViewController.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/11/15.
//  Copyright © 2018 H. All rights reserved.
//

import UIKit
import SnapKit
import Moya
import SwiftyJSON

class LoginViewController: UIViewController, LBXScanViewControllerDelegate {
    
    let provider = MoyaProvider<CNodeService>()
    
    var headerImageView: UIImageView = {
        var image = UIImageView()
        image.contentMode = UIViewContentMode.scaleAspectFill
        image.image = UIImage(named: "login_header_bg")
        return image
    }()
    
    var navTitle: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("my_login", comment: "")
        label.textColor = UIColor.white
        return label
    }()
    
    var logoImageView: UIImageView = {
        var image = UIImageView()
        image.contentMode = UIViewContentMode.scaleAspectFit
        image.image = UIImage(named: "logo_light")
        return image
    }()
    
    var backIcon: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "baseline_keyboard_backspace_black_24pt")
        image.tintColor = UIColor.white
        return image
    }()
    var loginView: UIView = {
        var view = UIView()
        return view
    }()
    var tokenTextField: UITextField = {
        var tf = UITextField()
        tf.layer.masksToBounds = true
        tf.layer.borderColor = AppColor.colors.tabColor.cgColor
        tf.layer.borderWidth = 2
        tf.layer.cornerRadius = 4
        tf.placeholder = "Access Token:"
        tf.clearButtonMode = .whileEditing
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    var loginBtn: UIButton = {
        var button = UIButton()
        button.setTitle(NSLocalizedString("my_login", comment: ""), for: UIControlState.normal)
        button.backgroundColor = AppColor.colors.tabColor
        return button
    }()
    var scanQRIcon: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "scan_qr_black_24pt")
        return image
    }()
    var scanQRLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = NSLocalizedString("my_scan_qrcode", comment: "")
        return label
    }()
    
    // 定义一个回调方法，通知发起登录页面登录成功
    var doSomething: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置布局
        self.view.addSubview(headerImageView)
        self.view.addSubview(navTitle)
        self.view.addSubview(logoImageView)
        self.view.addSubview(backIcon)
        
        self.view.addSubview(loginView)
        self.loginView.addSubview(tokenTextField)
        self.loginView.addSubview(loginBtn)
        self.loginView.addSubview(scanQRIcon)
        self.loginView.addSubview(scanQRLabel)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.tokenTextField.frame.height))
        self.tokenTextField.leftView = paddingView
        self.tokenTextField.leftViewMode = .always
        
        headerImageView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
        }
        navTitle.snp.makeConstraints { (make) in
            make.left.equalTo(self.backIcon.snp.right).offset(20)
            make.centerY.equalTo(self.backIcon)
        }
        logoImageView.snp.makeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH - 100)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.headerImageView)
        }
        backIcon.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.equalTo(20)
        }
        loginView.snp.makeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.headerImageView.snp.bottom).offset(-50)
        }
        tokenTextField.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.tokenTextField.snp.bottom).offset(20)
            make.left.equalTo(self.tokenTextField.snp.left)
            make.right.equalTo(self.tokenTextField.snp.right)
        }
        scanQRIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.left.equalTo(self.tokenTextField.snp.left)
            make.top.equalTo(self.loginBtn.snp.bottom).offset(20)
            make.bottom.equalTo(-20)
        }
        scanQRLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.scanQRIcon.snp.right).offset(10)
            make.centerY.equalTo(self.scanQRIcon)
        }
        
        // 添加事件
        self.backIcon.isUserInteractionEnabled = true
        self.backIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.backClick)))
        
        self.loginBtn.isUserInteractionEnabled = true
        self.loginBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.login)))
        
        self.scanQRIcon.isUserInteractionEnabled = true
        self.scanQRIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.toScan)))
        
        self.scanQRLabel.isUserInteractionEnabled = true
        self.scanQRLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.toScan)))
        
        self.themeChangedHandler = {[weak self] (style) -> Void in
            self?.view.backgroundColor = AppColor.colors.backgroundColor
            self?.loginView.backgroundColor = AppColor.colors.cellBackgroundColor
            self?.tokenTextField.textColor = AppColor.colors.titleColor
            self?.tokenTextField.backgroundColor = AppColor.colors.cellBackgroundColor
            self?.scanQRIcon.tintColor = AppColor.colors.titleColor
            self?.scanQRLabel.textColor = AppColor.colors.titleColor
        }
    }
    
    @objc func backClick() {
        self.doSomething?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func login() {
        let token = self.tokenTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        if token == nil || token!.count != 36 {
            self.view.makeToast(NSLocalizedString("my_scan_token_result", comment: ""))
            return;
        }
        self.view.makeToastActivity(.center)
        // fetch user
        provider.request(.accessToken(token: token!)) { (res) in
            switch res {
            case .success(let response):
                let json = JSON(response.data)
                if json["success"] == false {
                    self.view.makeToast(json["error_msg"].stringValue)
                    self.view.hideToastActivity()
                    return;
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let author = try! decoder.decode(Author.self, from: response.data)
                UserDefaults.standard.set(token, forKey: "token")
                UserDefaults.standard.set(author.avatar_url, forKey: "avatar_url")
                UserDefaults.standard.set(author.loginname, forKey: "loginname")
                // 请求用户个人信息
                self.provider.request(.user(loginname: author.loginname!), completion: { (res) in
                    switch res {
                    case .success(let response):
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                        let result = try! decoder.decode(Result<Author>.self, from: response.data)
                        UserDefaults.standard.set(result.data?.score, forKey: "score")
                        UserDefaults.standard.set(result.data?.create_at?.getElapsedInterval(), forKey: "create_at")
                        self.view.hideToastActivity()
                        self.backClick()
                    case .failure(let error):
                        self.view.makeToast(error.errorDescription!)
                        self.view.hideToastActivity()
                    }
                })
            case .failure(let error):
                self.view.makeToast(error.errorDescription!)
                self.view.hideToastActivity()
            }
        }
    }
    
    @objc func toScan() {
        if UserDefaults.standard.string(forKey: "token") == nil {
            print(11)
            LBXPermissions.authorizeCameraWith { [weak self] (granted) in
                if granted {
                    self?.scanQrCode()
                } else {
                    LBXPermissions.jumpToSystemPrivacySetting()
                }
            }
        }
    }
    
    func scanQrCode() {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 60;
        style.xScanRetangleOffset = 30;
        if SCREEN_HEIGHT <= 480 {
            //3.5inch 显示的扫码缩小
            style.centerUpOffset = 40;
            style.xScanRetangleOffset = 20;
        }
        style.color_NotRecoginitonArea = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner;
        style.photoframeLineW = 2.0;
        style.photoframeAngleW = 16;
        style.photoframeAngleH = 16;
        style.isNeedShowRetangle = false;
        style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid;
        style.animationImage = UIImage(named: "qrcode_scan_full_net")
        let vc = LBXScanViewController();
        vc.scanStyle = style
        vc.scanResultDelegate = self
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        let token = scanResult.strScanned
        if token == nil || token!.count != 36 {
            self.view.makeToast(NSLocalizedString("my_scan_token_result", comment: ""))
            return;
        }
        self.tokenTextField.text = token
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
