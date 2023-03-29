const functions = require('firebase-functions');
 const admin = require('firebase-admin');

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const sgMail = require('@sendgrid/mail');
exports.sendMailSendGrid = functions.https.onCall(async (data, context) => {
    sgMail.setApiKey("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");
    var toEmail = data['toEmail'];
    var fromEmail = data['fromEmail'];
    var subject = data['subject'];
    var text = data['text'];
    var html = data['html'];
    var msg = {
        to: toEmail,
        from: fromEmail,
        subject: subject,
        text: text,
        html: html,
    };
  
    sgMail.send(msg, function (error, info) {
                if (error) {
                    console.log(error);
                } else {
                    console.log('Email sent: ' + info.response);
                }
            });
});