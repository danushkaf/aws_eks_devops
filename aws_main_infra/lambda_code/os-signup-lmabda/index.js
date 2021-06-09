const AWS = require('aws-sdk');
const cognitoidentityserviceprovider = new AWS.CognitoIdentityServiceProvider();

const region = process.env.AWS_REGION;
const userpool_id = process.env.userpool_id;
const app_client_id = process.env.app_client_id;

exports.handler = async (event, context) => {

    let username = event.username;
    let password = event.password;

    await cognitoidentityserviceprovider
        .adminCreateUser({
            UserPoolId: userpool_id,
            Username: username,
            MessageAction: 'SUPPRESS',
            TemporaryPassword: password
        })
        .promise();

    const initAuthResponse = await cognitoidentityserviceprovider.adminInitiateAuth({
        AuthFlow: 'ADMIN_NO_SRP_AUTH',
        ClientId: app_client_id,
        UserPoolId: userpool_id,
        AuthParameters: {
            USERNAME: username,
            PASSWORD: password
        }
    }).promise()

    if (initAuthResponse.ChallengeName === 'NEW_PASSWORD_REQUIRED') {
        await cognitoidentityserviceprovider.adminRespondToAuthChallenge({
            ChallengeName: 'NEW_PASSWORD_REQUIRED',
            ClientId: app_client_id,
            UserPoolId: userpool_id,
            ChallengeResponses: {
                USERNAME: username,
                NEW_PASSWORD: password
            },
            Session: initAuthResponse.Session
        }).promise()
    }

    const emailVerified = await cognitoidentityserviceprovider
        .adminUpdateUserAttributes({
            UserAttributes: [{
                Name: 'email_verified',
                Value: 'true',
            }],
            UserPoolId: userpool_id,
            Username: username
        })
        .promise();

    context.done(null, event);
};