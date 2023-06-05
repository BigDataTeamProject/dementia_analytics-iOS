//
//  CoreDataStorage+.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/06.
//

import CoreData
import CoreDataStorage

extension CoreDataStorage {
    func createAll<O>(_ values: [O]) -> AnyPublisher<[O], Error>
    where O: Entitable {
        Future<O, Error> { promise in
            self.persistentContainer.performBackgroundTask { context in
                values.forEach{ value in
                    _ = value.toEntity(in: context)
                }
                do {
                    try context.save()
                    promise(.success(value))
                } catch {
                    promise(.failure(CoreDataStorageError.createError(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
