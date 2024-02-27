//

import UIKit

class CollectionCell: UICollectionViewCell {}

class ViewController: UIViewController {
    let numberOfItems = 30
    let margin = CGFloat(24)
    let itemsSpacing = CGFloat(16)
    let itemWidth = CGFloat(300)
    let itemHeight = CGFloat(600)

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = itemsSpacing
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.decelerationRate = .normal
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        collectionView.contentSize = CGSize(
            width: itemWidth * CGFloat(numberOfItems) + itemsSpacing * CGFloat(numberOfItems - 1) + margin * 2,
            height: collectionView.frame.height
        )

        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.describing)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.describing, for: indexPath)
        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 12.0
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let targetXContentOffset = CGFloat(targetContentOffset.pointee.x)
        let nearestPage = round( (targetXContentOffset - itemsSpacing) / (itemsSpacing + itemWidth) )
        let nearestPageTargetXContentOffset = nearestPage * (itemsSpacing + itemWidth)

        let point = CGPoint(x: nearestPageTargetXContentOffset, y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
}
