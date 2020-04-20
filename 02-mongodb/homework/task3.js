function showBusinessByCategory(category) {
    return db.getCollection('business').find({ categories: category })
}

showBusinessByCategory("Restaurants")