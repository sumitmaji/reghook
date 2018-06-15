require('dotenv').config();
const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const crypto = require('crypto');


//To parse URL encoded data
app.use(bodyParser.urlencoded({
  extended: false
}))
//To parse vnd.docker.distribution.events.v1+json data
app.use(bodyParser.raw({
  type: 'application/vnd.docker.distribution.events.v1+json'
}));
app.use(function(req, res, next) {
  var data = '';
  req.setEncoding('utf8');
  req.on('data', function(chunk) {
    data += chunk;
  });
  req.on('end', function() {
    req.rawBody = data;
  });
  next();
});

app.post('/event', (req, res) => {
  console.log(req.body.toString('utf8'));
  res.send({
    Hi: 'There'
  })
});

app.use((err, req, res, next) => {
  res.status(403).send(err);
})

const PORT = process.env.PORT || 5003
app.listen(PORT);
