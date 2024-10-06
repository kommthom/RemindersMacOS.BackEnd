//
//  QueryBuilder+filterSiblings.swift
//
//
//  Created by Thomas Benninghaus on 02.02.24.
//

import Vapor
import Fluent

// let filteredCustomers = try await Customer.query(on: request.db)
//    .filter(siblings: \.$branches, \.$id, subset: branchIds)
//    .all()

extension QueryBuilder {
    @discardableResult
    public func filter<
        Field: QueryableProperty,
        To: FluentKit.Model,
        Through: FluentKit.Model,
        Values: Collection<Field.Value>
    >(
        siblings: KeyPath<Model, SiblingsProperty<Model, To, Through>>,
        _ fieldKeyPath: KeyPath<To, Field>,
        subset: Values,
        inverse: Bool = false
    ) -> Self
    where Field.Model == To, Values.Element == Field.Value {
        self
            .join(siblings: siblings)
            .filter(
                .extendedPath(
                    To.path(for: fieldKeyPath),
                    schema: To.schemaOrAlias,
                    space: nil
                ),
                .subset(inverse: inverse),
                .array(subset.map { .bind($0) })
            )
    }
}
