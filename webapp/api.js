var express = require('express');
var api = express();

var morgan = require('morgan');
var bodyParser = require('body-parser');

api.set('appPath', 'public_html');
api.use(express.static(__dirname + '/public_html'));
api.use(morgan('dev'));
api.use(bodyParser.urlencoded({'extended':'true'}));
api.use(bodyParser.json());
api.use(bodyParser.json({ type: 'application/vnd.api+json' }));


api.get('/api/listing', function(req, res){
	var listing = [{
		text: 'Row 1'
	}, {
		text: 'Row 2'
	}];
	
	res.send(listing);
});

api.route('/*')
	.get(function(req, res){
		res.sendFile(api.get('appPath') + '/index.html');		
	});	

api.listen(8080);
console.log("Application listening on port 8080");