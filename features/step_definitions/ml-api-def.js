const request = require('superagent')
const sha256 = require('js-sha256').sha256
const { Given, When, Then, BeforeAll, AfterAll } = require('cucumber')
const { Client } = require('pg')
const bcrypt = require('bcrypt')
const expect = require('chai').expect

const dbConnectionString = 'postgresql://mladmin:mladmin@localhost:6666/mldata'

const client = new Client({
  connectionString: dbConnectionString,
})

let plainPassword

BeforeAll(() => {
  // ignore certificate checking
  process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = 0
  client.connect()

})

AfterAll(() => {
  client.end()
})
Given(/^We have a password/, { timeout: 60 * 1000 }, () => {
  const currentDate = new Date()
  let day = currentDate.getDate()
  let month = currentDate.getMonth() + 1 //Be careful! January is 0 not 1
  let year = currentDate.getFullYear()
  let hour = currentDate.getHours()
  let minutes = currentDate.getMinutes()
  plainPassword = sha256.hex(`Uniplace${year}${month}${day}${hour}${minutes}0441001000`)
  console.log(`Given password is ${plainPassword}`)

  const hashedPassword = bcrypt.hashSync(plainPassword, 0)
  client.query(`UPDATE user_api SET api_key='${hashedPassword}' WHERE api_user='uniplace'`, (err, res) => {
    console.log(err, res)
  })
})

let response
When(/^I ping the api/, { timeout: 60 * 1000 }, async () => {
  response = await request
    .get('https://localhost:6001/health.json')
    .auth('uniplace', plainPassword)
    .set('Accept', 'application/json').then(r => r)
})

Then(/^I should receive succeful response/, { timeout: 60 * 1000 }, () => {
  expect(response.status).to.eql(200)
  expect(response.body).to.eql({})
})

When(/^I search for a room with (.*)/, { timeout: 60 * 1000 }, async (referenceId) => {
  response = await request
    .get(`https://localhost:6001/v1/object/room.json?referenceId=${referenceId}`)
    .auth('uniplace', plainPassword)
    .set('Accept', 'application/json').then(r => r)
    .catch(err => err)
})


Then(/^I receive the room object with (.*)/, { timeout: 60 * 1000 }, (referenceId) => {
  expect(response.status).to.eql(200)
  expect(response.body.reference_id).to.eql(referenceId)
})

Then(/^I receive a response with status (.*)/, { timeout: 60 * 1000 }, (status) => {
  expect(response.status).to.eql(parseInt(status, 10))
})


When(/^I search for all free rooms/, { timeout: 60 * 1000 }, async () => {
  response = await request
    .get(`https://localhost:6001/v1/object/rooms.json`)
    .auth('uniplace', plainPassword)
    .set('Accept', 'application/json').then(r => r)
    .catch(err => err)
})

Then(/^I receive an array with rooms/, { timeout: 60 * 1000 }, () => {
  expect(response.status).to.eql(200)
  expect(response.body.length).to.eql(10)
})


When(/^I search for free rooms in (.*)/, { timeout: 60 * 1000 }, async (city) => {
  response = await request
    .get(`https://localhost:6001/v1/object/rooms.json`)
    .query({ city: city })
    .auth('uniplace', plainPassword)
    .set('Accept', 'application/json')
    .then(r => r)
    .catch(err => err)
})

Then(/^I receive an array with (.*) rooms/, { timeout: 60 * 1000 }, (nr) => {
  expect(response.status).to.eql(200)
  expect(response.body.length).to.eql(parseInt(nr, 10))
})

When(/^I search for rooms between (.*) and (.*) in (.*)/, { timeout: 60 * 1000 }, async (min, max,city) => {
  response = await request
    .get(`https://localhost:6001/v1/object/rooms.json`)
    .query({ city: city })
    .query({priceFrom: min})
    .query({priceTo: max})
    .auth('uniplace', plainPassword)
    .set('Accept', 'application/json')
    .then(r => r)
    .catch(err => err)
})

When(/^I search for sorted rooms with (.*) and (.*) and (.*) in (.*)/, { timeout: 60 * 1000 }, async (sortBy, type, limit, city) => {
  response = await request
    .get(`https://localhost:6001/v1/object/rooms.json`)
    .query({ city: city })
    .query({sortBy: sortBy})
    .query({type: type})
    .query({limit: limit})
    .auth('uniplace', plainPassword)
    .set('Accept', 'application/json')
    .then(r => r)
    .catch(err => err)
})


