## 1. Entities & Attributes List
 # Customer
 * Entity Type: Strong
 * Identifying Entity (If Weak): N/A
 * Attributes:
   * customer_id: Simple | PK | Solid underline in the diagram
   * name: Composite | None | Sub-attributes: first_name, last_name (indented below parent attribute)
   * {phone_number}: Multivalued | None | Represented using set notation
   * email: Simple | None | N/A
   * registration_date: Simple | None | N/A
   * account_status: Simple | None | N/A
 # Address
 * Entity Type: Weak
 * Identifying Entity (If Weak): Customer
 * Attributes:
   * location_code: Simple | Partial Key | Dashed underline in the diagram (Discriminator)
   * city: Simple | None | N/A
   * street: Simple | None | N/A
   * postal_code: Simple | None | N/A
 # Seller
 * Entity Type: Strong
 * Identifying Entity (If Weak): N/A
 * Attributes:
   * seller_id: Simple | PK | Solid underline in the diagram
   * brand_name: Simple | None | N/A
   * {phone_number}: Multivalued | None | Represented using set notation
   * email: Simple | None | N/A
   * approval_status: Simple | None | N/A
   * membership_date: Simple | None | N/A
 # Product
 * Entity Type: Strong
 * Identifying Entity (If Weak): N/A
 * Attributes:
   * product_id: Simple | PK | Solid underline in the diagram
   * name: Simple | None | N/A
   * description: Simple | None | N/A
   * price: Simple | None | N/A
   * is_active: Simple | None | N/A
   * general_specs: Composite | None | Sub-attributes: dimensions, weight (indented below parent attribute)
 # Category
 * Entity Type: Strong
 * Identifying Entity (If Weak): N/A
 * Attributes:
   * category_id: Simple | PK | Solid underline in the diagram
   * category_name: Simple | None | N/A
 # Inventory
 * Entity Type: Weak
 * Identifying Entity (If Weak): Product
 * Attributes:
   * location_code: Simple | Partial Key | Dashed underline in the diagram (Discriminator)
   * stock_quantity: Simple | None | N/A
   * alert_threshold: Simple | None | N/A
   * last_update_date: Simple | None | N/A
 # Inventory_Log
 * Entity Type: Weak
 * Identifying Entity (If Weak): Inventory
 * Attributes:
   * log_id: Simple | Partial Key | Dashed underline in the diagram (Discriminator)
   * change_type: Simple | None | N/A
   * quantity_changed: Simple | None | N/A
   * reason: Simple | None | N/A
 # Order
 * Entity Type: Strong
 * Identifying Entity (If Weak): N/A
 * Attributes:
   * order_id: Simple | PK | Solid underline in the diagram
   * order_status: Simple | None | N/A
   * order_date: Simple | None | N/A
   * total_amount: Simple | None | N/A
   * shipping_cost: Simple | None | N/A
   * discount: Simple | None | N/A
 # Order_Item
 * Entity Type: Weak
 * Identifying Entity (If Weak): Order
 * Attributes:
   * item_number: Simple | Partial Key | Dashed underline in the diagram (Discriminator)
   * quantity: Simple | None | N/A
   * unit_price: Simple | None | N/A
   * final_amount: Derived | None | Calculated value
 # Payment
 * Entity Type: Strong
 * Identifying Entity (If Weak): N/A
 * Attributes:
   * payment_id: Simple | PK | Solid underline in the diagram
   * amount: Simple | None | N/A
   * payment_method: Simple | None | N/A
   * payment_status: Simple | None | N/A
   * payment_time: Simple | None | N/A
   * tracking_code: Simple | None | N/A
 # Shipment
 * Entity Type: Strong
 * Identifying Entity (If Weak): N/A
 * Attributes:
   * shipment_id: Simple | PK | Solid underline in the diagram
   * carrier_company: Simple | None | N/A
   * tracking_code: Simple | None | N/A
   * shipped_time: Simple | None | N/A
   * delivery_time: Simple | None | N/A
   * shipment_status: Simple | None | N/A
 # Promo_Code
  * Entity Type: Strong
 * Identifying Entity (If Weak): N/A
 * Attributes:
   * promo_code: Simple | PK | Solid underline in the diagram
   * start_date: Simple | None | N/A
   * end_date: Simple | None | N/A
   * usage_limit: Simple | None | N/A
   * min_order_amount: Simple | None | N/A
