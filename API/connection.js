import tedious from 'tedious'
import config from './configurations.json' assert {type: "json"};

var connection = tedious.Connection;
var dbConnection = new connection(config);

dbConnection.on('connect',function(err){
    if(err)
        console.log(err);
    else{
        console.log('connected');
    }
});
export default dbConnection;