//
//  UserHeaderTableViewCell.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/7/11.
//  Copyright © 2018年 H. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import MJRefresh
import Moya

class UserHeaderTableViewCell: UITableViewCell, LBXScanViewControllerDelegate {
    
    let provider = MoyaProvider<CNodeService>()
    // 0: 当前用户的个人中心 1: 其它用户的个人中心
    var type: Int!
    var author: Author!
    
    lazy var avatar: UIImageView = {
        var avatar = UIImageView()
        avatar.image = UIImage(named: "baseline_account_circle_white_24pt")
        avatar.layer.cornerRadius = 50
        avatar.layer.masksToBounds = true
        return avatar
    }()
    
    var username: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    var registerTime: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    var score: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(CNodeColor.tabColor)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 200)
        self.backgroundColor = UIColor(patternImage: UIImage(named: "user_detail_header_bg")!)
        self.addSubview(avatar)
        self.addSubview(username)
        self.addSubview(registerTime)
        self.addSubview(score)
        
        addConstraints()
        
        // 添加事件
        self.avatar.isUserInteractionEnabled = true
        self.avatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UserHeaderTableViewCell.avatarTap)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        avatar.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        username.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatar.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        registerTime.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(self.username.snp.bottom).offset(30)
            make.bottom.equalTo(-10)
        }
        
        score.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(self.username.snp.bottom).offset(30)
            make.bottom.equalTo(-10)
        }
    }
    
    func bind() {
        if type == 0 {
            if UserDefaults.standard.string(forKey: "token") != nil {
                let avatar_url = UserDefaults.standard.string(forKey: "avatar_url")
                let username = UserDefaults.standard.string(forKey: "loginname")
                let create_at = UserDefaults.standard.string(forKey: "create_at")
                let score = UserDefaults.standard.string(forKey: "score")
                if avatar_url != nil {
                    self.avatar.kf.setImage(with: URL(string: avatar_url!))
                }
                if username != nil {
                    self.username.text = username
                }
                if create_at != nil {
                    self.registerTime.text = "注册于" + create_at!
                }
                if score != nil {
                    self.score.text = "积分:\(score!)"
                }
            } else {
                self.username.text = "点击头像扫码登录"
            }
        } else if type == 1 {
            self.avatar.kf.setImage(with: URL(string: author.avatar_url!))
            self.username.text = author.loginname
            self.registerTime.text = "注册于 \((author.create_at?.getElapsedInterval())!)"
            self.score.text = "积分:\(author.score!)"
        }
    }
    
    func unbind() {
        self.avatar.image = UIImage(named: "baseline_account_circle_white_24pt")
        self.username.text = "点击头像扫码登录"
        self.registerTime.text = ""
        self.score.text = ""
    }
    
    @objc func avatarTap() {
        if UserDefaults.standard.string(forKey: "token") == nil {
            LBXPermissions.authorizeCameraWith { [weak self] (granted) in
                if granted {
                    self?.scanQrCode()
                } else {
                    LBXPermissions.jumpToSystemPrivacySetting()
                }
            }
        }
    }
    
    var scanQrCodeViewController: ((_ vc: LBXScanViewController?) -> Void)?
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
        scanQrCodeViewController?(vc)
    }
    
    var startReloadDataRefreshing: (() -> Void)?
    var endReloadDataRefreshing: (() -> Void)?
    var toastMessage: ((_ msg: String) -> Void)?
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        let token = scanResult.strScanned
        self.startReloadDataRefreshing?()
        // fetch user
        provider.request(.accessToken(token: token!)) { (res) in
            switch res {
            case .success(let response):
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
                        self.bind()
                        self.endReloadDataRefreshing?()
                    case .failure(let error):
                        self.toastMessage?(error.errorDescription!)
                        self.endReloadDataRefreshing?()
                    }
                })
                
            case .failure(let error):
                self.toastMessage?(error.errorDescription!)
                self.endReloadDataRefreshing?()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
