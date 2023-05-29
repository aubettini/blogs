'use strict';

const express = require('express');
const NextAuth = require("next-auth").default;
const cors = require('cors');

// Create an Express object and routes (in order)
const app = express();

app.use(cors());

app.get('/', (req, res) => {
  res.send('Hello World!');
});

// GCP
const { Firestore } = require('@google-cloud/firestore');

const firestore = new Firestore({
  projectId: 'expressapitest',
});

app.post('/newsletter', async (req, res) => {
  try {
    const { email } = req.body;
    const newsletterSubscriptionRef = firestore.collection('newsletter-subscription');

    // Check if email exists in the newsletter-subscription collection
    const querySnapshot = await newsletterSubscriptionRef.where('email', '==', email).get();

    if (!querySnapshot.empty) {
      return res.status(400).send({ error: 'Email already exists' });
    }

    // Add new subscription to the newsletter-subscription collection
    const newSubscription = {
      email,
      ACTIVE: true,
    };
    await newsletterSubscriptionRef.add(newSubscription);

    res.status(200).send({ message: 'Subscription created successfully' });
  } catch (error) {
    // console.log({"error": error})
    res.status(500).send({ error: 'Error adding subscription' });
  }
});

app.get('/feed', (req, res) => {
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

exports.http = app;

exports.event = (event, callback) => {
  callback();
};
