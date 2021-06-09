var AWS = require("aws-sdk");
var fs = require("fs");
let path = require("path");
var cloudformation = new AWS.CloudFormation();
var region = process.env.AWS_REGION;
const STACKSET_NAME = "Custom-ComtrolTower-Baseline-Stack";
exports.handler = async (event, context, callback) => {
  try {
    console.log(JSON.stringify(event));
    var isStackExist = await stackExist();
    if (!isStackExist) {
      context.fail("Stack Set doesn't exist. Please create the baseline stackset.");
    }
    var accounts = [event.detail.serviceEventDetails.createManagedAccountStatus.account.accountId];
    await createStackInstance(accounts);
    context.succeed();
  } catch (err) {
    context.fail("Error Occured: " + err);
  }
};
function createStackInstancePromise(accArr) {
  return new Promise((resolve, reject) => {
    var params = {
      Regions: [region],
      StackSetName: STACKSET_NAME,
      DeploymentTargets: { Accounts: accArr },
    };
    cloudformation.createStackInstances(params, function(err, data) {
      if (err) reject(err);
      else resolve();
    });
  });
}
async function createStackInstance(accArr) {
  try {
    let http_promise = createStackInstancePromise(accArr);
    let output = await http_promise;
    return output;
  } catch (error) {
    console.log(error);
    throw error;
  }
}
function stackExistPromise() {
  return new Promise((resolve, reject) => {
    var params = { StackSetName: STACKSET_NAME };
    cloudformation.describeStackSet(params, function(err, data) {
      if (err) {
        if (err.statusCode) resolve(false);
        else reject(err);
      } else {
        resolve(true);
      }
    });
  });
}
async function stackExist() {
  try {
    let http_promise = stackExistPromise();
    let output = await http_promise;
    return output;
  } catch (error) {
    console.log(error);
    throw error;
  }
}
