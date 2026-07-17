# E-Commerce ER Diagram Specification (Optimized)

## 1. Entities & Attributes List

### 📦 Product
*   **Entity Type:** Strong
*   **Attributes:**
    *   `product_id`: Simple | **Primary Key** | *Solid underline in the diagram*
    *   `name`: Simple
    *   `description`: Simple
    *   `price`: Simple
    *   `is_active`: Simple
    *   `general_specs`: Composite
        *   `dimensions`: Simple Sub-attribute
        *   `weight`: Simple Sub-attribute

### 🗄️ Inventory
*   **Entity Type:** **Weak** (Identifying Entity: `Product`)
*   **Attributes:**
    *   `location`: Composite | **Partial Key (Discriminator)** | *Dashed underline in the diagram*
        *   `store_id`: Simple Sub-attribute
        *   `shelf`: Simple Sub-attribute
        *   `row`: Simple Sub-attribute
    *   `stock_quantity`: Simple
    *   `alert_threshold`: Simple
    *   `last_update_date`: Simple

### 📜 Inventory_Log
*   **Entity Type:** **Weak** (Identifying Entity: `Inventory`)
*   **Attributes:**
    *   `log_id`: Simple | **Partial Key** | *Dashed underline in the diagram*
    *   `change_type`: Simple
    *   `quantity_changed`: Simple
    *   `reason`: Simple

### 👤 Customer
*   **Entity Type:** Strong
*   **Attributes:**
    *   `customer_id`: Simple | **Primary Key** | *Solid underline in the diagram*
    *   `name`: Composite
        *   `first_name`: Simple Sub-attribute
        *   `last_name`: Simple Sub-attribute
    *   `{phone_number}`: **Multivalued** | *Represented using set notation or double oval*
    *   `email`: Simple
    *   `registration_date`: Simple
    *   `account_status`: Simple

### 🏠 Address
*   **Entity Type:** **Weak** (Identifying Entity: `Customer`)
*   **Attributes:**
    *   `postal_code`: Simple | **Partial Key** | *Dashed underline in the diagram*
    *   `state`: Simple
    *   `city`: Simple
    *   `street`: Simple

### 🏪 Seller
*   **Entity Type:** Strong
*   **Attributes:**
    *   `seller_id`: Simple | **Primary Key** | *Solid underline in the diagram*
    *   `brand_name`: Simple
    *   `{phone_number}`: **Multivalued** | *Represented using set notation or double oval*
    *   `email`: Simple
    *   `approval_status`: Simple
    *   `membership_date`: Simple

### 🗂️ Category
*   **Entity Type:** Strong
*   **Attributes:**
    *   `category_id`: Simple | **Primary Key** | *Solid underline in the diagram*
    *   `category_name`: Simple

### 🛍️ Order
*   **Entity Type:** Strong
*   **Attributes:**
    *   `order_id`: Simple | **Primary Key** | *Solid underline in the diagram*
    *   `order_status`: Simple
    *   `order_date`: Simple
    *   `total_amount`: Simple
    *   `shipping_cost`: Simple
    *   `discount`: Simple

### 🏷️ Order_Item
*   **Entity Type:** **Weak** (Identifying Entity: `Order`)
*   **Attributes:**
    *   `item_number`: Simple | **Partial Key** | *Dashed underline in the diagram*
    *   `quantity`: Simple
    *   `unit_price`: Simple
    *   `final_amount`: **Derived** | *Represented using a dashed oval (calculated via code/query)*

### 💳 Payment
*   **Entity Type:** Strong
*   **Attributes:**
    *   `payment_id`: Simple | **Primary Key** | *Solid underline in the diagram*
    *   `amount`: Simple
    *   `payment_method`: Simple
    *   `payment_status`: Simple
    *   `payment_time`: Simple
    *   `tracking_code`: Simple

### 🚚 Shipment
*   **Entity Type:** Strong
*   **Attributes:**
    *   `shipment_id`: Simple | **Primary Key** | *Solid underline in the diagram*
    *   `shipment_tracking_code`: Simple
    *   `time`: Simple
    *   `status`: Simple

### 🎫 Promo_Code
*   **Entity Type:** Strong
*   **Attributes:**
    *   `promo_code`: Simple | **Primary Key** | *Solid underline in the diagram*
    *   `start_date`: Simple
    *   `end_date`: Simple
    *   `usage_limit`: Simple
    *   `min_order_amount`: Simple

---

## 2. Relationships List

### 🔗 Has_Address (1:N)
*   **Entities:** `Customer` (1, 1) ─── `Address` (1, *)
*   **Participation:** `Customer` is **Partial** | `Address` is **Total** (Double Line)
*   **Notation Style:** Identifying Relationship (**Double Diamond**). Arrow pointing towards `Customer`.

