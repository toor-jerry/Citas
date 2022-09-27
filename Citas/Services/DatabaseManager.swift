//
//  DatabaseManager.swift
//  Citas
//
//  Created by 1058889 on 22/09/22.
//

import Foundation
import FirebaseDatabase
import MessageKit
import CoreLocation

/// Manager object to read and write data to real time firebase database
final class DatabaseManager {

    /// Shared instance of class
    public static let shared = DatabaseManager()

    public let database = Database.database().reference()

    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

extension DatabaseManager {

    /// Returns dictionary node at child path
    public func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void) {
        database.child("\(path)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }

}
