//
//  EAPATests.swift
//  EAPATests
//
//  Created by 송영채 on 2023/01/05.
//

import XCTest
@testable import EAPA
import SwiftUI
import UIKit

final class EAPATests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchUserList() async throws {
        let storage = EAPAStorage()
        
        let result = try await storage.fetchUserList()
        
        for user in result {
            print("User Info ID : ============================")
            print("User Info id : \(String(describing: user.id))")
            print("User Info name : \(String(describing: user.name))")
            print("User Info image : \(String(describing: user.image))")
            print("User Info birthDay : \(String(describing: user.birthDay))")
            print("User Info isAdult : \(user.isAdult)")
            print("User Info createDate : \(String(describing: user.createDate))")
            print("User Info updateDate : \(String(describing: user.updateDate))")
            print("User Info histories : \(String(describing: user.histories?.count))")
        }
        
    }
    
    func testInsertUser() async throws {
        let storage = EAPAStorage()
        let image = UIImage(systemName: "pencil.circle.fill")
        
        let result = try await storage.createUser(name: "이진영",
                                                  image: image?.jpegData(compressionQuality: 1.0),
                                                  birthDay: Date())
        print("User Insert Result : \(result)")
    }
    
    func testUpdateUser() async throws {
        let storage = EAPAStorage()
        
        let imageData = UIImage(systemName: "pencil.circle.fill")?.jpegData(compressionQuality: 1.0)
        if let id = UUID(uuidString: "D5BD84B9-DA83-493E-9A40-264533964DCB") {
            let result = try await storage.updateUser(id: id,
                                                      name: "이진영2",
                                                      image: imageData,
                                                      birthDay: Date())
            print("User Update Result : \(result)")
        }
        
    }
    
    func testDeleteUser() async throws {
        let storage = EAPAStorage()
        if let id = UUID(uuidString: "D5BD84B9-DA83-493E-9A40-264533964DCB") {
            let result = try await storage.deleteUser(id: id)
            print("User Delete Result : \(result)")
        }
        
    }
    
    func testFetchHistoryList() async throws {
        let storage = EAPAStorage()
        
        let result = try await storage.fetchHistoryList()
        
        for history in result {
            print("User Info ID : ============================")
            print("User Info id : \(String(describing: history.id))")
            print("User Info hospitalName : \(String(describing: history.hospitalName))")
            print("User Info cureDate : \(String(describing: history.cureDate))")
            print("User Info cureDesc : \(String(describing: history.cureDesc))")
            print("User Info cureDescEtc : \(String(describing: history.cureDescEtc))")
            print("User Info nextCureDate : \(String(describing: history.nextCureDate))")
            print("User Info price : \(String(describing: history.price))")
            print("User Info memo : \(String(describing: history.memo))")
            print("User Info prescription : \(String(describing: history.prescription))")
            print("User Info teethNums : \(String(describing: history.teethNums?.count))")
            print("User Info createDate : \(String(describing: history.createDate))")
            print("User Info updateDate : \(String(describing: history.updateDate))")
            print("User Info user : \(String(describing: history.user?.name))")
        }
    }
    
    func testInsertHistory() async throws {
        let storage = EAPAStorage()
        let imageData = UIImage(systemName: "pencil.circle.fill")?.jpegData(compressionQuality: 1.0)
        if let id = UUID(uuidString: "D5BD84B9-DA83-493E-9A40-264533964DCB") {
            let result = try await storage.createHistory(userId: id,
                                                         hospitalName: "치과",
                                                         cureDate: Date(),
                                                         cureDesc: "기타",
                                                         cureDescEtc: "로버트 이빨",
                                                         nextCureDate: Date(),
                                                         price: "10000",
                                                         memo: "인플란트는 엄청 아픔",
                                                         prescription: imageData,
                                                         teethNums: [1,2,3,4])
            print("History Insert Result : \(result)")
        }
            
        
    }
    
    func testUpdateHistory() async throws {
        let storage = EAPAStorage()
        let imageData = UIImage(systemName: "pencil.circle.fill")?.jpegData(compressionQuality: 1.0)
        if let id = UUID(uuidString: "438593D8-33C2-420D-8826-3F087093CA8F") {
            let result = try await storage.updateHistory(id: id,
                                                         hospitalName: "치과",
                                                         cureDate: Date(),
                                                         cureDesc: "기타",
                                                         cureDescEtc: "로버트 이빨2",
                                                         nextCureDate: Date(),
                                                         price: "10000",
                                                         memo: "인플란트는 엄청 아픔",
                                                         prescription: imageData,
                                                         teethNums: [1,2,3,4])
            print("History Update Result : \(result)")
        }
    }
    
    func testDeleteHistory() async throws {
        let storage = EAPAStorage()
        
        if let id = UUID(uuidString: "438593D8-33C2-420D-8826-3F087093CA8F") {
            let result = try await storage.deleteHistory(id: id)
            print("History Delete Result : \(result)")
        }
    }
    
}