### 🔗 Offers (1:N)
*   **Entities:** `Seller` (1, 1) ─── `Product` (1, *)
*   **Participation:** Both sides are **Partial**
*   **Notation Style:** Arrow pointing towards `Seller`, straight line to `Product`.

### 🔗 Belongs_To (M:N)
*   **Entities:** `Product` (1, *) ─── `Category` (0, *)
*   **Participation:** `Product` is **Total** (Double Line) | `Category` is **Partial**
*   **Notation Style:** No arrows on either side (indicates Many-to-Many).

### 🔗 Sub_Category (1:N Recursive)
*   **Entities:** `Category (Parent)` (0, 1) ─── `Category (Child)` (0, *)
*   **Participation:** Both are **Partial**
*   **Notation Style:** Loop connection back to the same entity rectangle.

### 🔗 Has_Stock (1:1)
*   **Entities:** `Product` (1, 1) ─── `Inventory` (1, 1)
*   **Participation:** **Total** on both sides (Double Lines on both sides)
*   **Notation Style:** Identifying Relationship (**Double Diamond**). Arrows pointing towards **both** entities.

### 🔗 Logs (1:N)
*   **Entities:** `Inventory` (1, 1) ─── `Inventory_Log` (1, *)
*   **Participation:** `Inventory` is **Partial** | `Inventory_Log` is **Total** (Double Line)
*   **Notation Style:** Regular Relationship (**Single Diamond**). Arrow pointing towards `Inventory`.

### 🔗 Places (1:N)
*   **Entities:** `Customer` (1, 1) ─── `Order` (0, *)
*   **Participation:** Both sides are **Partial**
*   **Notation Style:** Arrow pointing towards `Customer`.

### 🔗 Ships_To (1:N)
*   **Entities:** `Address` (1, 1) ─── `Order` (0, *)
*   **Participation:** Both sides are **Partial**
*   **Notation Style:** Arrow pointing towards `Address`.

### 🔗 Contains (1:N)
*   **Entities:** `Order` (1, 1) ─── `Order_Item` (1, *)
*   **Participation:** `Order` is **Partial** | `Order_Item` is **Total** (Double Line)
*   **Notation Style:** Identifying Relationship (**Double Diamond**). Arrow pointing towards `Order`.

### 🔗 Associated_With (1:N)
*   **Entities:** `Product` (1, 1) ─── `Order_Item` (0, *)
*   **Participation:** Both sides are **Partial**
*   **Notation Style:** Arrow pointing towards `Product`.

### 🔗 Paid_For (1:N)
*   **Entities:** `Order` (1, 1) ─── `Payment` (1, *)
*   **Participation:** `Order` is **Partial** | `Payment` is **Total** (Double Line)
*   **Notation Style:** Arrow pointing towards `Order`.

### 🔗 Shipped_Via (1:1)
*   **Entities:** `Order` (1, 1) ─── `Shipment` (1, 1)
*   **Participation:** **Total** on both sides (Double Lines on both sides)
*   **Notation Style:** Regular Relationship (**Single Diamond**). Arrows pointing towards **both** entities.

### 🔗 Applied_To (1:N)
*   **Entities:** `Promo_Code` (0, 1) ─── `Order` (0, *)
*   **Participation:** Both sides are **Partial**
*   **Notation Style:** Arrow pointing towards `Promo_Code`.

---

## 3. Hierarchies & ISA (Specialization)

*   **Superclass Entity:** `Promo_Code`
*   **Subclass Entities:** `Percentage_Discount`, `Flat_Discount`
*   **Completeness Constraint:** **Total** (indicated with the keyword `total` and a dashed line leading to the hollow arrowhead)
*   **Disjointness Constraint:** **Disjoint** (`d`)
*   **Local Attributes:**
    *   `Percentage_Discount`: `discount_percentage`, `max_discount_amount`
    *   `Flat_Discount`: `discount_amount`

---

## 4. Self-Correction & Prof's Preferences Checklist

1.  **No Foreign Keys as Attributes:** Rectangles only contain pure descriptive attributes. Connections/FKs are handled exclusively via diamonds.
2.  **Partial Key Underscoring:** Weak entity discriminators (`postal_code`, `location`, `log_id`, `item_number`) are cleanly marked for dashed underlining.
3.  **Structural Integrity:** Complex Multi-attribute rules (like `location` branching into three specific fields) are clearly defined.
4.  **Strict Silberchatz Representation:** Correct application of arrows for '1' boundaries, lines for '*' boundaries, and double-lines for mandatory relationships.
