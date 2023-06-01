//
//  User.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/01.
//

import CoreData
import CoreDataStorage

struct User {
    let name: String
    let age: Int
    let height: CGFloat
    let weight: CGFloat
}

extension User: Entitable{
    func toEntity(in context: NSManagedObjectContext) -> UserEntity {
        let entity: UserEntity = .init(context: context)
        entity.name = name
        entity.age = Int16(age)
        entity.height = Float(height)
        entity.weight = Float(weight)
        return entity
    }
}

extension UserEntity: Objectable {
    public func toObject() -> some Entitable {
        User(name: name ?? "",
             age: Int(age ),
             height: CGFloat(height),
             weight: CGFloat(weight))
    }
}
