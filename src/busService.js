var AWS = require('aws-sdk');
var docClient = new AWS.DynamoDB.DocumentClient({region: 'ap-southeast-1'});

getBusService = function(id, context) {
  var params = {TableName: 'BusServices', Key: {serviceNumber : id}};
  return docClient.get(params, function(err, data) {
    if (err) console.log(err);
    else context.done(null, JSON.parse(data.Item.serviceDetails));
  });
}

exports.main = function(event, context, callback)
{
  getBusService(event.serviceNumber, context);
}

