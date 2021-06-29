//
// Copyright (c) 2021 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Adyen
import UIKit

internal final class WrapperViewController: UIViewController {

    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?
    private var leftConstraint: NSLayoutConstraint?

    internal lazy var requiresKeyboardInput: Bool = heirarchyRequiresKeyboardInput(viewController: child)

    internal let child: ModalViewController

    internal init(child: ModalViewController) {
        self.child = child
        super.init(nibName: nil, bundle: nil)

        positionContent(child)
    }

    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func heirarchyRequiresKeyboardInput(viewController: UIViewController?) -> Bool {
        if let viewController = viewController as? FormViewController {
            return viewController.requiresKeyboardInput
        }

        return viewController?.children.contains(where: { heirarchyRequiresKeyboardInput(viewController: $0) }) ?? false
    }

    internal func updateFrame(keyboardRect: CGRect) {
        guard let view = child.viewIfLoaded, let window = UIApplication.shared.keyWindow else { return }
        let finalFrame = child.finalPresentationFrame(in: window, keyboardRect: keyboardRect)
        topConstraint?.constant = finalFrame.origin.y
        leftConstraint?.constant = finalFrame.origin.x
        rightConstraint?.constant = -finalFrame.origin.x
        view.layoutIfNeeded()
    }

    fileprivate func positionContent(_ child: ModalViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = child.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        let bottomConstraint = child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let leftConstraint = child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let rightConstraint = child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        NSLayoutConstraint.activate([
            leftConstraint,
            rightConstraint,
            bottomConstraint,
            topConstraint
        ])
        self.topConstraint = topConstraint
        self.bottomConstraint = bottomConstraint
        self.leftConstraint = leftConstraint
        self.rightConstraint = rightConstraint
    }

}

extension ModalViewController {

    private var leastPresentableHeightScale: CGFloat { 0.25 }
    private var greatestPresentableHeightScale: CGFloat {
        UIApplication.shared.statusBarOrientation.isPortrait ? 0.9 : 1
    }

    /// Enables any `UIViewController` to recalculate it's conten's size form modal presentation ,
    /// e.g `viewController.adyen.finalPresentationFrame(in:keyboardRect:)`.
    /// :nodoc:
    func finalPresentationFrame(in containerView: UIView, keyboardRect: CGRect = .zero) -> CGRect {
        var frame = containerView.bounds

        if UIDevice.current.userInterfaceIdiom == .pad {
            let width = min(frame.width * 0.85, 375 * UIScreen.main.scale)
            frame.origin.x = (frame.width - width) / 2
            frame.size.width = width
        }

        let smallestHeightPossible = frame.height * leastPresentableHeightScale
        let biggestHeightPossible = frame.height * greatestPresentableHeightScale
        guard preferredContentSize != .zero else { return frame }

        let bottomPadding = max(abs(keyboardRect.height), containerView.safeAreaInsets.bottom)
        let expectedHeight = preferredContentSize.height + bottomPadding

        func calculateFrame(for expectedHeight: CGFloat) {
            frame.origin.y += frame.size.height - expectedHeight
            frame.size.height = expectedHeight
        }

        switch expectedHeight {
        case let height where height < smallestHeightPossible:
            calculateFrame(for: smallestHeightPossible)
        case let height where height > biggestHeightPossible:
            calculateFrame(for: biggestHeightPossible)
        default:
            calculateFrame(for: expectedHeight)
        }

        return frame
    }

}
