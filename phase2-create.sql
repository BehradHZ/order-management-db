CREATE TABLE Customer (
    customer_id INT GENERATED ALWAYS AS IDENTITY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL,
    registration_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    account_status VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Customer PRIMARY KEY (customer_id),
    CONSTRAINT UQ_Customer_Email UNIQUE (email),
    CONSTRAINT CHK_Customer_Status CHECK (account_status IN ('Active', 'Suspended', 'Inactive'))
);

CREATE TABLE Postal_Code (
    postal_code VARCHAR(10) NOT NULL,
    state VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,

    CONSTRAINT PK_Postal_Code PRIMARY KEY (postal_code)
);

CREATE TABLE Seller (
    seller_id INT GENERATED ALWAYS AS IDENTITY,
    brand_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    approval_status VARCHAR(20) NOT NULL,
    membership_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_Seller PRIMARY KEY (seller_id),
    CONSTRAINT UQ_Seller_Email UNIQUE (email),
    CONSTRAINT CHK_Seller_Approval CHECK (approval_status IN ('Pending', 'Approved', 'Rejected', 'Suspended'))
);

CREATE TABLE Category (
    category_id INT GENERATED ALWAYS AS IDENTITY,
    category_name VARCHAR(100) NOT NULL,
    parent_category_id INT,

    CONSTRAINT PK_Category PRIMARY KEY (category_id),
    CONSTRAINT FK_Category_Parent FOREIGN KEY (parent_category_id)
        REFERENCES Category(category_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Promo_Code (
    promo_code VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    usage_limit INT NOT NULL CHECK (usage_limit >= 0),
    min_order_amount DECIMAL(12, 2) NOT NULL DEFAULT 0 CHECK (min_order_amount >= 0),

    CONSTRAINT PK_Promo_Code PRIMARY KEY (promo_code),
    CONSTRAINT CHK_Promo_Dates CHECK (end_date >= start_date)
);

CREATE TABLE Customer_Phone (
    customer_id INT NOT NULL,
    phone_number VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Customer_Phone PRIMARY KEY (customer_id, phone_number),
    CONSTRAINT FK_Customer_Phone_Customer FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Customer_Address (
    customer_id INT NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    street TEXT NOT NULL,

    CONSTRAINT PK_Customer_Address PRIMARY KEY (customer_id, postal_code),
    CONSTRAINT FK_Address_Customer FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Address_Postal FOREIGN KEY (postal_code)
        REFERENCES Postal_Code(postal_code) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Seller_Phone (
    seller_id INT NOT NULL,
    phone_number VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Seller_Phone PRIMARY KEY (seller_id, phone_number),
    CONSTRAINT FK_Seller_Phone_Seller FOREIGN KEY (seller_id)
        REFERENCES Seller(seller_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Product (
    product_id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(12, 2) NOT NULL CHECK (price >= 0),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    dimensions VARCHAR(50),
    weight DECIMAL(10, 3) CHECK (weight >= 0),
    seller_id INT NOT NULL,

    CONSTRAINT PK_Product PRIMARY KEY (product_id),
    CONSTRAINT FK_Product_Seller FOREIGN KEY (seller_id)
        REFERENCES Seller(seller_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Percentage_Discount (
    promo_code VARCHAR(50) NOT NULL,
    discount_percentage DECIMAL(5, 2) NOT NULL CHECK (discount_percentage > 0 AND discount_percentage <= 100),
    max_discount_amount DECIMAL(12, 2) CHECK (max_discount_amount >= 0),

    CONSTRAINT PK_Percentage_Discount PRIMARY KEY (promo_code),
    CONSTRAINT FK_Percentage_Discount_Promo FOREIGN KEY (promo_code)
        REFERENCES Promo_Code(promo_code) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Flat_Discount (
    promo_code VARCHAR(50) NOT NULL,
    discount_amount DECIMAL(12, 2) NOT NULL CHECK (discount_amount > 0),

    CONSTRAINT PK_Flat_Discount PRIMARY KEY (promo_code),
    CONSTRAINT FK_Flat_Discount_Promo FOREIGN KEY (promo_code)
        REFERENCES Promo_Code(promo_code) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Product_Category (
    product_id INT NOT NULL,
    category_id INT NOT NULL,

    CONSTRAINT PK_Product_Category PRIMARY KEY (product_id, category_id),
    CONSTRAINT FK_ProductCategory_Product FOREIGN KEY (product_id)
        REFERENCES Product(product_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_ProductCategory_Category FOREIGN KEY (category_id)
        REFERENCES Category(category_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Inventory_Stock (
    product_id INT NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    alert_threshold INT NOT NULL DEFAULT 0 CHECK (alert_threshold >= 0),
    last_update_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_Inventory_Stock PRIMARY KEY (product_id),
    CONSTRAINT FK_Inventory_Stock_Product FOREIGN KEY (product_id)
        REFERENCES Product(product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Inventory_Location (
    product_id INT NOT NULL,
    store_id VARCHAR(20) NOT NULL,
    shelf VARCHAR(20) NOT NULL,
    row VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Inventory_Location PRIMARY KEY (product_id, store_id, shelf, row),
    CONSTRAINT FK_Inventory_Location_Product FOREIGN KEY (product_id)
        REFERENCES Product(product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Inventory_Log (
    product_id INT NOT NULL,
    store_id VARCHAR(20) NOT NULL,
    shelf VARCHAR(20) NOT NULL,
    row VARCHAR(20) NOT NULL,
    log_id INT GENERATED ALWAYS AS IDENTITY,
    change_type VARCHAR(20) NOT NULL,
    quantity_changed INT NOT NULL CHECK (quantity_changed > 0),
    reason VARCHAR(255),

    CONSTRAINT PK_Inventory_Log PRIMARY KEY (log_id),
    CONSTRAINT FK_Inventory_Log_Location FOREIGN KEY (product_id, store_id, shelf, row)
        REFERENCES Inventory_Location(product_id, store_id, shelf, row) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT CHK_Inventory_Log_ChangeType CHECK (change_type IN ('Restock', 'Sale', 'Adjustment', 'Return', 'Damage'))
);

CREATE TABLE "Order" (
    order_id INT GENERATED ALWAYS AS IDENTITY,
    order_status VARCHAR(20) NOT NULL,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(12, 2) NOT NULL CHECK (total_amount >= 0),
    shipping_cost DECIMAL(10, 2) NOT NULL DEFAULT 0 CHECK (shipping_cost >= 0),
    discount DECIMAL(10, 2) NOT NULL DEFAULT 0 CHECK (discount >= 0),
    customer_id INT NOT NULL,
    customer_postal_code VARCHAR(10) NOT NULL,
    promo_code VARCHAR(50),

    CONSTRAINT PK_Order PRIMARY KEY (order_id),
    CONSTRAINT CHK_Order_Status CHECK (order_status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')),
    CONSTRAINT FK_Order_Customer_Address FOREIGN KEY (customer_id, customer_postal_code)
        REFERENCES Customer_Address(customer_id, postal_code) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT FK_Order_Promo FOREIGN KEY (promo_code)
        REFERENCES Promo_Code(promo_code) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Order_Item (
    order_id INT NOT NULL,
    item_number INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(12, 2) NOT NULL CHECK (unit_price >= 0),
    product_id INT NOT NULL,

    CONSTRAINT PK_Order_Item PRIMARY KEY (order_id, item_number),
    CONSTRAINT FK_OrderItem_Order FOREIGN KEY (order_id)
        REFERENCES "Order"(order_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_OrderItem_Product FOREIGN KEY (product_id)
        REFERENCES Product(product_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Payment (
    payment_id INT GENERATED ALWAYS AS IDENTITY,
    amount DECIMAL(12, 2) NOT NULL CHECK (amount >= 0),
    payment_method VARCHAR(30) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    payment_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tracking_code VARCHAR(100),
    order_id INT NOT NULL,

    CONSTRAINT PK_Payment PRIMARY KEY (payment_id),
    CONSTRAINT FK_Payment_Order FOREIGN KEY (order_id)
        REFERENCES "Order"(order_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT CHK_Payment_Status CHECK (payment_status IN ('Pending', 'Successful', 'Failed', 'Refunded'))
);

CREATE TABLE Shipment (
    shipment_id INT GENERATED ALWAYS AS IDENTITY,
    shipment_tracking_code VARCHAR(100) NOT NULL,
    time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL,
    order_id INT NOT NULL,

    CONSTRAINT PK_Shipment PRIMARY KEY (shipment_id),
    CONSTRAINT UQ_Shipment_Order UNIQUE (order_id),
    CONSTRAINT FK_Shipment_Order FOREIGN KEY (order_id)
        REFERENCES "Order"(order_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    -- Failed وضعیت توزیع ناموفق توسط مأمور پست است، در حالی که Returned به معنای بازگشت قطعی مرسوله فیزیکی به انبار توزیع می‌باشد.
	CONSTRAINT CHK_Shipment_Status CHECK (status IN ('Preparing', 'Handed_To_Carrier', 'In_Transit', 'Delivered', 'Failed', 'Returned'))
);