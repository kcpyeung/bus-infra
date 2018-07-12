var AWS = require('aws-sdk');
var docClient = new AWS.DynamoDB.DocumentClient({region: 'ap-southeast-1'});

getBusStop = function(id, context) {
  var params = {TableName: 'BusStops', Key: {busStopCode: id}};
  return docClient.get(params, function(err, data) {
    if (err) console.log(err);
    else context.done(null, data.Item);
  });
}

exports.main = function(event, context, callback)
{
  getBusStop(event.busStopCode, context);
}

