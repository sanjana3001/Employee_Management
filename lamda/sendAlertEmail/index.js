const aws = require('aws-sdk')

const oParams = {
    Destination: {
        ToAddresses: [
            "sanjanas.3001@gmail.com", /* Reciver Email */

        ]
    },
    Message: {
        Body: {
            Text: {
                Charset: "UTF-8",
                Data: ""
            }
        },
        Subject: {
            Charset: "UTF-8",
            Data: "Convicted Employee Added"
        }
    },
    Source: "sanjanas.3001+source@gmail.com", /* Sender Email */
}

const ses = new aws.SES()

exports.handler = async (event) => {
    console.log(JSON.stringify(event))

    for (let item of event.Records) {

        if (item.eventName === 'REMOVE') return

        /********************** Parsing the params from event object *******************/
        const Name = item.dynamodb.NewImage.Name['S']
        const Convicted = item.dynamodb.NewImage.Convicted['S']


        if (Convicted === "yes" || Convicted === "Yes" || Convicted === "YES") {
            try {
                const msgBody = `Hello Team! Employee ${Name} has selected Convicted as ${Convicted}. Please collect complete information on that.`
                oParams.Message.Body.Text['Data'] = msgBody
                await ses.sendEmail(oParams).promise()
            } catch (error) {
                return error.message
            }
        }
    }
}