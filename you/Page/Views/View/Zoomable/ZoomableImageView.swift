//
//  ZoomableImageView.swift
//  you
//
//  Created by 翁益亨 on 2024/7/9.
//


//import SwiftUI
//import SDWebImageSwiftUI
//
//public struct ZoomableImageView<Content>: View where Content: View {
//    
//    private var url: URL
//    private var min: CGFloat = 1.0
//    private var max: CGFloat = 3.0
//    private var showsIndicators: Bool = false
//    @ViewBuilder private var overlay: () -> Content
//    
//    @State private var imageSize: CGSize = .zero
//    
//    /**
//     Initializes an `ZoomableImageView`
//     - parameter url : The image url.
//     - parameter min : The minimum value that can be zoom out.
//     - parameter max : The maximum value that can be zoom in.
//     - parameter showsIndicators : A value that indicates whether the scroll view displays the scrollable component of the content offset, in a way that’s suitable for the platform.
//     - parameter overlay : The ZoomableImageView view’s overlay.
//     */
//    public init(url: URL,
//                min: CGFloat = 1.0,
//                max: CGFloat = 3.0,
//                showsIndicators: Bool = false,
//                @ViewBuilder overlay: @escaping () -> Content) {
//        self.url = url
//        self.min = min
//        self.max = max
//        self.showsIndicators = showsIndicators
//        self.overlay = overlay
//    }
//    
//    public var body: some View {
//        GeometryReader { proxy in
//            ZoomableView(size: imageSize, min: self.min, max: self.max, showsIndicators: self.showsIndicators) {
//                WebImage(url: url)
//                    .resizable()
//                    .onSuccess(perform: { image, _, _ in
//                        DispatchQueue.main.async {
//                            self.imageSize = CGSize(width: proxy.size.width, height: proxy.size.width * (image.size.height / image.size.width))
//                        }
//                    })
//                    .indicator(.activity)
//                    .scaledToFit()
//                    .clipShape(Rectangle())
//                    .overlay(self.overlay())
//            }
//        }
//    }
//}
