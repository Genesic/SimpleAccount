# SimpleAccount
這是為了練習swift和xcode所製作的簡單記帳app<br>
這個app可以統計和記錄每一天的收入與支出<br>

## 功能介紹
- 可以選擇日期紀錄多筆不同的帳目
- 除了文字外也可以使用圖片表示該帳目
- 附有每月總收入、總支出、以及整月總和的統計

## 畫面介紹
此app有兩個主要畫面<br>
使用UITabBarController控制這兩個畫面的切換<br>
<br>
###帳目畫面
以下是『帳目』的畫面<br>
此畫面主要是提供使用者輸入帳目的功能<br>
![alt tag](https://cloud.githubusercontent.com/assets/11774467/15350669/338b4526-1d0d-11e6-8a8e-9a845066f649.png)
<br>
####(1) 日期區
 當點擊日期(藍色部分)時會出現日曆供使用者選擇日期<br>
####(2) 總合區：
 統計`(4)帳目區`內的所有帳目總和<br>
####(3) 新增區：
 可以輸入項目和金額，也可以點擊image按鈕替此筆帳目增加圖片或是拍照<br>
 當項目、金額、圖片有任何改變時，新增按鈕將會亮起，點擊後即可新增帳目<br>
####(4) 帳目區：
 顯示目前已有的所有帳目，可以直接進行修改，或是按下刪除按鈕可以刪除此筆帳目
####(5) 畫面選項區：
 選擇目前是要顯示[帳目畫面](#帳目畫面)還是[統計畫面](#統計畫面)
 
[PDTSimpleCalendarView]: https://github.com/jivesoftware/PDTSimpleCalendar

###統計畫面
以下是『統計』的畫面<br>
此畫面主要是提供使用者查詢各月份金額統計<br>
![alt tag](https://cloud.githubusercontent.com/assets/11774467/15350679/3c8003c4-1d0d-11e6-8e09-279bfe688074.png)
<br>
各月份開啟畫面時會如(1)所顯示<br>
點擊箭頭時會如(2)所示可以展開查詢總收入和總支出<br>

###APP簡介
* 語言使用**swift**
* 資料使用 **SQLite** ~~json儲存txt檔案~~ 儲存
* 遵守MVC開發模型
* 使用`UIImagePickerController`取得圖片，可以選擇要使用相簿內的圖還是相機拍照
* 介面使用Storyboard建置，本專案目前有三個storyboard
 * Main.storyboard：使用UITabBarController連接[帳目畫面](#帳目畫面)和[統計畫面](#統計畫面)
 * Account.storyboard：顯示[帳目畫面](#帳目畫面)
 * Statistic.storyboard：顯示[統計畫面](#統計畫面)，繼承UITableViewController，table的cell使用xib製作
* 使用的第三方lib(SQLite.swift使用[Carthage])
 * [PDTSimpleCalendarView]: 日曆套件
 * [SQLite.swift]: SQLite套件

[Carthage]: https://github.com/Carthage/Carthage
[SQLite.swift]: https://github.com/stephencelis/SQLite.swift
