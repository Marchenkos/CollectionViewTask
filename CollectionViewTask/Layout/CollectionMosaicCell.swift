import UIKit

class CollectionMosaicCell: UICollectionViewCell {
    enum Constants {
        static let cellId = "CollectionMosaicCellIdentifer"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.clipsToBounds = true
        self.backgroundColor = randomColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
