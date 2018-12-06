//
//  ViewController.swift
//  InsidedCollectionView
//
//  Created by Philippe Auriach on 06/12/2018.
//  Copyright © 2018 PhilippeAuriach. All rights reserved.
//

import UIKit
import InsidedCollectionView

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let insideCollectionViewManager = InsidedCollectionViewManager(range: 3)

    var itemsCount = 5

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    @IBAction func onSliderValueChanged(_ sender: UISlider) {
        let value = Int(round(sender.value))
        insideCollectionViewManager.range = value
        collectionView.reloadData()
    }

    fileprivate func insert(items: Int, at: Int) {
        let beforeCount = itemsCount
        itemsCount += items

        collectionView.performBatchUpdates({
            let indexPaths: [IndexPath] = (0..<items).map({ (i) -> IndexPath in
                return IndexPath(row: at + i, section: 0)
            })

            insideCollectionViewManager.insertItems(at: indexPaths, beforeCount: beforeCount, inCollectionView: collectionView)
        }, completion: nil)
    }

    fileprivate func delete(items: Int, at: Int) {
        let beforeCount = itemsCount
        itemsCount -= items

        collectionView.performBatchUpdates({
            let indexPaths: [IndexPath] = (0..<items).map({ (i) -> IndexPath in
                return IndexPath(row: at + i, section: 0)
            })

            insideCollectionViewManager.deleteItems(at: indexPaths, beforeCount: beforeCount, inCollectionView: collectionView)
        }, completion: nil)
    }

    @IBAction func insertOne(_ sender: Any) {
        insert(items: 1, at: 3)
    }

    @IBAction func insertThree(_ sender: Any) {
        insert(items: 3, at: 0)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return insideCollectionViewManager.numberOfElementCountingInserted(inCount: itemsCount)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath)

        let label = cell.viewWithTag(110) as! UILabel

        if insideCollectionViewManager.isInserted(indexPath: indexPath) {
            cell.backgroundColor = UIColor.yellow
            label.text = "\(insideCollectionViewManager.insertedIndex(indexPath: indexPath).row) (\(indexPath.row))"
        } else {
            cell.backgroundColor = UIColor.random()
            label.text = nil // "\(insideCollectionViewManager.trueIndexPath(indexPath).row)"
        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        if insideCollectionViewManager.isInserted(indexPath: indexPath) {
            print("selected inserted item at", insideCollectionViewManager.insertedIndex(indexPath: indexPath).row)
        } else {
            let trueIndex = insideCollectionViewManager.trueIndexPath(indexPath)
            print("selected item at",  trueIndex.row)
            delete(items: 3, at: trueIndex.row)
        }
    }
}
