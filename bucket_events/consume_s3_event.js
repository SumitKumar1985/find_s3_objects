var aws = require('aws-sdk');
var S3 = new aws.S3();

exports.handler = function(event, context) {
  console.log('Received event:', JSON.stringify(event, null, 2));

  var element = event.Records[0];
  var bucket = element.s3.bucket.name;
  var key = decodeURIComponent(element.s3.object.key.replace(/\+/g, " "));
  var eventName = element.eventName;

  console.log("Received event", eventName, "for key", key, "in S3 bucket",
    bucket);

  S3.getObject({
    Bucket: bucket,
    Key: key
  }, function(err, data) {
    if (err) {
      console.log(err);
    } else {
      console.log('Content type:', data.ContentType);
      context.succeed();
    }
  });
}
