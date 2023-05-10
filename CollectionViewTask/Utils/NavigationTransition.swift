import UIKit

class NavigationTransition: NSObject {
    var recColor: UIColor = .green
    var rectangle: UIView = UIView()

    var rectangleFrame: CGRect = .zero {
        didSet {
            rectangle.frame = rectangleFrame
        }
    }
    
    var startPoint: CGPoint = .zero {
        didSet {
            rectangle.center = startPoint
        }
    }

    enum Constants {
        static let animationDuration = 1.4
        static let showViewAnimationDuration = 0.2
        static let rectangleAnimationDution = animationDuration - showViewAnimationDuration
        static let minAlphaValue: CGFloat = 0
        static let maxAlphaValue: CGFloat = 1
        static let minScaleFactor: CGFloat = 0.3
        static let maxScaleFactor: CGFloat = 10.0
    }

    enum NavigationTransitionMode: Int {
        case present, dismiss, pop
    }

    var transitionMode: UINavigationController.Operation = .push
}

extension NavigationTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constants.animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }

        if transitionMode == .push {
            let presentedViewCenter = toView.center

            rectangle.backgroundColor = recColor
            rectangle.transform = CGAffineTransform(scaleX: Constants.minScaleFactor, y: Constants.minScaleFactor)

            toView.alpha = Constants.minAlphaValue
        
            containerView.addSubview(toView)
            containerView.addSubview(rectangle)

            UIView.animate(withDuration: Constants.rectangleAnimationDution, animations: {
                self.rectangle.transform = CGAffineTransform(scaleX: Constants.maxScaleFactor, y: Constants.maxScaleFactor)

                self.rectangle.center = presentedViewCenter
            })
            
            UIView.animate(withDuration: Constants.showViewAnimationDuration, delay: Constants.rectangleAnimationDution, animations: {
                toView.alpha = Constants.maxAlphaValue
            }, completion: { (success: Bool) in
                transitionContext.completeTransition(success) })
            
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)

            UIView.animate(withDuration: Constants.showViewAnimationDuration, animations: {
                fromView.alpha = Constants.minAlphaValue
            })

            UIView.animate(withDuration: Constants.rectangleAnimationDution, animations: {
                self.rectangle.transform = CGAffineTransform.identity
                self.rectangle.transform = CGAffineTransform(scaleX: Constants.minScaleFactor, y: Constants.minScaleFactor)
                self.rectangle.center = self.startPoint
            }, completion: { (success: Bool) in
                fromView.removeFromSuperview()
                self.rectangle.removeFromSuperview()

                transitionContext.completeTransition(success) })
        }
    }
}
