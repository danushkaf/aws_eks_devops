const AWS = require('aws-sdk');
const cognitoidentityserviceprovider = new AWS.CognitoIdentityServiceProvider();

const region = process.env.AWS_REGION;
const userpool_id = process.env.userpool_id;

exports.handler = async (event, context) => {
    const emailVerified = await cognitoidentityserviceprovider
        .adminUpdateUserAttributes({
            UserAttributes: [{
                    Name: 'email',
                    Value: event.newUserName
                },
                {
                    Name: 'email_verified',
                    Value: 'true',
                }
            ],
            UserPoolId: userpool_id,
            Username: event.oldUserName
        })
        .promise();
    context.done(null, event);
};