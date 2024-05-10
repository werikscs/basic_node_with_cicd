import 'dotenv/config'
import express from 'express'

const app = express()
const port = 3000
const environmentMsg =
  process.env.NODE_ENV === 'production' ? 'Production' : 'Development'

app.get('/', (req, res) => {
  res.send(`Hello World, from ${environmentMsg}!`)
})

app.listen(port, () => {
  return console.log(`Express is listening at http://localhost:${port}`)
})
