const express = require('express');
const app = express();
app.get('/patients', (req, res) => {
  res.json({service:"Patient Service", data:[{id:1,name:"Ravi"}]});
});
app.listen(3000);