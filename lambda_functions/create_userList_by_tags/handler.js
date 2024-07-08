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
    console.log("=> tags number:"+ Object.keys(body.tags).length )
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
    
    var query = "";
    
    switch (Object.keys(body.tags).length) {
        case 1:
            query = { tags: {$elemMatch: { tag: body.tags[0].tag, score: {$gt: minScore } } } }
            break;
        case 2:
            query = 
            { $and: [
                { tags: {$elemMatch: { tag: body.tags[0].tag, score: {$gt: minScore } } } },
                { tags: {$elemMatch: { tag: body.tags[1].tag, score: {$gt: minScore } } } }
            ]}
            break;
        case 3:
            query = 
            { $and: [
                { tags: {$elemMatch: { tag: body.tags[0].tag, score: {$gt: minScore } } } },
                { tags: {$elemMatch: { tag: body.tags[1].tag, score: {$gt: minScore } } } },
                { tags: {$elemMatch: { tag: body.tags[2].tag, score: {$gt: minScore } } } }
            ]}
            break;
        default:
            // code
    }
    console.log("=> query: "+JSON.stringify(query))
    connect_to_db().then(() => {
        console.log('=> get_all users')
        user.find(query)
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