//
//  FakeDataManager.swift
//  Peach
//
//  Created by dean on 2019/8/28.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

class FakeDataManager {
    //Singleton
    static let shared = FakeDataManager()
    /*  can also use paramater to init
     let baseURL = ""
     private int(url:String) {
     self.baseURL = url
     }
     */
    //Initialization
    private init() {
        
    }
    
    func fakeCity(number:Int) -> Array<String>{
        let cityArr = ["台北", "台中", "高雄", "不好說", "吉利馬扎羅"]
        var final = [""]
        final.removeAll()
        for _ in 0 ... number {
            final.append(cityArr.randomElement() ?? "")
        }
        return final
    }
    func fakeImageURL(number:Int) -> Array<String> {
        let imageArr = ["http://www.instyle.tw/uploads/article/934/4.JPG","http://g.udn.com.tw/upfiles/B_AL/albertswafford353/PSN_PHOTO/457/f_14776457_1.jpg","https://cdn2.ettoday.net/images/4031/d4031158.jpg","https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTW0-ltckU3uPCjC_Ex1TaHS5FVYyeB8p4RxWB7JlTkX9CZxNWC","https://img.ltn.com.tw/Upload/liveNews/BigPic/600_php5drqPd.jpg","https://s.zimedia.com.tw/s/s5qUrw-0","https://cdn2.ettoday.net/images/4040/d4040636.jpg","http://www.5didao.com/wp-content/uploads/2017/07/Flamingo-Beach-2-2-1280x640.jpg","https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDvPoENYUD5-784QVVbTzx2ip51SeXd4TOAwRA5qJDwfqlOQn4","http://s2.itislooker.com/imgs/201901/05/10/15466544423912.jpg","https://cdn.clickme.net/gallery/b6783ab43ba37726e46b78b11fa3b4b1.jpeg"]
        var final = [""]
        final.removeAll()
        for _ in 0 ... number {
            final.append(imageArr.randomElement() ?? "")
        }
        return final
    }
    func fakeUserList() -> [FakeUserList]? {
        if let data = Bundle.jsonReader(fileName: "FakeUsers") {
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                print(jsonResult)
                let fakeUsers = try JSONDecoder().decode([FakeUserList].self,from: data)
                return fakeUsers
            } catch {
                return nil
            }
            
        }
        return nil
    }
    func fakeUserListRowItem(number:Int,type:RowTypes, tableViewCell: UITableViewCell.Type?, collectionViewCell: UICollectionViewCell.Type?) -> Array<ListRowItem> {
        let nameArr = ["🗽小甜甜🍑", "✡大星星✴", "左🗿奶奶", "🇨🇽右邊邊", "吉利馬扎羅📌"]
        var final = [ListRowItem]()
        for _ in 0 ..< number {
            let name = nameArr.randomElement()
            let images = fakeImageURL(number: number)
            let backGround = URL.getRandomImageURL()
            let value = ["name":name ?? "","image":images[number],"backGround":backGround] as [String : Any]
            let row = ListRowItem(type: type, value: value, tableViewCell: tableViewCell, collectionViewCell: collectionViewCell)
            final.append(row)
        }
        return final
    }
}
