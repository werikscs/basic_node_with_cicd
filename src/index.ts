import 'dotenv/config'
import express from 'express'

const app = express()
const port =
  process.env.NODE_ENV === 'production'
    ? process.env.PORT_PROD
    : process.env.PORT_DEV

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.listen(port, () => {
  return console.log(`Express is listening at http://localhost:${port}`)
})
