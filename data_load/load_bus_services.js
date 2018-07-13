var AWS = require('aws-sdk');
var docClient = new AWS.DynamoDB.DocumentClient({region: 'ap-southeast-1'});

var toRecord = function(busService) {
  busService.serviceDetails = JSON.stringify(busService.serviceDetails);
  return {
    TableName : 'BusServices',
    Item: busService
  };
};

var insertToDb = function(record) {
  docClient.put(record, function(err, data) {
    if (err) { console.log(err); console.log(JSON.stringify(record)); }
    else console.log(data);
  });
};

var busStops = require('./bus-services.json');
Object
  .keys(busStops)
  .map(function(serviceNumber) { return { serviceNumber : serviceNumber, serviceDetails: busStops[serviceNumber] } })
  .map(toRecord)
  .forEach(insertToDb);

