const AWS = require('aws-sdk');
const cognitoidentityserviceprovider = new AWS.CognitoIdentityServiceProvider();

const region = process.env.AWS_REGION;
const userpool_id = process.env.userpool_id;

exports.handler = async (event, context) => {

    let username = event.username;
    let password = event.password;

    const emailVerified = await cognitoidentityserviceprovider.adminSetUserPassword({
            Password: password,
            Permanent: true,
            Username: username,
            UserPoolId: userpool_id
        })
        .promise();
    context.done(null, event);
};