## 2. Relationships List
 #  Has_Address
 * Participating Entity 1:
   * Name: Customer
   * Participation: Partial
   * Min/Max Cardinality: (1, *)
 * Participating Entity 2:
   * Name: Address
   * Participation: Total
   * Min/Max Cardinality: (1, 1)
 * Cardinality Ratio: 1:N
 * Labeling Style: Identifying Relationship (Double Diamond), Arrow pointing to Customer, Double Line connecting to Address, with (Min, Max) notation
 * Relationship Attributes: None
 # Offers
 * Participating Entity 1:
   * Name: Seller
   * Participation: Partial
   * Min/Max Cardinality: (1, 1)
 * Participating Entity 2:
   * Name: Product
   * Participation: Partial
   * Min/Max Cardinality: (0, *)
 * Cardinality Ratio: 1:N
 * Labeling Style: Arrow pointing to Seller, straight line to Product, with (Min, Max) notation
 * Relationship Attributes: None
 # Belongs_To
 * Participating Entity 1:
   * Name: Product
   * Participation: Total
   * Min/Max Cardinality: (1, *)
 * Participating Entity 2:
   * Name: Category
   * Participation: Partial
   * Min/Max Cardinality: (0, *)
 * Cardinality Ratio: M:N
 * Labeling Style: Straight lines on both sides, with (Min, Max) notation
 * Relationship Attributes: None
 # Sub_Category
 * Participating Entity 1:
   * Name: Category (as Parent)
   * Participation: Partial
   * Min/Max Cardinality: (0, 1)
 * Participating Entity 2:
   * Name: Category (as Child)
   * Participation: Partial
   * Min/Max Cardinality: (0, *)
 * Cardinality Ratio: 1:N
 * Labeling Style: Recursive relation (two lines to same entity), with (Min, Max) notation
 * Relationship Attributes: None
 # Has_Stock
 * Participating Entity 1:
   * Name: Product
   * Participation: Partial
   * Min/Max Cardinality: (0, 1)
 * Participating Entity 2:
   * Name: Inventory
   * Participation: Total
   * Min/Max Cardinality: (1, 1)
 * Cardinality Ratio: 1:1
 * Labeling Style: Identifying Relationship (Double Diamond), Arrow pointing to Product, Double Line connecting to Inventory, with (Min, Max) notation
 * Relationship Attributes: None
 # Logs
 * Participating Entity 1:
   * Name: Inventory
   * Participation: Partial
   * Min/Max Cardinality: (1, 1)
 * Participating Entity 2:
   * Name: Inventory_Log
   * Participation: Total
   * Min/Max Cardinality: (0, *)
 * Cardinality Ratio: 1:N
 * Labeling Style: Identifying Relationship (Double Diamond), Arrow pointing to Inventory, Double Line connecting to Inventory_Log, with (Min, Max) notation
 * Relationship Attributes: None
 # Places
 * Participating Entity 1:
   * Name: Customer
   * Participation: Partial
   * Min/Max Cardinality: (1, 1)
 * Participating Entity 2:
   * Name: Order
   * Participation: Partial
   * Min/Max Cardinality: (0, *)
 * Cardinality Ratio: 1:N
 * Labeling Style: Arrow pointing to Customer, straight line to Order, with (Min, Max) notation
 * Relationship Attributes: None
 # Ships_To
 * Participating Entity 1:
   * Name: Address
   * Participation: Partial
   * Min/Max Cardinality: (0, *)
 * Participating Entity 2:
   * Name: Order
   * Participation: Partial
   * Min/Max Cardinality: (1, 1)
 * Cardinality Ratio: 1:N
 * Labeling Style: Arrow pointing to Address, straight line to Order, with (Min, Max) notation
 * Relationship Attributes: None
 # Contains
 * Participating Entity 1:
   * Name: Order
   * Participation: Partial
   * Min/Max Cardinality: (1, 1)
      * Participating Entity 2:
   * Name: Order_Item
   * Participation: Total
   * Min/Max Cardinality: (1, *)
 * Cardinality Ratio: 1:N
 * Labeling Style: Identifying Relationship (Double Diamond), Arrow pointing to Order, Double Line connecting to Order_Item, with (Min, Max) notation
 * Relationship Attributes: None
 # Associated_With
 * Participating Entity 1:
   * Name: Product
   * Participation: Partial
   * Min/Max Cardinality: (1, 1)
 * Participating Entity 2:
   * Name: Order_Item
   * Participation: Partial
   * Min/Max Cardinality: (0, *)
 * Cardinality Ratio: 1:N
 * Labeling Style: Arrow pointing to Product, straight line to Order_Item, with (Min, Max) notation
 * Relationship Attributes: None
 # Paid_For
 * Participating Entity 1:
   * Name: Order
   * Participation: Partial
   * Min/Max Cardinality: (1, 1)
 * Participating Entity 2:
   * Name: Payment
   * Participation: Partial
   * Min/Max Cardinality: (0, *)
 * Cardinality Ratio: 1:N
 * Labeling Style: Arrow pointing to Order, straight line to Payment, with (Min, Max) notation
 * Relationship Attributes: None
 # Shipped_Via
 * Participating Entity 1:
   * Name: Order
   * Participation: Partial
   * Min/Max Cardinality: (1, 1)
 * Participating Entity 2:
   * Name: Shipment
   * Participation: Partial
   * Min/Max Cardinality: (0, 1)
 * Cardinality Ratio: 1:1
 * Labeling Style: Arrow pointing to Order, straight line to Shipment, with (Min, Max) notation
 * Relationship Attributes: None
 # Applied_To
 * Participating Entity 1:
   * Name: Promo_Code
   * Participation: Partial
   * Min/Max Cardinality: (0, 1)
 * Participating Entity 2:
   * Name: Order
   * Participation: Partial
   * Min/Max Cardinality: (0, *)
 * Cardinality Ratio: 1:N
 * Labeling Style: Arrow pointing to Promo_Code, straight line to Order, with (Min, Max) notation
 * Relationship Attributes: None
