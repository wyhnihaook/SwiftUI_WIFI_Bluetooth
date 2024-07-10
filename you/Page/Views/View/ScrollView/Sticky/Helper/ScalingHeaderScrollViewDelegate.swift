//
//  ScalingHeaderScrollViewDelegate.swift
//  you
//
//  Created by 翁益亨 on 2024/7/4.
//


import UIKit

final class ScalingHeaderScrollViewDelegate: NSObject, ObservableObject, UIScrollViewDelegate {
    
    var didPullToRefresh: () -> Void = { }
    var didPullToLoadMore: () -> Void = { }
    var didScroll: () -> Void = {}
    var didEndDragging = {}
    var didEndDecelerating = {}
    var willEndDragging: (Double) -> Void = {_ in }
    var didReachBottom: () -> Void = {}
    
    // weak to prevent memory leaks on iOS > 17.0 with UIScrollView in ScalingHeaderScrollView
    weak var uiScrollView: UIScrollView?

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll()
        let maxYOffset = scrollView.contentSize.height - scrollView.bounds.height
        if scrollView.contentOffset.y >= maxYOffset {
            didReachBottom()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        willEndDragging(velocity.y)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -60 {
            didPullToRefresh()
        }
        let maxYOffset = scrollView.contentSize.height - scrollView.bounds.height
        if scrollView.contentOffset.y > maxYOffset + 60 {
            didPullToLoadMore()
        }

        didEndDragging()
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        didEndDragging()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndDecelerating()
    }
}
