//
//  ViewController.swift
//  Alamofire_Kanna_firstTry
//
//  Created by 塩澤響 on 2020/02/08.
//  Copyright © 2020 塩澤響. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
    }
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textFiled4: UITextField!
    @IBOutlet weak var textField5: UITextField!
    
    
    
    @IBAction func buttonPushed(_ sender: UIButton) {
        var urlArray:[String] = []

        if self.textField1.text != ""{
            urlArray.append(self.textField1.text!)
        }
        if self.textField2.text != ""{
            urlArray.append(self.textField2.text!)
        }
        if self.textField3.text != ""{
            urlArray.append(self.textField3.text!)
        }
        if self.textFiled4.text != ""{
            urlArray.append(self.textFiled4.text!)
        }
        if self.textField5.text != ""{
            urlArray.append(self.textField5.text!)
        }
        let userDefaults = UserDefaults.standard
        //setする前に空にする
        userDefaults.removeObject(forKey: "playerUrl")
        userDefaults.synchronize()
        //urlArrayを保存する
        userDefaults.set(urlArray,forKey: "playerUrl")
        userDefaults.synchronize()
        //画面遷移
        performSegue(withIdentifier: "goPlayers", sender: nil)
    }
    
}



//////////////////////////////////////
/*
 参考文献
 classとstructの違い
 https://qiita.com/narukun/items/24d9e68ff965f8da09ad
 
*/

