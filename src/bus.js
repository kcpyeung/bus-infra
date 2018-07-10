exports.main = function(event, context, callback)
{
  context.done(null, {"name": event.smelly});
}

