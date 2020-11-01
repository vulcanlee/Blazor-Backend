# Bazor Server 制式開發專案範例原始碼

這裡提供使用 Syncfusion for Blazor 元件的標準開發專案原始碼，只要有受過這方面的教育訓練之後，若想要自行開始開發一個 Blazor Sever-Side 的專案，無需自行建立相關專案、相關方案資料夾、加入參考，便可以複製這份專案開始進行後續開發作業，大幅提升新專案的開發效率。該專案也已經針對 Cookie Base & JWT Base 的認證和授權方面的程式碼加入在該專案內，並且提供一個簡單的登入與登出的 Razor View 頁面，方便根據日後不同需要，自行來做修正。

這個專案範例將會使用 EF Core Database First 、Syncfusion 元件、AutoMapper

* 單一資料表的 CRUD 新增、修改、刪除、查詢、搜尋、排序、分頁之設計方式
* 一對多的 CRUD 練習
* 可以開啟視窗，選擇其他資料表內的紀錄

## 使用方式

* 使用 Database\SchemaAndData.sql 在本機 localDB 資料庫內，建立範例資料庫
* 可以開始執行該 Blazor 專案，觀看預設的程式碼運作效果

## 方便開發摘要內容

OrderItem

OrderItemService        `註冊服務`

OrderItemSort

OrderItemAdapterModel   `加入Form Validation 屬性宣告` `註冊 AutoMapper`

OrderItemAdapter

OrderItemRazorModel      `註冊服務`

OrderItemView

OrderItemPage           `註冊功能表選項`

ProductPicker

OrderItemByOrderView

