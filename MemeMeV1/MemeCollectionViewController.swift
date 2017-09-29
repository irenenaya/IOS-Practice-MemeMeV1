//
//  MemeCollectionViewController.swift
//  MemeMeV1
//
//  Created by Irene Naya on 9/27/17.
//  Copyright © 2017 OnkySoft. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var MemeCollection: UICollectionView!
    
    @IBOutlet weak var memeViewFlow: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        let space : CGFloat = 3.0
        let dimension = (view.frame.size.width - 2*space) / 2
        
        memeViewFlow.minimumInteritemSpacing = space
        memeViewFlow.minimumLineSpacing = space
        memeViewFlow.itemSize = CGSize(width: dimension, height: dimension)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        MemeCollection.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Meme.allMemes.count
           }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("colls")
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeIdentifier",  forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = Meme.allMemes[(indexPath.row)]
        
        cell.memeImage.image = meme.memedImage
        cell.memeName.text = meme.toptext + " " + meme.bottomtext
     
        return cell
    }
    

}
