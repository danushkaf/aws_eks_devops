var querystring = require('querystring');
var https = require('https');
var AWS = require('aws-sdk');

let region = process.env.AWS_REGION;
let delivery_status_role_arn = process.env.delivery_status_role_arn;
let topic_arn = process.env.topic_arn;

var responseStatus = "FAILED";
var responseData = {};

exports.handler = async (event, context) => {
  console.log("REQUEST RECEIVED:\n" + JSON.stringify(event));
  // For Delete requests, immediately send a SUCCESS response.
  if (event.RequestType == "Delete") {
    responseStatus = "SUCCESS";
    responseData = {Status: "Success"};
    await sendResponse(context, event);
    return;
  }
  await updateHTTPSuccessLogDeliveryStatus(context, event);
  await updateHTTPFailureLogDeliveryStatus(context, event);
  await updateHTTPSampleRateLogDeliveryStatus(context, event);
  await updateSQSSuccessLogDeliveryStatus(context, event);
  await updateSQSFailureLogDeliveryStatus(context, event);
  await updateSQSampleRateLogDeliveryStatus(context, event);
  await sendResponse(context, event);
}

function updateHTTPSuccessLogDeliveryStatusPromise(context) {
  return new Promise((resolve, reject) => {
    var sns = new AWS.SNS();
    var params = {
      AttributeName: 'HTTPSuccessFeedbackRoleArn',
      TopicArn: topic_arn,
      AttributeValue: delivery_status_role_arn
    };
    sns.setTopicAttributes(params, function(err, data) {
      if (err) {
        console.log(err);
        reject(err);
      }
      else {
        console.log(data);
        resolve(data);
      }
    });
  });
}

async function updateHTTPSuccessLogDeliveryStatus(context, event) {
  try {
    let http_promise = updateHTTPSuccessLogDeliveryStatusPromise(context);
    let update_log_delivery_status_output = await http_promise;
    responseStatus = "SUCCESS";
    responseData = {Status: "Success"};
    return update_log_delivery_status_output;
  } catch (error) {
    console.log(error);
    responseData = {Error: "Update Delivery Status call failed"};
    return "";
  }
}

function updateHTTPFailureLogDeliveryStatusPromise(context) {
  return new Promise((resolve, reject) => {
    var sns = new AWS.SNS();
    var params = {
      AttributeName: 'HTTPFailureFeedbackRoleArn',
      TopicArn: topic_arn,
      AttributeValue: delivery_status_role_arn
    };
    sns.setTopicAttributes(params, function(err, data) {
      if (err) {
        console.log(err);
        reject(err);
      }
      else {
        console.log(data);
        resolve(data);
      }
    });
  });
}

async function updateHTTPFailureLogDeliveryStatus(context, event) {
  try {
    let http_promise = updateHTTPFailureLogDeliveryStatusPromise(context);
    let update_log_delivery_status_output = await http_promise;
    responseStatus = "SUCCESS";
    responseData = {Status: "Success"};
    return update_log_delivery_status_output;
  } catch (error) {
    console.log(error);
    responseData = {Error: "Update Delivery Status call failed"};
    return "";
  }
}

function updateHTTPSampleRateLogDeliveryStatusPromise(context) {
  return new Promise((resolve, reject) => {
    var sns = new AWS.SNS();
    var params = {
      AttributeName: 'HTTPSuccessFeedbackSampleRate',
      TopicArn: topic_arn,
      AttributeValue: '1'
    };
    sns.setTopicAttributes(params, function(err, data) {
      if (err) {
        console.log(err);
        reject(err);
      }
      else {
        console.log(data);
        resolve(data);
      }
    });
  });
}

async function updateHTTPSampleRateLogDeliveryStatus(context, event) {
  try {
    let http_promise = updateHTTPSampleRateLogDeliveryStatusPromise(context);
    let update_log_delivery_status_output = await http_promise;
    responseStatus = "SUCCESS";
    responseData = {Status: "Success"};
    return update_log_delivery_status_output;
  } catch (error) {
    console.log(error);
    responseData = {Error: "Update Delivery Status call failed"};
    return "";
  }
}

