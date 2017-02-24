require('oracle-apm');

var fs = require('fs');

var path = process.argv[2]

if (path) {
  var server = fs.readFileSync("./server.js", "utf-8");
  eval(server);
} else {
  console.log("Required argument (path to js file to run) is missing");
  process.exit();
}
