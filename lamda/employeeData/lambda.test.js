const lambdaFunction = require('./index');

describe('Lambda Function Tests', () => {
    test('POST request', async () => {
        const postData = [
            {
                Convicted: 'No',
                Address: 'Heilbronn',
                Department: 'Software',
                Position: 'Developer',
                ID: '3',
                Age: 23,
                Name: 'anu',
            },
           
        ];
    
        const event = {
            httpMethod: 'POST',
            body: JSON.stringify(postData),
        };
    
        const result = await lambdaFunction.handler(event);
        expect(result.statusCode).toBe(404); 
    }, 10000); 

    test('GET request', async () => {
        const event = {
            httpMethod: 'GET',
        };

        const result = await lambdaFunction.handler(event);
        expect(result.statusCode).toBe(404); // Update the expected status code
        // Add more assertions based on your expected result
    });

    test('DELETE request', async () => {
        const event = {
            httpMethod: 'DELETE',
            queryStringParameters: {
                ID: '1', // Specify the ID to be deleted
            },
        };

        const result = await lambdaFunction.handler(event);
        expect(result.statusCode).toBe(404); // Update the expected status code
        // Add more assertions based on your expected result
    });
});
