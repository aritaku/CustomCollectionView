//
//  ViewController.swift
//  CollectionViewCustom
//
//  Created by 有村 琢磨 on 2015/05/14.
//  Copyright (c) 2015年 有村 琢磨. All rights reserved.
//

import UIKit

class CollectionViewController:UICollectionViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var objects: NSArray! = []
    let API_KEY :String = "AIzaSyDbu0hCWS21FOP2DsBEjTO95NQ65MP_96s"
    var selectedURL :NSString = ""
    
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

    
    //API取得
    func searchWord(text :String){
        
        println("search text\(text)")
        
        //URLエンコーディング（文字列エスケープ処理）
        let searchWord:String! = text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        //Youtubeに対して、検索をかける文字列
        let urlString:String = "https://www.googleapis.com/youtube/v3/search?key=\(API_KEY)&q=healthcare&part=id,snippet&maxResults=10&order=viewCount"
        
        //api処理
        let url:NSURL! = NSURL(string: urlString)
        let urlRequest :NSURLRequest! = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(urlRequest,
            queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response,jsonData,error) -> Void in
            
                //データが取得できた場合にJSONを解析してNSDictionaryに格納
                let dic:NSDictionary = NSJSONSerialization.JSONObjectWithData(
                    jsonData!,
                    options: NSJSONReadingOptions.AllowFragments,
                    error: nil) as! NSDictionary
                //結果のJSON配列から必要なもののみ格納
                let resultArray: NSArray! = dic["items"] as! NSArray
                println(resultArray)
                //取得したデータの表示
                self.objects = resultArray
                self.collectionView!.reloadData()
        })
    }
    
    
    //MARK: - collectionView datasource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:CollectionViewCell! = collectionView.dequeueReusableCellWithReuseIdentifier("MyCell", forIndexPath: indexPath) as! CollectionViewCell
        
        //cellに表示するデータを１件だけ取得
        let record:NSDictionary = self.objects[indexPath.row]["snippet"] as! NSDictionary
        cell.textLabel?.text = record["titles"] as? String
        
        //（JSONデータから表示したいurlを設定）
        var urlString:NSString = (record["thumbnails"]!["default"] as! NSDictionary)["url"] as! String
        
        //サムネイル画像をNSDataにダウンロードし、imageViewに設定
        let imageData:NSData = NSData(contentsOfURL:NSURL(string:urlString as! String)!)!
        cell.cellImage?.image = UIImage(data: imageData)
        
        return cell
    }
    
    //MARK: collectionView delegate
    
    //MARK: collectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 170, height: 300)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    //MARK: - main
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchWord("healthcare")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

