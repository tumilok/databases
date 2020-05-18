// a)
db.getCollection('business').distinct('city').sort()

// b)
db.getCollection('review').find( {
    date: { $gte: new Date("2011/01/01").toISOString() } 
} )
.count()

// c)
db.getCollection('business').find(
{'open': false},
{
    'name': 1,
    'full_address': 1,
    'stars': 1
})

// d)
db.getCollection('user').find({
$or:
[
    {'votes.funny': {$eq: 0}},
    {'votes.useful': {$eq: 0}}
]
})
.sort({'name': 1})

// e)
db.getCollection('tip').aggregate([
{ $match: {"date": /2012/} },
{ $group: 
    {
        _id: "$business_id",
        tips: {$sum: 1} 
    }
},
{ $sort: {tips: 1} }
])

// f)
db.getCollection('review').aggregate([
{ $group:
    {
        _id: "$business_id",
        avg_stars: {$avg: "$stars"}
    }
},
{ $match: { avg_stars: { $gte: 4 } } }
])

// g)
db.getCollection('business').deleteMany({stars: 2.0})
