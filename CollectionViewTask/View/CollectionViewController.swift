import UIKit

class CollectionViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    private var itemsCount = Int.random(in: 5..<10)
    private let transition = NavigationTransition()

    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        let indexPath = IndexPath(row: itemsCount - 1, section: 0)
        itemsCount += 1

        collectionView.insertItems(at: [indexPath])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self

        collectionView.autoresizingMask = [.flexibleHeight]
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.collectionViewLayout = CollectionMosaicLayout()

        collectionView.register(CollectionMosaicCell.self, forCellWithReuseIdentifier: CollectionMosaicCell.identifer)
    }
}

extension CollectionViewController: UICollectionViewDataSource {
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

extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // UPDATE CELL BACKGROUND ON CLICK

//        guard let cell = collectionView.cellForItem(at: indexPath) else { preconditionFailure("Failed to load collection view cell") }
//
//        cell.backgroundColor = randomColor()
        



        // NAVIGATE TO ANOTHER SCREEN ON CLICK

        guard let cell = collectionView.cellForItem(at: indexPath) else { preconditionFailure("Failed to load collection view cell") }

        let detailView = DetailsViewController()
        transition.startPoint = cell.center

        if let cellBackgroundColor = cell.backgroundColor {
            detailView.viewCustomColor = cellBackgroundColor

            transition.recColor = cellBackgroundColor
        }

        self.navigationController?.pushViewController(detailView, animated: true)
    }
}

extension CollectionViewController: UINavigationControllerDelegate {
    func navigationController(_
      navigationController: UINavigationController,
      animationControllerFor operation: UINavigationController.Operation,
      from fromVC: UIViewController,
      to toVC: UIViewController) ->
      UIViewControllerAnimatedTransitioning? {
      transition.transitionMode = operation

      return transition
    }
}
