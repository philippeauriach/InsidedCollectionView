//
//  InsidedCollectionView.swift
//  Halieuti
//
//  Created by Philippe Auriach on 05/12/2018.
//  Copyright © 2018 Philippe Auriach. All rights reserved.
//

import UIKit
import Differ

open class InsidedCollectionViewManager : NSObject {

    public var range = 6

    public init(range: Int) {
        self.range = range
    }

    /// return the number of elements when adding inserted indexes
    open func numberOfElementCountingInserted(inCount: Int) -> Int {
        let nb = inCount + Int(floor(Double(inCount / range)))
        return nb
    }

    /// Return the computed index path by taking into account the inserted ones. Used by the collectionview to display the cells.
    open func fakeIndexPath(_ indexPath: IndexPath) -> IndexPath {
        var idxPath = indexPath
        idxPath.row = idxPath.row + numberOfElementCountingInserted(inCount: indexPath.row)
        return idxPath
    }

    /// Return the index path without taking into account the inserted ones. Used by developer to fill his collectionview as usual, without taking care of inserted indexes.
    open func trueIndexPath(_ indexPath: IndexPath) -> IndexPath {
        let newRow = indexPath.row - Int(ceil(Double((indexPath.row) / (range+1))))
        var idxPath = indexPath
        idxPath.row = Int(newRow)
        return idxPath
    }

    /// returns true if the indexPath passed corresponds to an inserted cell
    open func isInserted(indexPath: IndexPath) -> Bool {
        let isIt: Bool = (indexPath.row % (range+1)) == range
        return isIt
    }

    /// returns the index of the inserted element, in the inserted list (third inserted item will return 2)
    open func insertedIndex(indexPath: IndexPath) -> IndexPath {
        let row = Int(ceil(Double(indexPath.row / (range))))
        var idxPath = indexPath
        idxPath.row = row
        return idxPath
    }

    fileprivate func getRepresentation(count: Int) -> [String] {
        let totalCount = numberOfElementCountingInserted(inCount: count)
        var results = [String]()
        for i in 0..<totalCount {
            let idxPath = IndexPath(row: i, section: 0)
            if isInserted(indexPath: idxPath) {
                results.append("inserted:\(insertedIndex(indexPath: idxPath).row)")
            } else {
                results.append("normal:\(trueIndexPath(idxPath).row)")
            }
        }
        return results
    }

    fileprivate func getRepresentationWithoutInsert(count: Int) -> [String] {
        var results = [String]()
        for i in 0..<count {
            let idxPath = IndexPath(row: i, section: 0)
            results.append("normal:\(idxPath.row)")
        }
        return results
    }

    fileprivate func fillWithInserts(representation: [String]) -> [String] {
        var representation = representation
        let finalCount = numberOfElementCountingInserted(inCount: representation.count)
        for i in 0..<finalCount {
            let idxPath = IndexPath(row: i, section: 0)
            if(isInserted(indexPath: idxPath)) {
                representation.insert("inserted:\(idxPath.row)", at: idxPath.row)
            }
        }
        return representation
    }

    fileprivate func update(collectionView: UICollectionView, withPreviousRepresentation: [String], andNewRepresentation: [String]) {
        let previousRepresentation = fillWithInserts(representation: withPreviousRepresentation)
        let newRepresentation = fillWithInserts(representation: andNewRepresentation)

        let diff = previousRepresentation.extendedDiff(newRepresentation)
        let update = BatchUpdate(diff: diff)

        collectionView.deleteItems(at: update.deletions)
        collectionView.insertItems(at: update.insertions)
        update.moves.forEach { collectionView.moveItem(at: $0.from, to: $0.to) }
    }

    open func insertItems(at indexPaths: [IndexPath], beforeCount: Int, inCollectionView: UICollectionView) {
        var indexPaths = indexPaths
        indexPaths.sort { (a, b) -> Bool in
            return a.row < b.row
        }

        let previousRepresentation = getRepresentationWithoutInsert(count: beforeCount)
        var newRepresentation = previousRepresentation

        indexPaths.forEach { (indexPath: IndexPath) in
            newRepresentation.insert("new:\(indexPath.row)", at: indexPath.row)
        }

        update(collectionView: inCollectionView, withPreviousRepresentation: previousRepresentation, andNewRepresentation: newRepresentation)
    }

    open func deleteItems(at indexPaths: [IndexPath], beforeCount: Int, inCollectionView: UICollectionView) {
        var indexPaths = indexPaths
        indexPaths.sort { (a, b) -> Bool in
            return a.row > b.row
        }

        let previousRepresentation = getRepresentationWithoutInsert(count: beforeCount)
        var newRepresentation = previousRepresentation

        indexPaths.forEach { (indexPath: IndexPath) in
            newRepresentation.remove(at: indexPath.row)
        }

        update(collectionView: inCollectionView, withPreviousRepresentation: previousRepresentation, andNewRepresentation: newRepresentation)
    }

    open func reloadItems(at indexPaths: [IndexPath], inCollectionView: UICollectionView) {
        let indexPaths = indexPaths.map { fakeIndexPath($0) }
        inCollectionView.reloadItems(at: indexPaths)
    }

    open func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath, inCollectionView: UICollectionView) {
        inCollectionView.moveItem(at: fakeIndexPath(indexPath), to: fakeIndexPath(newIndexPath))
    }
}
