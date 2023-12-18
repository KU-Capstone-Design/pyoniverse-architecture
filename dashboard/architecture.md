# Dashboard
## Architecture
| SOA + Domain 기반 + MVC & Humble Pattern
```mermaid
---
title: Pyoniverse Dashboard Architecture
---
C4Component
    title Pyoniverse Dashboard Architecture
    Person(admin, "Pyoniverse Manager")
    Component(gateway, "Router", "")
    BiRel(admin, gateway, "Request/Response")
    UpdateRelStyle(admin, gateway, $offsetX="-50", $offsetY="-10")

    Container_Boundary(web_boundary, "Dashboard Web Application") {
        Component(middleware, "Middleware", "", "Security & Log")
        BiRel(gateway, middleware, "Verify/Log")

        Container_Boundary(product_domain, "Products") {
            Component(product_controller, "Controller")
            Component(product_business, "Business")
            Component(product_entity, "ProductEntity")

            BiRel(middleware, product_controller, "handle")
            BiRel(product_controller, product_business, "process")
            BiRel(product_controller, view, "Render")
            BiRel(product_business, product_entity, "use")
            BiRel(product_business, brand_entity, "use")
            UpdateRelStyle(product_controller, view, $textColor="blue")
            UpdateRelStyle(product_controller, product_business, $textColor="green", $lineColor="red")
            UpdateRelStyle(product_business, product_entity, $textColor="green", $lineColor="red")
            UpdateRelStyle(product_business, brand_entity, $textColor="blue")
        }

        Container_Boundary(common, "Comman") {
            Component(view, "View", "", "Provides Dashboard UI")
            Component(brand_entity, "BrandEntity")
            ComponentDb(rdb, "RDB", "MariaDB", "Dashboard DB")
            BiRel(brand_entity, rdb, "persist")
            BiRel(product_entity, rdb, "persist")
            UpdateRelStyle(brand_entity, rdb, $textColor="pupple", $lineColor="blue")
            UpdateRelStyle(product_entity, rdb, $textColor="pupple", $lineColor="blue")
        }
    }
    Container_Boundary(migration_boundary, "Data Migration") {
        Component(mariaDriver, "MariaDriver", "", "Read/Write from/to MariaDB")
        Component(migrator, "Migrator", "", "Migrate from documentDB/rDB to rDB/documentDB")
        Component(mongoDriver, "MongoDriver", "", "Read/Write from/to MongoDB")
        BiRel(mongoDriver, documentDb, "Access DB")
        BiRel(mariaDriver, rdb, "Access DB")
        BiRel(mongoDriver, migrator, "Read/Write Data")
        BiRel(mariaDriver, migrator, "Read/Write Data")
    }
    Container_Boundary(service_boundary, "Pyoniverse Application") {
        ComponentDb(documentDb, "DocumentDB", "MongoDB", "Service DB")
    }
```