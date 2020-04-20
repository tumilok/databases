// Clients
function addClient(firstname, lastname, contact) {
    db.getCollection('Clients').insert({
        firstname: firstname,
        lastname: lastname,
        contact: contact,
        purchases: []
    });
};

addClient('Uladzislau', 'Tumilovich', 'tumich@example.com');
addClient('Kamil', 'Nowak', 'kamilexample.com');
addClient('Kasia', 'Andrukiewicz', '4343453453');
addClient('Mark', 'Krembik', '1435345234');

db.getCollection('Clients').find();

// Items
function addItem(name, price, category, origin_country) {
    db.getCollection('Items').insert({
        name: name,
        price: price,
        category: category,
        origin_country: origin_country
    });
};

addItem('Biuro', 399.99, 'Mebla', 'Poland');
addItem('Krzeslo', 299.99, 'Mebla', 'Belarus');
addItem('Monitor', 649.99, 'Elektronika', 'Germany');
addItem('Herbata', 4.29, 'Produkty', 'China');

db.getCollection('Items').find();

// Purchases
function addPurchase(seller, address) {
    db.getCollection('Purchases').insert({
        seller: seller,
        address: address,
        date: new Date(),
        items: []
    });
};

addPurchase('Ikea', 'ul. GdziesTam, 32, Krakow');
addPurchase('Lewiatan', 'ul. GdziesTam, 32, Warszawa');
addPurchase('MediaMarket', 'ul. GdziesTam, 32, Gdansk');

db.getCollection('Purchases').find();

// add Purchase to Client
function addPurchaseToClient(client_id, purchase_id) {
    db.getCollection('Clients').update(
        { _id: new ObjectId(client_id) },
        { $addToSet: { purchases: { $ref: "Purchases", $id: new ObjectId(purchase_id) } } }
    );
};

addPurchaseToClient("5e9c5be22cd52bf242f0e9b7", "5e9c65a62cd52bf242f0e9c6");
addPurchaseToClient("5e9c5be22cd52bf242f0e9b8", "5e9c65a62cd52bf242f0e9c7");
addPurchaseToClient("5e9c5be22cd52bf242f0e9b8", "5e9c65a62cd52bf242f0e9c8");

db.getCollection('Clients').find();

// add Item to Purchase
function addItemToPurchase(purchase_id, item_id) {
    db.getCollection("Purcases").update(
        { _id: new ObjectId(purchase_id) },
        { $addToSet: { items: { $ref: 'Items', $id: new ObjectId(item_id) } } }
    );
};

addItemToPurchase('5e9c65a62cd52bf242f0e9c6', '5e9c5ea52cd52bf242f0e9bf');
addItemToPurchase('5e9c65a62cd52bf242f0e9c7', '5e9c5ea52cd52bf242f0e9c0');
addItemToPurchase('5e9c65a62cd52bf242f0e9c8', '5e9c5ea52cd52bf242f0e9c1');
addItemToPurchase('5e9c65a62cd52bf242f0e9c6', '5e9c5ea52cd52bf242f0e9c2');

db.getCollection('Purchases').find()