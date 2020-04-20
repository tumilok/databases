function changeUserName(user_id, user_name) {
    db.getCollection('user').findOneAndUpdate(
        { _id: new ObjectId(user_id) },
        { $set: { name: user_name } }
    )
}

changeUserName('5e9068c2c30c1ce8610df3eb', 'Alexandra')