function updateSQSSuccessLogDeliveryStatusPromise(context) {
  return new Promise((resolve, reject) => {
    var sns = new AWS.SNS();
    var params = {
      AttributeName: 'SQSSuccessFeedbackRoleArn',
      TopicArn: topic_arn,
      AttributeValue: delivery_status_role_arn
    };
    sns.setTopicAttributes(params, function(err, data) {
      if (err) {
        console.log(err);
        reject(err);
      }
      else {
        console.log(data);
        resolve(data);
      }
    });
  });
}

async function updateSQSSuccessLogDeliveryStatus(context, event) {
  try {
    let http_promise = updateSQSSuccessLogDeliveryStatusPromise(context);
    let update_log_delivery_status_output = await http_promise;
    responseStatus = "SUCCESS";
    responseData = {Status: "Success"};
    return update_log_delivery_status_output;
  } catch (error) {
    console.log(error);
    responseData = {Error: "Update Delivery Status call failed"};
    return "";
  }
}

function updateSQSFailureLogDeliveryStatusPromise(context) {
  return new Promise((resolve, reject) => {
    var sns = new AWS.SNS();
    var params = {
      AttributeName: 'SQSFailureFeedbackRoleArn',
      TopicArn: topic_arn,
      AttributeValue: delivery_status_role_arn
    };
    sns.setTopicAttributes(params, function(err, data) {
      if (err) {
        console.log(err);
        reject(err);
      }
      else {
        console.log(data);
        resolve(data);
      }
    });
  });
}

async function updateSQSFailureLogDeliveryStatus(context, event) {
  try {
    let http_promise = updateSQSFailureLogDeliveryStatusPromise(context);
    let update_log_delivery_status_output = await http_promise;
    responseStatus = "SUCCESS";
    responseData = {Status: "Success"};
    return update_log_delivery_status_output;
  } catch (error) {
    console.log(error);
    responseData = {Error: "Update Delivery Status call failed"};
    return "";
  }
}

function updateSQSampleRateLogDeliveryStatusPromise(context) {
  return new Promise((resolve, reject) => {
    var sns = new AWS.SNS();
    var params = {
      AttributeName: 'SQSSuccessFeedbackSampleRate',
      TopicArn: topic_arn,
      AttributeValue: '1'
    };
    sns.setTopicAttributes(params, function(err, data) {
      if (err) {
        console.log(err);
        reject(err);
      }
      else {
        console.log(data);
        resolve(data);
      }
    });
  });
}

async function updateSQSampleRateLogDeliveryStatus(context, event) {
  try {
    let http_promise = updateSQSampleRateLogDeliveryStatusPromise(context);
    let update_log_delivery_status_output = await http_promise;
    responseStatus = "SUCCESS";
    responseData = {Status: "Success"};
    return update_log_delivery_status_output;
  } catch (error) {
    console.log(error);
    responseData = {Error: "Update Delivery Status call failed"};
    return "";
  }
}

async function sendResponse(context, event) {
  try {
    let http_promise = sendResponsePromise(event, context, responseStatus, responseData);
    let snapshot_register_output = await http_promise;
    return snapshot_register_output;
  } catch (error) {
    console.log(error);
    return "";
  }
}

// Send response to the pre-signed S3 URL
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

    console.log("RESPONSE BODY:\n", responseBody);

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

    console.log("SENDING RESPONSE...\n");

    var request = https.request(options, function(response) {
      console.log("STATUS: " + response.statusCode);
      console.log("HEADERS: " + JSON.stringify(response.headers));
      // Tell AWS Lambda that the function execution is done
      context.done();
    });

    request.on("error", function(error) {
      console.log("sendResponse Error:" + error);
      // Tell AWS Lambda that the function execution is done
      context.done();
    });

    // write data to request body
    request.write(responseBody);
    request.end();
  });
}
