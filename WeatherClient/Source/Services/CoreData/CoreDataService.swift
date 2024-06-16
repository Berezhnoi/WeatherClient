
import CoreData

class CoreDataService: NSObject {

    static let shared = CoreDataService()

    var objectStoreFileName : String

    init(baseFileName : String = "WeatherClinet") {
        self.objectStoreFileName = baseFileName
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        guard let mom = NSManagedObjectModel.mergedModel(from: [Bundle.main]) else {
            fatalError("Could not get Managed Object Model");
        }

        let container = NSPersistentContainer(name: objectStoreFileName, managedObjectModel: mom)

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("This error data storage from being initialized: \(error), \(error.userInfo)")
            }
            print("DB URL \(String(describing: storeDescription.url?.absoluteString))")
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        let taskContext = self.persistentContainer.viewContext
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let taskContext = self.persistentContainer.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }()
    
    lazy var privateContext: NSManagedObjectContext = {
        let privateChildContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateChildContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return privateChildContext
    }()
}

extension CoreDataService {
    
    func fetchDataFromEntity<T>(_ type: T.Type,
                                context: NSManagedObjectContext? = nil,
                                fetchRequest: NSFetchRequest<T>,
                                sort: [NSSortDescriptor]? = nil,
                                wantFault: Bool? = true) -> [T] where T: NSManagedObject {
        
        if let sortDescriptor = sort {
            fetchRequest.sortDescriptors = sortDescriptor
        }
        
        if wantFault == false {
            fetchRequest.returnsObjectsAsFaults = false
        }
        
        var results: [Any] = []
        if let context = context {
            context.performAndWait {
                do {
                    results = try context.fetch(fetchRequest)
                } catch let error {
                    debugPrint(error)
                }
            }
        } else {
            self.context.performAndWait {
                do {
                    results = try self.context.fetch(fetchRequest)
                } catch let error {
                    debugPrint(error)
                }
            }
        }
        return results as? [T] ?? []
    }
    
    func deleteRecords<T>(_ type: T.Type,
                          context: NSManagedObjectContext? = nil,
                          fetchRequest: NSFetchRequest<T>)  where T: NSManagedObject {
        if let context = context {
            let resultsToDelete = fetchDataFromEntity(T.self,
                                                      context: context,
                                                      fetchRequest: fetchRequest,
                                                      sort: nil,
                                                      wantFault: false)
            if !resultsToDelete.isEmpty {
                self.deleteRecords(resultsToDelete, context: context)
            }
        } else {
            backgroundContext.performAndWait {
                let resultsToDelete = self.fetchDataFromEntity(
                    T.self,
                    context: backgroundContext,
                    fetchRequest: fetchRequest,
                    sort: nil,
                    wantFault: false)
                
                if !resultsToDelete.isEmpty {
                    self.deleteRecords(resultsToDelete, context: backgroundContext)
                }
            }
        }
    }
    
    func deleteRecords<T>(_ records: [T], context: NSManagedObjectContext) where T: NSManagedObject {
        if !records.isEmpty {
            for record in records {
                context.delete(record)
            }
            self.save(context: context)
        }
    }
    
    func save(context: NSManagedObjectContext) {
        context.performAndWait {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    debugPrint("CoreDataService could not save due to error: \(error)")
                }
            }
        }
    }
    
    
    func deleteAll<T>(_ type: T.Type,
                      predicate: NSPredicate? = nil,
                      context: NSManagedObjectContext? = nil) {
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
        if let predicate = predicate {
            fetch.predicate = predicate
        }
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
        deleteRequest.resultType = .resultTypeObjectIDs
        
        var currentContext = self.context
        if let context = context {
            currentContext = context
        }
        do {
            let result = try currentContext.execute(deleteRequest) as? NSBatchDeleteResult
            let objectIDArray = result?.result as? [NSManagedObjectID]
            let changes: [AnyHashable : Any] = [NSDeletedObjectsKey : objectIDArray as Any]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [currentContext])
        } catch {
            print(error.localizedDescription)
        }
    }
}

