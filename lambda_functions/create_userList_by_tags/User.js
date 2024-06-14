const mongoose = require('mongoose');

const user_schema = new mongoose.Schema({
    username: String,
    password: String,
    image: String,
    tags:  [{
        tag : String,
        score : Number
    }]
}, { collection: 'tedConnect_users' });

module.exports = mongoose.model('user', user_schema);