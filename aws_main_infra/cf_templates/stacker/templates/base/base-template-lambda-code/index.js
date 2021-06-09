var querystring = require('querystring');
var https = require('https');
var AWS = require('aws-sdk');
var shared_account_id = process.env.shared_account_id;
var master_account_id = process.env.master_account_id;
var responseStatus = "FAILED";
var responseData = {};
exports.handler = async (event, context) => {
  exports.handler = async (event, context) => {
    if (event.RequestType == "Delete") {
      responseStatus = "SUCCESS";
      responseData = {Status: "Success"};
      await sendResponse(context, event);
    } else {
      await update(context, event);
      await sendResponse(context, event);
    }
    context.done();
  }
}
async function update(context, event) {
  try {
    let http_promise = updatePromise(event, context);
    let output = await http_promise;
    return output;
  } catch (error) {
    console.log(error);
    return "";
  }
}
function updatePromise(event, context) {
  return new Promise((resolve, reject) => {
    var iam = new AWS.IAM({apiVersion: '2010-05-08'});
    var trustPolicy = {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "AWS": [
              "arn:aws:iam::" + master_account_id + ":root",
              "arn:aws:iam::" + shared_account_id + ":root"
            ]
          },
          "Action": "sts:AssumeRole"
        },
      ]
    };
    var params = {
      PolicyDocument: JSON.stringify(trustPolicy),
      RoleName: "AWSControlTowerExecution"
    };
    iam.updateAssumeRolePolicy(params, function(err, data) {
      if (!err) {
        responseStatus = "SUCCESS";
        responseData = {Status: "Success"};
      }
      resolve("");
    });
  });
}
async function sendResponse(context, event) {
  try {
    let http_promise = sendResponsePromise(event, context, responseStatus, responseData);
    let output = await http_promise;
    return output;
  } catch (error) {
    console.log(error);
    return "";
  }
}
function sendResponsePromise(event, context, responseStatus, responseData) {
  return new Promise((resolve, reject) => {
    var responseBody = JSON.stringify({
      Status: responseStatus,
      Reason: "See the details in CloudWatch Log Stream: " + context.logStreamName,
      PhysicalResourceId: context.logStreamName,
      StackId: event.StackId,
      RequestId: event.RequestId,
      LogicalResourceId: event.LogicalResourceId,
      Data: responseData
    });
    var https = require("https");
    var url = require("url");
    var parsedUrl = url.parse(event.ResponseURL);
    var options = {
      hostname: parsedUrl.hostname,
      port: 443,
      path: parsedUrl.path,
      method: "PUT",
      headers: {
        "content-type": "",
        "content-length": responseBody.length
      }
    };
    var request = https.request(options, function(response) {});
    request.on("error", function(error) {
      resolve("");
    });
    request.write(responseBody);
    request.end();
  });
}
