import UIKit

class ViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    private var itemsCount = Int.random(in: 5..<10)

    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        let indexPath = IndexPath(row: itemsCount - 1, section: 0)
        itemsCount += 1

        collectionView.insertItems(at: [indexPath])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.autoresizingMask = [.flexibleHeight]
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.collectionViewLayout = CollectionMosaicLayout()

        collectionView.register(CollectionMosaicCell.self, forCellWithReuseIdentifier: CollectionMosaicCell.identifer)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionMosaicCell.identifer,
            for: indexPath
        ) as? CollectionMosaicCell else { preconditionFailure("Failed to load collection view cell") }

        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = randomColor()
    }
}
