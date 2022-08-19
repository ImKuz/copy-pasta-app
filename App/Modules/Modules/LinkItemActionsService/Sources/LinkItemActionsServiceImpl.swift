import CatalogSource
import Combine
import Models
import ToolKit
import SharedHelpers

final class LinkItemActionsServiceImpl {

    private let catalogSource: CatalogSource
    private let actionHandler: LinkItemActionsHandler

    init(
        catalogSource: CatalogSource,
        actionHandler: LinkItemActionsHandler
    ) {
        self.catalogSource = catalogSource
        self.actionHandler = actionHandler
    }
}

// MARK: - LinkItemActionsService

extension LinkItemActionsServiceImpl: LinkItemActionsService {

    func actions(itemID: LinkItem.ID, shouldShowEditAction: Bool) async throws -> [LinkItemAction.WithData] {
        try await Publishers
            .Zip(isItemPersisted(id: itemID), catalogSource.isItemFavorite(id: itemID))
            .map { args in
                let (isFavorite, isPersisted) = args

                var actions: [LinkItemAction] = [
                    .copy, .open
                ]

                if shouldShowEditAction {
                    actions.append(.edit)
                }

                if isPersisted {
                    actions.append(contentsOf: [
                        .setIsFavorite(!isFavorite),
                        .delete
                    ])
                }

                return Self.enrichActions(actions, itemId: itemID)
            }
            .eraseToAnyPublisher()
            .async()
    }

    private func isItemPersisted(id: LinkItem.ID) -> AnyPublisher<Bool, AppError> {
        guard catalogSource.isPersistable else {
            return Just(false)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        }

        return catalogSource.contains(itemId: id)
    }

    private static func enrichActions(
        _ actions: [LinkItemAction],
        itemId: LinkItem.ID
    ) -> [LinkItemAction.WithData] {
        actions.map {
            let label: LinkItemAction.Data.Label

            switch $0 {
            case .open:
                label = ("Open Link", "link")
            case .edit:
                label = ("Edit", "square.and.pencil")
            case .delete:
                label = ("Delete", "trash")
            case .copy:
                label = ("Copy", "doc.on.doc")
            case .setIsFavorite(let isFavorite):
                label = isFavorite
                    ? ("Remove from favorites", "star.slash")
                    : ("Add to favorites", "star")
            }

            return $0.withData(.init(itemId: itemId, label: label))
        }
    }
}

// MARK: - LinkItemActionsHandler

extension LinkItemActionsServiceImpl: LinkItemActionsHandler {

    func handle(
        _ actionWithData: LinkItemAction.WithData
    ) -> AnyPublisher<LinkItemAction.WithData, AppError> {
        actionHandler.handle(actionWithData)
    }
}
