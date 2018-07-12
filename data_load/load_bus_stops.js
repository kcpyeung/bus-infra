var AWS = require('aws-sdk');
var docClient = new AWS.DynamoDB.DocumentClient({region: 'ap-southeast-1'});

var toRecord = function(busStop) {
  return {
    TableName : 'BusStops',
    Item: busStop
  };
};

var insertToDb = function(record) {
  docClient.put(record, function(err, data) {
    if (err) console.log(err);
    else console.log(data);
  });
};

var busStops = require('./bus-stop.json');
busStops
  .map(toRecord)
  .forEach(insertToDb);

