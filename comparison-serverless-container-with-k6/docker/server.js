'use strict';

const express = require('express');
const cors = require('cors');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';

// App
const app = express();
app.use(cors());

app.get('/', (req, res) => {
  res.send('Hello World!');
});

// AWS
const { DynamoDBClient, ScanCommand, QueryCommand } = require("@aws-sdk/client-dynamodb");
const {
  DynamoDBDocumentClient,
  GetCommand,
  PutCommand,
} = require("@aws-sdk/lib-dynamodb");

const USERS_TABLE = "newsletter-table-dev"
const client = new DynamoDBClient({ region: "eu-west-1" });
const dynamoDbClient = DynamoDBDocumentClient.from(client);
app.use(express.json());

// Standard
app.get('/feed', (req, res) => {
  const feed = [{
    id: '81614',
    likes: '29',
    replies: '11',
    views: '2.7k',
    author: {
    name: 'Aurelien Bettini',
    imageUrl:
    'https://i.stack.imgur.com/frlIf.png',
    href: '#',
    },
    date: 'March 20 at 11:43 AM',
    datetime: '2023-03-20T11:43:00',
    href: '#',
    title: 'Pain au Chocolat or Croissant: Which is the better choice?',
    body: "<p>The age-old debate between pain au chocolat and croissant has been dividing pastry lovers for generations. Both are delicious French pastries with flaky, buttery layers that melt in your mouth, but the inclusion of chocolate in the pain au chocolat adds an extra element of indulgence.</p> <p>Ultimately, the choice between these two delightful pastries comes down to personal preference, but it's worth considering the following factors when making your decision…</p>" ,
    }]

  res.send(feed);
});

// AWS
app.post("/newsletter", async (req, res) => {
  const { email } = req.body;

  // email (Partition key)

  const queryParams = {
    TableName: USERS_TABLE,
    KeyConditionExpression: "email = :email",
    ExpressionAttributeValues: {
      ":email": { S: email },
    },
  };

  try {
    const queryResult = await dynamoDbClient.send(new QueryCommand(queryParams));
    if (queryResult.Items.length > 0) {
      res.status(409).json({ message: "Email already exists" });
      return;
    }
  } catch (error) {
    res.status(500).json({ error: "Error checking for existing email" });
    return;
  }

  const params = {
    TableName: USERS_TABLE,
    Item: {
      email: email,
    },
  };

  try {
    await dynamoDbClient.send(new PutCommand(params));
    res.json({ message: "Subscription created successfully" });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Could not create user" });
  }
});

app.get('/item', async (req, res) => {
  // get all newsletter emails
  const params = {
    TableName: USERS_TABLE,
    Key: {
      email: 'email',
    },
  };

  try {
    const queryResult = await dynamoDbClient.send(new GetCommand(params));
    res.json(queryResult.Item);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/newsletter', async (req, res) => {
  // get all newsletter emails
  const params = {
    TableName: USERS_TABLE,
  };

  try {
    const queryResult = await dynamoDbClient.send(new ScanCommand(params));
    res.json(queryResult.Items);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: error.message });
  }
});


app.listen(PORT, HOST, () => {
  console.log(`Running on http://${HOST}:${PORT}`);
});
