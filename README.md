# InsidedCollectionView

[![CI Status](https://img.shields.io/travis/PhilippeAuriach/InsidedCollectionView.svg?style=flat)](https://travis-ci.org/PhilippeAuriach/InsidedCollectionView)
[![Version](https://img.shields.io/cocoapods/v/InsidedCollectionView.svg?style=flat)](https://cocoapods.org/pods/InsidedCollectionView)
[![License](https://img.shields.io/cocoapods/l/InsidedCollectionView.svg?style=flat)](https://cocoapods.org/pods/InsidedCollectionView)
[![Platform](https://img.shields.io/cocoapods/p/InsidedCollectionView.svg?style=flat)](https://cocoapods.org/pods/InsidedCollectionView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

InsidedCollectionView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'InsidedCollectionView'
```

## Usage

Just import the module, instantiate a manager with the range you want, and use the manager methods to get your proper indexes instead of the computed ones

```swift
import InsidedCollectionView

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let insideCollectionViewManager = InsidedCollectionViewManager(range: 3)
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return insideCollectionViewManager.numberOfElementCountingInserted(inCount: itemsCount)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath)
        
        if insideCollectionViewManager.isInserted(indexPath: indexPath) {
            let adIndexPath = insideCollectionViewManager.insertedIndex(indexPath: indexPath)
            cell.configureAd(adNumber: adIndexPath.row)
        } else {
            let myIndexPath = insideCollectionViewManager.trueIndexPath(indexPath: indexPath)
            let item = items[myIndexPath.row]
            cell.configure(item)
        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if insideCollectionViewManager.isInserted(indexPath: indexPath) {
            print("selected inserted item at", insideCollectionViewManager.insertedIndex(indexPath: indexPath).row)
        } else {
            let trueIndex = insideCollectionViewManager.trueIndexPath(indexPath)
            print("selected item at",  trueIndex.row)
        }
    }
}

```

You can change the range at runtime, but remember to call `reloadData` on your collectionView !
```swift
insideCollectionViewManager.range = 14
collectionView.reloadData()
```

If you want to insert / delete / move items, use the corresponding methods of `InsidedCollectionViewManager` :
```swift
open func insertItems(at indexPaths: [IndexPath], beforeCount: Int, inCollectionView: UICollectionView)
open func deleteItems(at indexPaths: [IndexPath], beforeCount: Int, inCollectionView: UICollectionView)
open func reloadItems(at indexPaths: [IndexPath], inCollectionView: UICollectionView)
open func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath, inCollectionView: UICollectionView)
```

For insertion and deletion, you must pass the number of items (your items, not counting inserted ones) that are here BEFORE your insertion / deletion. That way the manager can compute how many inserted cells are needed, insert and add them accoridngly, and add your new items at their proper new index. See the example if needed.

## Author

Philippe Auriach

## License

InsidedCollectionView is available under the MIT license. See the LICENSE file for more info.
