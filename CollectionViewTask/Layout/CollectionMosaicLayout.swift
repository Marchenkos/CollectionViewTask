import UIKit

class CollectionMosaicLayout: UICollectionViewLayout {
    private enum Constants {
        static let numberOfColumns = 3
        static let cellPadding = 8.0
    }

    private var cachedAttributes = [UICollectionViewLayoutAttributes]()

    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }

        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override public var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        cachedAttributes.removeAll()

        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: Constants.cellPadding,
            bottom: Constants.cellPadding,
            right: Constants.cellPadding
        )

        let columnWidth = contentWidth / CGFloat(Constants.numberOfColumns)
        var yOffset = [CGFloat](repeating: 0, count: Constants.numberOfColumns)

        var columnIndex = 0
        var currentIndex = 0

        while currentIndex < collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: currentIndex, section: 0)
            let xOffset = CGFloat(columnIndex) * columnWidth
            let cellHeight = CGFloat.random(in: 30..<300)

            let frame = CGRect(x: xOffset, y: yOffset[columnIndex], width: columnWidth, height: cellHeight)
            let insetFrame = frame.insetBy(dx: Constants.cellPadding, dy: Constants.cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

            attributes.frame = insetFrame
            cachedAttributes.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
            yOffset[columnIndex] = yOffset[columnIndex] + cellHeight

            columnIndex = columnIndex >= (Constants.numberOfColumns - 1) ? 0 : columnIndex + 1
            currentIndex += 1
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cachedAttributes {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
