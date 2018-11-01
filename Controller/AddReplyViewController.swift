//
//  AddReplyViewController.swift
//  CNodeJS-Swift
//
//  Created by H on 2018/10/31.
//  Copyright © 2018 H. All rights reserved.
//

import UIKit
import SnapKit
import Moya

class AddReplyViewController: UIViewController {
    
    var provider = MoyaProvider<CNodeService>()
    
    var topic_id : String!
    var reply_id : String?
    var detail_reply_loginname: String?
    
    lazy var textView: UITextView = {
        var textView = UITextView()
        textView.keyboardType = .default
//        textView.keyboardAppearance = .default
        textView.keyboardDismissMode = .interactive
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "添加回复"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.barStyle = .black
        //设置返回按钮为白色
        self.navigationController?.navigationBar.tintColor = .white
        
        //添加菜单
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(AddReplyViewController.leftClick))
        let menuButton = UIButton()
        menuButton.contentMode = .center
        menuButton.setImage(UIImage(named: "baseline_send_white_24pt"), for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
        menuButton.addTarget(self, action: #selector(AddReplyViewController.rightClick), for: .touchUpInside)

        self.view.addSubview(textView)
        
        textView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        // 判断是否是回复其它用户
        if (detail_reply_loginname != nil) {
            textView.text = "@\(detail_reply_loginname!) "
        }
    }
    
    @objc func leftClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func rightClick() {
        if self.textView.text == nil || self.textView.text.count <= 0 {
            return;
        }
        self.view.makeToastActivity(.center)
        provider.request(.addReply(topic_id, UserDefaults.standard.string(forKey: "token")!, self.textView.text + REPLY_TAIL, self.reply_id)) { (res) in
            switch res {
            case .success(_):
                self.view.hideToastActivity()
                self.view.makeToast("回复成功")
                self.leftClick()
            case .failure(let error):
                UIAlertController.showAlert(message: error.errorDescription!)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.textView.becomeFirstResponder()
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
