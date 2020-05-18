function addReview(user_id, review_id, text, business_id) {
    db.getCollection('review').insert({
        votes: {
            funny: 0,
            useful: 0,
            cool: 0
        },
        user_id: user_id,
        review_id: review_id,
        stars: 0,
        date: new Date(),
        text: text,
        type: 'review',
        business_id: business_id
    })
}

addReview('QnhQ8G51XbUpVEyWY2Km-A','FRTCszJWkJonDAZx3yr8FA', 'Text review', 'JwUE5GmEO-sH1FuwJgKBlQ')