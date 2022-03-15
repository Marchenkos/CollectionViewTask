import UIKit

class NavigationTransition: NSObject {
    var recColor: UIColor = .green
    var startPoint: CGPoint = .zero

    enum NavigationTransitionMode: Int {
        case present, dismiss, pop
    }

    var transitionMode: UINavigationController.Operation = .push
    var animationDuraction = 1.4
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

            toView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            toView.center = startPoint

            containerView.addSubview(toView)

            UIView.animate(withDuration: animationDuraction, animations: {
                toView.transform = CGAffineTransform.identity
                toView.center = presentedViewCenter
            }, completion: { (success: Bool) in
                transitionContext.completeTransition(success) })
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)

            UIView.animate(withDuration: animationDuraction, animations: {
                fromView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                fromView.center = self.startPoint
            }, completion: { (success: Bool) in
                fromView.removeFromSuperview()

                transitionContext.completeTransition(success) })
        }
    }
}
