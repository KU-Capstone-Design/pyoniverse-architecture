# Service Entity Relationship Diagram
``` mermaid
---
title: Pyoniverse Service ERD
---
erDiagram
    categories {
        INT id
        STR slug
        STR name
        STR description
    }
    brands {
        INT id
        STR name
        STR slug
        URL image
    }
    events {
        INT id
        STR name
        STR description
        DATE start_at
        DATE end_at
        INT good_count
        INT view_count
    }
    event_images {
        URL url
    }
    event_image_types {
        STR name
    }
    products {
        INT id
        STR name
        STR description
        URL image
        REAL price
        INT good_count
        INT view_count
    }
    product_bests {
        REAL price
    }
    product_brands {
        REAL price
        REAL event_price
    }
    product_events {
        INT id
        STR name
        STR slug
        STR description
    }
    categories ||--o{ products : categorize
    products ||--|| product_bests: recommend
    product_bests ||--|| brands: sell
    product_bests o{--|| product_events: progress
    products ||--|{ product_brands: sell
    product_brands o{--|| product_events: progress
    product_brands |{--|| brands: sell

    brands ||--o{ events: progress
    events ||--|{ event_images: pamphlet
    event_image_types ||--|{ event_images: categorize
```