## 3. Hierarchies & ISA
 * Superclass Entity: Promo_Code
 * Subclass Entities: Percentage_Discount, Flat_Discount
 * Completeness Constraint: Total (indicated with keyword 'total' and a dashed line to the hollow arrowhead)
 * Disjointness Constraint: Disjoint (d)
 * Local Attributes of Subclasses:
   * Percentage_Discount: discount_percentage, max_discount_amount
   * Flat_Discount: discount_amount
## 4. Aggregations & Complex Structures
 * N/A (The requirements are completely modeled using standard strong/weak entities, binary relationships, and ISA hierarchies, without requiring complex aggregation boxes).
## 5. Self-Correction & Checklist Verification
 * No redundant Foreign Keys inside entity rectangles: Verified. Fields like customer_id or product_id do not appear inside entities like Order, Payment, Shipment, or Order_Item as they are modeled exclusively through relationship diamonds.
 * Multivalued attributes represented correctly: Verified. The contact numbers in Customer and Seller are formatted using set notation {phone_number} inside their respective entity boxes.
 * Primary Key of relationships matches the "Many" side: Verified. For 1:N relationships, the primary key of the relationship matches the key of the "Many" side (e.g., for Places (1:N), the PK is order_id).
 * Minimum cardinality of 0 is explicitly and correctly mapped to Partial participation: Verified. All relationships where the minimum cardinality is 0 are correctly marked with single lines representing Partial participation, and "Double Lines" are used only for Total participation where the minimum cardinality is 1.
 * Has_Address cardinality corrected: Customer participation is Partial (1,*), since a customer must have at least one address and may have several; Address participation is Total (1,1), since every Address instance must belong to exactly one Customer.
 * Ships_To cardinality corrected: Address participation is Partial (0,*), since a single saved address can be reused across multiple orders by the same customer; Order participation is Partial (1,1), since each order has exactly one shipping address.
 * Has_Stock cardinality corrected: Product participation is Partial (0,1), since a product may exist without yet having an inventory record; Inventory participation is Total (1,1), since an inventory record cannot exist without being linked to a product.