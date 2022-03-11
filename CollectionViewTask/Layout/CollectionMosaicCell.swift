import UIKit

class CollectionMosaicCell: UICollectionViewCell {
    static let identifer = "CollectionMosaicCellIdentifer"

    private func generateRandomColor() -> UIColor {
      let hue : CGFloat = CGFloat(arc4random() % 256) / 256
      let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
      let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
            
      return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.clipsToBounds = true
        self.backgroundColor = generateRandomColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
