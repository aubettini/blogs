const path = require('path')
const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')
const compression = require('compression')
const { getCurrentInvoke } = require('@vendia/serverless-express')
const ejs = require('ejs').__express
const app = express()
const router = express.Router()
// Azure Cosmos DB
const { CosmosClient } = require("@azure/cosmos");

const connectionString = "AccountEndpoint=XXXX;AccountKey=XXXX;";
const client = new CosmosClient(connectionString);
const databaseId = "Newletters";
const containerId = "Items";

const database = client.database(databaseId);
const container = database.container(containerId);

app.set('view engine', 'ejs')
app.engine('.ejs', ejs)

router.use(compression())
router.use(cors())
router.use(bodyParser.json())
router.use(bodyParser.urlencoded({ extended: true }))

// NOTE: tests can't find the views directory without this
app.set('views', path.join(__dirname, 'views'))

router.get('/api', (req, res) => {
  const currentInvoke = getCurrentInvoke()
  const { event = {} } = currentInvoke
  const { requestContext = {} } = event
  const { domainName = 'localhost:7071' } = requestContext
  const apiUrl = `https://${domainName}`
  res.render('index', { apiUrl })
})

app.get('/api/hello', (req, res) => {
  res.send('Hello World!');
});

router.post("/api/newsletter", async (req, res) => {
  const { email } = req.body;
  // console.log({ body: req.body });

  try {
    // Query to check if the email already exists
    const querySpec = {
      query: "SELECT * FROM c WHERE c.email = @email",
      parameters: [
        {
          name: "@email",
          value: email,
        },
      ],
    };

    const { resources: items } = await container.items.query(querySpec).fetchAll();

    if (items.length > 0) {
      res.status(400).json({ error: "Email already exists" });
    } else {
      const item = {
        id: email,
        email: email,
      };
      // console.log({ item });

      await container.items.create(item);
      res.json({ message: "Subscription created successfully" });
    }
  } catch (error) {
    // console.log(error);
    res.status(500).json({ error: "Could not create user" });
  }
});

router.get('/api/newsletter', async (req, res) => {
  try {
    const { resources: items } = await container.items.readAll().fetchAll();
    res.json(items);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Could not get users" });
  }
});

router.get('/api/feed', (req, res) => {
  const feed = [{
    id: '81614',
    likes: '29',
    replies: '11',
    views: '2.7k',
    author: {
    name: 'Aurelien Bettini',
    imageUrl:
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
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

// The serverless-express library creates a server and listens on a Unix
// Domain Socket for you, so you can remove the usual call to app.listen.
// app.listen(3000)
app.use('/', router)

// Export your express server so you can import it in the lambda function.
module.exports = app