var map_fun = function() {
    emit(this.business_id, this.likes);
};

var reduce_fun = function(business_id, likes) {
    return Array.avg(likes);
};

db.getCollection('tip').
mapReduce(
    map_fun,
    reduce_fun,
    { out: "averageBusinessTip"}
)

db.averageBusinessTip.find()