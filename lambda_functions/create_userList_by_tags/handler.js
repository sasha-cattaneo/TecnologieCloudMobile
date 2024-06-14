const connect_to_db = require('./db');

// GET BY TALK HANDLER

const user = require('./User');

module.exports.get_userList = (event, context, callback) => {
    context.callbackWaitsForEmptyEventLoop = false;
    console.log('Received event:', JSON.stringify(event, null, 2))
    let body = {}
    if (event.body) {
        body = JSON.parse(event.body)
    }
    // set default
    if(!body.tags) {
        callback(null, {
                    statusCode: 500,
                    headers: { 'Content-Type': 'text/plain' },
                    body: 'Could not fetch the talks. Tags is null.'
        })
    }
    
    console.log("=> scoreLevel: ["+body.scoreLevel+"]")
    
    
    var minScore = 0;
    switch(body.scoreLevel){
        case 0:{
            minScore = 9
            break
        }
        case 1:{
            minScore = 49
            break
        }
        case 2:{
            minScore = 89
            break
        }
        default:{
            minScore = 49
        }
    }
    
    console.log("=> tags: [ tag1: ["+body.tags[0].tag+"] tag2: ["+body.tags[1].tag+"] tag3: ["+body.tags[2].tag+"], ["+minScore+"]")
    
    connect_to_db().then(() => {
        console.log('=> get_all users')
        user.find({ 
            $and: [
                { tags: {$elemMatch: { tag: body.tags[0].tag, score: {$gt: minScore } } } },
                { tags: {$elemMatch: { tag: body.tags[1].tag, score: {$gt: minScore } } } },
                { tags: {$elemMatch: { tag: body.tags[2].tag, score: {$gt: minScore } } } }
            ]}
            )
            .then(users => {
                    callback(null, {
                        statusCode: 200,
                        body: JSON.stringify(users)
                    })
                }
            )
            .catch(err =>
                callback(null, {
                    statusCode: err.statusCode || 500,
                    headers: { 'Content-Type': 'text/plain' },
                    body: 'Could not fetch the users.'
                })
            );
    });
};