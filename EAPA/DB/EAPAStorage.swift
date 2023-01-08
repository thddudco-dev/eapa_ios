//
//  EAPAStorage.swift
//  EAPA
//
//  Created by 송영채 on 2023/01/06.
//

import Foundation
import CoreData

protocol EAPAStorageProtocol {
    
    func fetchUserList() async throws -> [User]
    func fetchRepresentativeUser() async throws -> User?
    func fetchUserWithId(id: UUID) async throws -> User?
    func createUser(name: String, image: Data?, birthDay: Date) async throws -> Bool
    func updateUser(id: UUID, name: String, image: Data?, birthDay: Date) async throws -> Bool
    func deleteUser(id: UUID) async throws -> Bool
    
    func fetchHistoryList() async throws -> [History]
    func fetchHistoryWithId(id: UUID) async throws -> History?
    func createHistory(userId: UUID,
                       hospitalName: String,
                       cureDate: Date,
                       cureDesc: String,
                       cureDescEtc: String?,
                       nextCureDate: Date?,
                       price: String?,
                       memo: String?,
                       prescription: Data?,
                       teethNums: [Int]) async throws -> Bool
    func updateHistory(id: UUID,
                       hospitalName: String,
                       cureDate: Date,
                       cureDesc: String,
                       cureDescEtc: String?,
                       nextCureDate: Date?,
                       price: String?,
                       memo: String?,
                       prescription: Data?,
                       teethNums: [Int]) async throws -> Bool
    func deleteHistory(id: UUID) async throws -> Bool
    
}

final class EAPAStorage: EAPAStorageProtocol {
    
