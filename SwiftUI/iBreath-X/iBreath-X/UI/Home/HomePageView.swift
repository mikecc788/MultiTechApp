//
//  HomePageView.swift
//  iBreath-X
//
//  Created by app on 2024/8/28.
//

import SwiftUI


struct HomePageView<Content: View>: UIViewControllerRepresentable {
    let pageWidth: CGFloat
    let contentSize: CGSize
    let content: Content
    @Binding var leftPercent: CGFloat
    
    init(pageWidth: CGFloat,
         contentSize: CGSize,
         leftPercent: Binding<CGFloat>,
         @ViewBuilder content: () -> Content) {
        self.pageWidth = pageWidth
        self.contentSize = contentSize
        self.content = content()
        self._leftPercent = leftPercent
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = context.coordinator
        context.coordinator.scrollView = scrollView
        
        let vc = UIViewController()
        vc.view.addSubview(scrollView)
        
        let host = UIHostingController(rootView: content)
        vc.addChild(host)
        scrollView.addSubview(host.view)
        host.didMove(toParent: vc)
        context.coordinator.host = host
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let scrollView = context.coordinator.scrollView!
        scrollView.frame = CGRect(x: 0, y: 0, width: pageWidth, height: contentSize.height)
        scrollView.contentSize = contentSize
        scrollView.setContentOffset(CGPoint(x: leftPercent * (contentSize.width - pageWidth), y: 0), animated: true)
        context.coordinator.host?.view.frame = CGRect(origin: .zero, size: contentSize)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: HomePageView
        var scrollView: UIScrollView?
        var host: UIHostingController<Content>?
        
        init(_ parent: HomePageView) {
            self.parent = parent
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            // 计算当前页面并更新leftPercent
//            let offset = scrollView.contentOffset.x / (parent.contentSize.width - parent.pageWidth)
//            parent.leftPercent = min(max(offset, 0), 1)
            
            withAnimation {
                parent.leftPercent = scrollView.contentOffset.x <= parent.pageWidth * 0.5 ? 0 : 1
            }
        }
    }
}
