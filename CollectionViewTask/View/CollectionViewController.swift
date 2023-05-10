import UIKit

class CollectionViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView?
    private var itemsCount = Int.random(in: 5..<10)
    private let transition = NavigationTransition()

    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        let indexPath = IndexPath(row: itemsCount - 1, section: 0)
        itemsCount += 1
        
        guard let collectionView = self.collectionView else {
            preconditionFailure("Failed to access collection view")
        }

        collectionView.insertItems(at: [indexPath])
    }
    
    @IBAction func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        guard let gestureView = gesture.view, let collectionView = self.collectionView else { return }

        let detailView = DetailsViewController()
        
        let calculatedOrigins = CGPoint(
            x: gestureView.frame.origin.x + CollectionMosaicLayout.Constants.cellPadding,
            y: gestureView.frame.origin.y + collectionView.frame.origin.y
        )
        
        let calculatedCenterPoint = CGPoint(
            x: gestureView.center.x + CollectionMosaicLayout.Constants.cellPadding,
            y: gestureView.center.y + collectionView.frame.origin.y
        )
    
        transition.startPoint = calculatedCenterPoint
        transition.rectangleFrame = CGRect(origin: calculatedOrigins, size: gestureView.frame.size)

        if let cellBackgroundColor = gestureView.backgroundColor {
            detailView.viewCustomColor = cellBackgroundColor
            transition.recColor = cellBackgroundColor
        }

        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    @IBAction func handleSingleTap(_ gesture: UITapGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        
        gestureView.backgroundColor = randomColor()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
        guard let collectionView = self.collectionView else {
            preconditionFailure("Failed to access collection view")
        }

        collectionView.autoresizingMask = [.flexibleHeight]
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self

        collectionView.collectionViewLayout = CollectionMosaicLayout()

        collectionView.register(CollectionMosaicCell.self, forCellWithReuseIdentifier: CollectionMosaicCell.Constants.cellId)
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionMosaicCell.Constants.cellId,
            for: indexPath
        ) as? CollectionMosaicCell else { preconditionFailure("Failed to load collection view cell") }
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        singleTap.numberOfTapsRequired = 1
        cell.addGestureRecognizer(singleTap)

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        cell.addGestureRecognizer(doubleTap)

        singleTap.require(toFail: doubleTap)

        return cell
    }
}

extension CollectionViewController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
      transition.transitionMode = operation

      return transition
    }
}
