import UIKit

class ViewController: UIViewController {
    @IBOutlet var contentView: UIView!
    var collectionView: UICollectionView
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        itemsCount += 1
        print("lalala")
        let indexPath = IndexPath(row: itemsCount - 1, section: 0)
            collectionView.insertItems(at: [indexPath])
    }

    private var itemsCount = Int.random(in: 10..<50)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionLayout = CollectionMosaicLayout()
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: collectionLayout)
        collectionView.autoresizingMask = [.flexibleHeight]
        collectionView.alwaysBounceVertical = true
//        collectionView.indicatorStyle = .white
        collectionView.delegate = self
        collectionView.dataSource = self
    
        collectionView.register(CollectionMosaicCell.self, forCellWithReuseIdentifier: CollectionMosaicCell.identifer)
        
        self.contentView.addSubview(collectionView)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionMosaicCell.identifer, for: indexPath) as? CollectionMosaicCell
            else { preconditionFailure("Failed to load collection view cell") }

    
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
}
