const express = require('express');
const app = express();
app.get('/appointments', (req, res) => {
  res.json({service:"Appointment Service", data:[{id:101,doctor:"Dr Kumar"}]});
});
app.listen(3000);