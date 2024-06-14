const connect_to_db = require('./db');

// GET BY TALK HANDLER

const talk = require('./Talk');

module.exports.get_tags = (event, context, callback) => {
    context.callbackWaitsForEmptyEventLoop = false;
    
    let body = {}

    
    connect_to_db().then(() => {
        console.log('=> get_all talks');
        talk.distinct("tags")
            .then(talks => {
                    callback(null, {
                        statusCode: 200,
                        body: JSON.stringify(talks)
                    })
                }
            )
            .catch(err =>
                callback(null, {
                    statusCode: err.statusCode || 500,
                    headers: { 'Content-Type': 'text/plain' },
                    body: 'Could not fetch the talks.'
                })
            );
    });
};