// index.js
const serverlessExpress = require('@vendia/serverless-express')
const app = require('./app')
const cachedServerlessExpress = serverlessExpress({ app })

module.exports = async function (context, req) {
  return cachedServerlessExpress(context, req)
}