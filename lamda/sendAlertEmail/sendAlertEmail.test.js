const { handler } = require('./index'); 

// Mock the AWS SDK
jest.mock('aws-sdk', () => {
    const mockSES = {
        sendEmail: jest.fn().mockReturnThis(),
        promise: jest.fn(),
    };

    return {
        SES: jest.fn(() => mockSES),
    };
});

describe('Lambda Function', () => {
    test('Should send email when Convicted is "Yes"', async () => {
        const event = {
            Records: [
                {
                    eventName: 'INSERT',
                    dynamodb: {
                        NewImage: {
                            Name: { S: 'John Doe' },
                            Convicted: { S: 'Yes' }
                        }
                    }
                }
            ]
        };

        const result = await handler(event);
        expect(result).toBeUndefined();
    });


    test('Should not send email when Convicted is not "Yes"', async () => {
        const event = {
            Records: [
                {
                    eventName: 'INSERT',
                    dynamodb: {
                        NewImage: {
                            Name: { S: 'Jane Doe' },
                            Convicted: { S: 'No' }
                        }
                    }
                }
            ]
        };

        const result = await handler(event);
        expect(result).toBeUndefined(); // No error expected
    });

    test('Should not send email on REMOVE event', async () => {
        const event = {
            Records: [
                {
                    eventName: 'REMOVE',
                    dynamodb: {
                        NewImage: {
                            Name: { S: 'John Doe' },
                            Convicted: { S: 'Yes' }
                        }
                    }
                }
            ]
        };

        const result = await handler(event);
        expect(result).toBeUndefined(); // No error expected
    });
});
