## How to execute this tests

1. Execute shell script start_env.sh form resources folder

2. npm install

3. npm run test

4. Execute shell script clean_env.sh from resources folder

## Jascript code for sha256

const currentDate = new Date()
let day = currentDate.getDate()
let month = currentDate.getMonth() + 1 //Be careful! January is 0 not 1
let year = currentDate.getFullYear()
let hour = currentDate.getHours()
let minutes = currentDate.getMinutes()
plainPassword = sha256.hex(`Uniplace${year}${month}${day}${hour}${minutes}0441001000`)

## Used Libraries

1. Rest Client Superagent

https://github.com/visionmedia/superagent
https://visionmedia.github.io/superagent/

2. Node Postgres for pg connection

https://node-postgres.com/

3. ChaiJs for assertions

http://www.chaijs.com/

