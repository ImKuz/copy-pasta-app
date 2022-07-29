import CoreData
import Foundation

struct PersistentStoreFactory {

    static func create(path: URL) throws -> NSPersistentContainer {
        guard
            let modelURL = Bundle.main.url(forResource: CoreDataConst.modelName, withExtension: "momd"),
            let model = NSManagedObjectModel(
                contentsOf: modelURL.appendingPathComponent("\(CoreDataMigrationVersion.current.modelName).mom")
            )
        else {
            let description = "Unable to load model"
            assertionFailure(description)
            throw DatabaseError(code: .unableToLoad, description: description)
        }

        let container = NSPersistentContainer(name: CoreDataConst.storeName, managedObjectModel: model)

        let description = container.persistentStoreDescriptions.first
        description?.shouldInferMappingModelAutomatically = false // inferred mapping will be handled else where
        description?.shouldMigrateStoreAutomatically = false
        description?.type = NSSQLiteStoreType
        description?.url = path.appendingPathComponent(CoreDataConst.dbFilename)

        return container
    }
}
