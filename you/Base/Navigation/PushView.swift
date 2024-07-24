//
//  PushView.swift
//  you
//
//  Created by 翁益亨 on 2024/7/24.
//

import SwiftUI


public struct PushView<Label, Destination, Tag>: View where Label: View, Destination: View, Tag: Hashable {
    @EnvironmentObject private var navigationStack: NavigationStackCompat
    private let label: Label?
    private let destinationId: String?
    private let destination: Destination
    private let tag: Tag?
    @Binding private var isActive: Bool
    @Binding private var selection: Tag?

    
    
    public init(destination: Destination,
                destinationId: String? = nil,
                tag: Tag,
                selection: Binding<Tag?>,
                @ViewBuilder label: () -> Label) {

        self.init(destination: destination,
                  destinationId: destinationId,
                  isActive: Binding.constant(false),
                  tag: tag,
                  selection: selection,
                  label: label)
    }

    private init(destination: Destination,
                 destinationId: String?,
                 isActive: Binding<Bool>,
                 tag: Tag?,
                 selection: Binding<Tag?>,
                 @ViewBuilder label: () -> Label) {

        self.label = label()
        self.destinationId = destinationId
        self._isActive = isActive
        self.tag = tag
        self.destination = destination
        self._selection = selection
    }

    public var body: some View {
        if let selection = selection, let tag = tag, selection == tag {
            DispatchQueue.main.async {
                self.selection = nil
                push()
            }
        }
        if isActive {
            DispatchQueue.main.async {
                isActive = false
                push()
            }
        }
        return label.onTapGesture {
            push()
        }
    }

    private func push() {
        navigationStack.push(destination, withId: destinationId)
    }
}

public extension PushView where Tag == Never {

   
    
    init(destination: Destination,
         destinationId: String? = nil,
         @ViewBuilder label: () -> Label) {

        self.init(destination: destination,
                  destinationId: destinationId,
                  isActive: Binding.constant(false),
                  tag: nil,
                  selection: Binding.constant(nil),
                  label: label)
    }

    
    init(destination: Destination,
         destinationId: String? = nil,
         isActive: Binding<Bool>,
         @ViewBuilder label: () -> Label) {

        self.init(destination: destination,
                  destinationId: destinationId,
                  isActive: isActive,
                  tag: nil,
                  selection: Binding.constant(nil),
                  label: label)
    }
}
