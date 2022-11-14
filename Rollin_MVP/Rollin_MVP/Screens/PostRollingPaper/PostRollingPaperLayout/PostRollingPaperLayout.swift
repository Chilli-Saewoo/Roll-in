//
//  PinterestLayout.swift
//  Rollin_MVP
//
//  Created by Yoonjae on 2022/11/12.
//

import UIKit

protocol PostRollingPaperLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat
}

 final class PostRollingPaperLayout: UICollectionViewLayout {
    weak var delegate: PostRollingPaperLayoutDelegate?

    private var numberOfColumns: Int = 2
    private var cellPadding: CGFloat = 7.0
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0.0

    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0.0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    // 바로 다음에 위치할 cell의 위치를 구하기 위해서 xOffset, yOffset 계산
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        cache.removeAll()

        // xOffset 계산
        let columnWidth: CGFloat = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            let offset = CGFloat(column) * columnWidth
            xOffset += [offset]
        }

        // yOffset 계산
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            let imageHeight = delegate?.collectionView(collectionView, heightForImageAtIndexPath: indexPath) ?? 0
            let height = cellPadding * 2 + imageHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            // cache 저장
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            // 새로 계산된 항목의 프레임을 설명하도록 확장
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height

            // 다음 항목이 다음 열에 배치되도록 설정
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }

    // rect에 따른 layoutAttributes를 얻는 메서드 재정의
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { rect.intersects($0.frame) }
    }

    // indexPath에 따른 layoutAttribute를 얻는 메서드 재정의
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }

}

