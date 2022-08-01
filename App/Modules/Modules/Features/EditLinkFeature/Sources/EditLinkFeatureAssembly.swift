import ComposableArchitecture
import Database
import Swinject
import ToolKit
import SharedInterfaces
import SwiftUI

public struct EditLinkFeatureAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {

        let factory: (Resolver, EditLinkFeatureInterface.Input) -> EditLinkFeatureInterface = { _, input in
            let environment = EditLinkEnvImpl(catalogSource: input)

            let store = Store<EditLinkState, EditLinkAction>(
                initialState: EditLinkState(
                    name: "Untitled link",
                    urlComponents: .init(string: "")
                ),
                reducer: editLinkReducer,
                environment: environment
            )

            let view = AnyView(EditLinkView(store: store))

            return EditLinkFeatureInterface(
                view: view,
                onFinishPublisher: environment.onFinishSubject.eraseToAnyPublisher()
            )
        }

        container.register(
            EditLinkFeatureInterface.self,
            factory: factory
        )
    }
}
