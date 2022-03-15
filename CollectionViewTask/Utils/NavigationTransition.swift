import UIKit

class NavigationTransition: NSObject {
    var recColor: UIColor = .green
    var rectangle = UIView()

    var startPoint: CGPoint = .zero {
        didSet {
            rectangle.center = startPoint
        }
    }

    enum NavigationTransitionMode: Int {
        case present, dismiss, pop
    }

    var transitionMode: UINavigationController.Operation = .push
    var animationDuraction = 1.4

    func calculateFrameForRectungle(center viewCenter: CGPoint, size viewSize: CGSize, startPoint: CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)

        let offsetVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offsetVector, height: offsetVector)

        return CGRect(origin: .zero, size: size)
    }
}

extension NavigationTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuraction
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }

        if transitionMode == .push {
            let presentedViewCenter = toView.center
            let presentedViewSize = toView.frame.size

            rectangle.frame = calculateFrameForRectungle(center: presentedViewCenter, size: presentedViewSize, startPoint: startPoint)

            rectangle.center = startPoint
            rectangle.backgroundColor = recColor
            rectangle.transform = CGAffineTransform(scaleX: 0, y: 0)

            toView.alpha = 0

            containerView.addSubview(rectangle)
            containerView.addSubview(toView)

            UIView.animate(withDuration: animationDuraction, animations: {
                self.rectangle.transform = CGAffineTransform.identity

                toView.transform = CGAffineTransform.identity
                toView.center = presentedViewCenter

                self.rectangle.transform = CGAffineTransform.identity
            }, completion: { (success: Bool) in
                toView.alpha = 1
                transitionContext.completeTransition(success) })
        } else {
            let returningViewCenter = fromView.center
            let returningViewSize = fromView.frame.size

            rectangle.frame = calculateFrameForRectungle(center: returningViewCenter, size: returningViewSize, startPoint: startPoint)

            rectangle.center = startPoint
            rectangle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)

            containerView.insertSubview(toView, belowSubview: fromView)
            containerView.insertSubview(self.rectangle, belowSubview: fromView)

            UIView.animate(withDuration: animationDuraction, animations: {
                self.rectangle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                fromView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                fromView.center = self.startPoint
            }, completion: { (success: Bool) in
                fromView.center = returningViewCenter
                fromView.removeFromSuperview()
                self.rectangle.removeFromSuperview()

                transitionContext.completeTransition(success) })
        }
    }
}
