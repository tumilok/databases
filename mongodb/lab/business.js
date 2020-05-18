//Task 5
use ImieNazwiskoNrGrupy

//a
db.getCollection('business').find({stars:5.0})

//b
db.getCollection('business').aggregate( [
    {"$match" : { categories: "Restaurants" } },
    {"$group" : { _id:"$city", count:{$sum:1} } },
    {"$sort"  : {"count":-1} }
] )

db.getCollection('business').aggregate( [
    {"$match": { categories: "Hotels" } },
    {"$match" : { attributes: { "Wi-Fi": "free" } } },
    {"$match" : { stars: { $gte: 4.5 } } },
    {"$group" : { _id:"$state", count:{$sum:1} } },
] )