    private lazy var persistence: PersistenceController = {
        PersistenceController.shared
    }()
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        persistence.newBackgroundContext()
    }()
    
    // MARK: - User
    func fetchUserList() async throws -> [User] {
        do {
            let request: NSFetchRequest = User.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(User.createDate), ascending: false)]
            let result = try backgroundContext.fetch(request)
            return result
        } catch {
            return []
        }
    }
    
    func fetchRepresentativeUser() async throws -> User? {
        do {
            let request: NSFetchRequest = User.fetchRequest()
            let predicate = NSPredicate(format: "isRepresentative == %@", true)
            request.predicate = predicate
            
            let result = try backgroundContext.fetch(request)
            if let representativeUserEntity = result.first {
                return representativeUserEntity
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func fetchUserWithId(id: UUID) async throws -> User? {
        do {
            let request: NSFetchRequest = User.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.predicate = predicate
            
            let result = try backgroundContext.fetch(request)
            if let userEntity = result.first {
                return userEntity
            } else {
                return nil
            }
            
        } catch {
            debugPrint("Save User Unresolved error Unresolved error \(error), \((error as NSError).userInfo)")
            return nil
        }
    }
    
    func createUser(name: String, image: Data?, birthDay: Date) async throws -> Bool {
        
        let user = User(context: backgroundContext)
        user.id = UUID()
        user.name = name
        user.image = image
        user.birthDay = birthDay
        user.isAdult = birthDay.isAdult
        user.createDate = Date()
        user.updateDate = Date()
        
        do {
            try backgroundContext.save()
            return true
        } catch {
            // TODO: - Log to Crashlytics
            debugPrint("Save User Unresolved error Unresolved error \(error), \((error as NSError).userInfo)")
            return false
        }
    }
    
    func updateUser(id: UUID, name: String, image: Data?, birthDay: Date) async throws -> Bool {
                
        do {
            let request: NSFetchRequest = User.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.predicate = predicate
            
            let results = try backgroundContext.fetch(request)
            
            if results.count > 0, let userEntity = results.first {
                userEntity.name = name
                userEntity.image = image
                userEntity.birthDay = birthDay
                userEntity.isAdult = birthDay.isAdult
                userEntity.updateDate = Date()
                try backgroundContext.save()
                return true
            } else {
                return false
            }
            
        } catch {
            debugPrint("Update User Unresolved error \(error), \((error as NSError).userInfo)")
            return false
        }
    }
    
    func deleteUser(id: UUID) async throws -> Bool {
        do {
            let request: NSFetchRequest = User.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.predicate = predicate
            
            let results = try backgroundContext.fetch(request)
            
            if results.count > 0, let user = results.first {
                backgroundContext.delete(user)
                try backgroundContext.save()
                return true
            } else {
                return false
            }
            
        } catch {
            debugPrint("readUser Unresolved error \(error), \((error as NSError).userInfo)")
            return false
        }
    }
    
    // MARK: - History
    func fetchHistoryList() async throws -> [History] {
        do {
            let request: NSFetchRequest = History.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(History.createDate),
                                                        ascending: false)]
            let result = try backgroundContext.fetch(request)
            return result
        } catch {
            return []
        }
    }
    
    func fetchHistoryWithId(id: UUID) async throws -> History? {
        do {
            let request: NSFetchRequest = History.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.predicate = predicate
            
            let result = try backgroundContext.fetch(request)
            return result.first
        } catch {
            return nil
        }
    }
    
    func createHistory(userId: UUID,
                       hospitalName: String,
                       cureDate: Date,
                       cureDesc: String,
                       cureDescEtc: String?,
                       nextCureDate: Date?,
                       price: String?,
                       memo: String?,
                       prescription: Data?,
                       teethNums: [Int]) async throws -> Bool {
        
        let history = History(context: backgroundContext)
        history.id = UUID()
        history.hospitalName = hospitalName
        history.cureDate = cureDate
        history.cureDesc = cureDesc
        history.cureDescEtc = cureDescEtc
        history.nextCureDate = nextCureDate
        history.price = price?.nsNumberValue
        history.memo = memo
        history.prescription = prescription
        history.teethNums = teethNums
        history.createDate = Date()
        history.updateDate = Date()
        
        do {
            let request: NSFetchRequest = User.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", userId as CVarArg)
            request.predicate = predicate
            
            if let user = try backgroundContext.fetch(request).first {
                print("createTodo user : \(String(describing: user.id)) : \(user.name ?? "User Name is Nil")")
                user.addToHistories(history)
                try backgroundContext.save()
                return true
            } else {
                return false
            }
            
        } catch {
            // TODO: - Log to Crashlytics
            debugPrint("Update History Unresolved error \(error), \((error as NSError).userInfo)")
            return false
        }
    }
    
    func updateHistory(id: UUID,
                       hospitalName: String,
                       cureDate: Date,
                       cureDesc: String,
                       cureDescEtc: String?,
                       nextCureDate: Date?,
                       price: String?,
                       memo: String?,
                       prescription: Data?,
                       teethNums: [Int]) async throws -> Bool {
        do {
            let request: NSFetchRequest = History.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.predicate = predicate
            
            let results = try backgroundContext.fetch(request)
            
            if results.count > 0, let historyEntity = results.first {
                historyEntity.hospitalName = hospitalName
                historyEntity.cureDate = cureDate
                historyEntity.cureDesc = cureDesc
                historyEntity.cureDescEtc = cureDescEtc
                historyEntity.nextCureDate = nextCureDate
                historyEntity.price = price?.nsNumberValue
                historyEntity.memo = memo
                historyEntity.prescription = prescription
                historyEntity.teethNums = teethNums
                historyEntity.updateDate = Date()
                try backgroundContext.save()
                return true
            } else {
                return false
            }
        } catch {
            debugPrint("Update History Unresolved error \(error), \((error as NSError).userInfo)")
            return false
        }
    }
    
    func deleteHistory(id: UUID) async throws -> Bool {
        do {
            let request: NSFetchRequest = History.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.predicate = predicate
            
            let results = try backgroundContext.fetch(request)
            
            if results.count > 0, let history = results.first {
                backgroundContext.delete(history)
                try backgroundContext.save()
                return true
            } else {
                return false
            }
            
        } catch {
            debugPrint("Delete History Unresolved error \(error), \((error as NSError).userInfo)")
            return false
        }
    }
    
    
    
    
}
