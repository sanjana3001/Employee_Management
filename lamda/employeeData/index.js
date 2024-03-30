const aws = require('aws-sdk')
const ddc = new aws.DynamoDB.DocumentClient()
const tableName = 'employee_details'

exports.handler = async (event) => {
    console.log(event)

    const httpMethod = event.httpMethod
    switch (httpMethod) {
        case 'POST':
            try {
                await _postData(JSON.parse(event.body))
                return _responseHelper(200, "Records inserted successfully!")
            } catch (error) {
                return _responseHelper(404, error.message)
            }
        case 'GET':
            try {
                const response = await _getData()
                return _responseHelper(200, JSON.stringify(response))
            } catch (error) {
                return _responseHelper(404, error.message)
            }
        case 'DELETE':
            try {
                const ID = event.queryStringParameters['ID']
                await _deleteItem(ID)
                return _responseHelper(200, "Item deleted successfully!")
            } catch (error) {
                return _responseHelper(404, error.message)
            }

    }

}

const _postData = async (oRequestData) => {
    let oData = [], count = 0;

    for (let idx = 0; idx < oRequestData.length; idx++) {
        const item = oRequestData[idx];
        count++;

        oData.push({
            PutRequest: {
                Item: {
                    ...item,
                    ID: item.ID,
                }
            }
        });

        // Batch write rejects requests with more than 25 request items
        if (count === 25 || (idx === (oRequestData.length - 1))) {
            try {
                await ddc.batchWrite({
                    RequestItems: {
                        [tableName]: oData // DynamoDB table name
                    }
                }).promise();
                oData = [];
                count = 0;
            } catch (error) {
                throw new Error(error.message);
            }
        }
    }
}

const _getData = async () => {
    const oParams = {
        TableName: tableName,
    };

    try {
        const response = await ddc.scan(oParams).promise();
        return response.Items;
    } catch (error) {
        throw new Error(error.message);
    }
};

const _deleteItem = async (ID) => {
    const oParams = {
        TableName: tableName,
        Key: {
            'ID': ID
        }
    }

    try {
        await ddc.delete(oParams).promise()
    } catch (error) {
        throw new Error(error.message)
    }
};

const _responseHelper = (statusCode, payload) => {
    return {
        "statusCode": statusCode,
        "headers": {
            "Access-Control-Allow-Origin": "*"
        },
        "body": payload
    }
}