//
//  playersViewController.swift
//  Alamofire_Kanna_firstTry
//
//  Created by 塩澤響 on 2020/02/11.
//  Copyright © 2020 塩澤響. All rights reserved.
//

import UIKit
import Alamofire
import Kanna


class playersViewController: UIViewController {


    var players:[Player] = []
    
    //画面遷移した時のみの処理なのでviewDidLoadでいい
    /*override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        let urlArray:[String] = userDefaults.array(forKey: "playerUrl") as! [String]
        
        for i in 0..<urlArray.count{
            if i == urlArray.count - 1{
                //print(urlArray.count)
                self.scrapWebsite(urlArray[i],lastTime: true)
                //print("players.count3:\(self.players.count)")
            }else{
                //print(urlArray[i])
                self.scrapWebsite(urlArray[i],lastTime: false)
               // print("players.count3:\(self.players.count)")
            }
        }
        print("players.count:\(players.count)")
        print("UserDefaults.urlArray.count:\(userDefaults.array(forKey: "playerUrl")?.count)")
        print("urlArray.count:\(urlArray.count)")
    }*/
    
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        let urlArray:[String] = userDefaults.array(forKey: "playerUrl") as! [String]
        
        for i in 0..<urlArray.count{
            if i == urlArray.count - 1{
                //print(urlArray.count)
                self.scrapWebsite(urlArray[i],lastTime: true)
                //print("players.count3:\(self.players.count)")
            }else{
                //print(urlArray[i])
                self.scrapWebsite(urlArray[i],lastTime: false)
                // print("players.count3:\(self.players.count)")
            }
        }
    }
    
    
    
    
    
    //////////////////////////////////////////////////////////////
    
    //選手データの構造体
    struct Player {
        var playerName:String = "-"
        var MaxLevel:String = "-"
        var abilityList:[(name:String,score:String)] = [("オフェンスセンス","1"),("ボールコントロール","2"),("ドリブル","3"),("ボ-ルキープ","4"),("グラウンダーパス","5"),("フライパス","6"),("決定力","7"),("ヘッダー","8"),("プレースキック","9"),("カーブ","10"),("スピード","11"),("瞬発力","12"),("キック力","13"),("ジャンプ","14"),("フィジカルコンタクト","15"),("ボディコントロール","16"),("スタミナ","17"),("ディフェンスセンス","18"),("ボール奪取","19"),("アグレッシブネス","20"),("GKセンス","21"),("キャッチング","22"),("クリアリング","23"),("コプラシング","24"),("ディフレクティング","25"),("総合値","26")]
    }

    
    
    /////////////////////////////////////////////////////////////
    
    
    func scrapWebsite(_ url:String,lastTime:Bool){
        //GETリクエスト 指定URLのコードを取得
        Alamofire.request(url).responseString { response in
            //Boolで確認
            print("true or fauls:\(response.result.isSuccess)")
            
            if let html = response.result.value {
                self.players.append(self.parseHTML(html: html))
            }
            if lastTime == true{
                self.SetView(self.players.count)
            }
        }
    }
    
    
    
    func parseHTML(html: String)-> (Player){
        //戻り値を宣言
        var returnPlayer = Player()
        
        if let doc = try? HTML(html: html, encoding: .utf8) {
            //タイトルをプリント
            //print("doc.titile:\(doc.title!)")
            
            if let playerName = doc.title{
                returnPlayer.playerName = String(playerName[playerName.index(playerName.startIndex, offsetBy: 0)...playerName.index(playerName.endIndex, offsetBy: -13)])
            }
            
            for link in doc.xpath("/html/body/div[2]/div[4]/script[1]/text()"){
                //アンラップ
                if let str:String = link.text{
                    //文字数の数をカウント
                    let strAllCount:Int = str[str.index(str.startIndex, offsetBy: 13)...str.index(str.endIndex, offsetBy: -3)].count
                    //マックスレベル
                    let MaxLevel:Int = (((strAllCount - 25)/26) - 1)/3
                    //print("Maxlevel:\(MaxLevel)")
                    returnPlayer.MaxLevel = String(MaxLevel)
                    //使う文字を抜き出し
                    let strAll:String = String(str[str.index(str.startIndex, offsetBy: 13)...str.index(str.endIndex, offsetBy: -3)])
                    for i in 0..<26{
                        let abilityStartIndex = (MaxLevel*3+1+1)*i + ((MaxLevel-1)*3+1)
                        
                        returnPlayer.abilityList[i].score = String(strAll[strAll.index(strAll.startIndex, offsetBy: abilityStartIndex)...strAll.index(strAll.startIndex, offsetBy: abilityStartIndex+1)])
                    }
                }
            }
        }
        print("returnPlayer:\(returnPlayer)")
        return returnPlayer
    }
    
    
    
    
    /////////////////////////////////////////////////////////////////
    //viewを設置する関数
    func SetView(_ playersNum:Int){
        guard playersNum != 0 else {
            print("選手情報なし")
            return
        }
        //画面サイズを取得
        let mainBoundSize: CGSize = UIScreen.main.bounds.size
        //使用するサイズを設定(上120は使わない)
        let useSize : CGSize = CGSize(width: mainBoundSize.width, height: mainBoundSize.height-120)
        //縦は26個分
        for y in 0..<26{
            //横は比較する選手の数+1(+1は各項目名用)
            for x in 0..<playersNum+1{
                //インスタンス化
                let label = UILabel()
                label.layer.borderWidth = 0.5  //枠の線の太さ=0.5
                label.layer.borderColor = UIColor.black.cgColor //枠の色は黒
                label.textAlignment = NSTextAlignment.center  //文字の位置はviewの中央
                label.textColor = UIColor.black //テキストの色は黒
                if x == 0{
                    label.frame = CGRect(x: 20, y: 120+Int(useSize.height/26)*y, width: 200, height: Int(useSize.height/26))
                    label.text = players[0].abilityList[y].name
                    //label.text = playersAbility[0][y-1].name
                }else{
                    label.frame = CGRect(x: 200+x*30, y: 120+Int(useSize.height/26)*y, width: 30, height: Int(useSize.height/26))
                    label.text = players[x-1].abilityList[y].score
                    //label.text = playersAbility[x-1][y-1].score
                }
                self.view.addSubview(label)
            }
        }
    }

}

//////////////////////////////////////////
/*
 参考文献
 DispatchQueue
 https://qiita.com/ShoichiKuraoka/items/bb2a280688d29de3ff18
 https://github.com/mixi-inc/iOSTraining/blob/master/Swift/pages/day3/1-2_Grand-Central-Dispatch.md
 
 
*/
