var fs = require('fs');
var Excel = require('exceljs');
var workbook = new Excel.Workbook();
var json = JSON.parse(fs.readFileSync('data.json', 'utf8'));
console.log("Size:", json.length);
var sheet = workbook.addWorksheet('My Sheet');
sheet.columns = [
    { header: 'Username', key: 'username'},
    { header: 'Insta link', key: 'link'},
	 { header: 'Tag', key: 'tag'},
	  { header: 'Twitter Username', key: 'twitter_username'},
	   { header: 'Twitter link', key: 'twitter_url'}
];
sheet.addRows(json);
 
workbook.xlsx.writeFile('Export.xlsx')
    .then(function() {
        // done
		console.log("Export success!");
    });
