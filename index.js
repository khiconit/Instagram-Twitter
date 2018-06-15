var fs = require('fs'),
	rp = require('request-promise');
	var _ = require('lodash');
	var file = fs.readFileSync('links.txt', 'utf8')
	var json = JSON.parse(fs.readFileSync('data.json', 'utf8'));
	var data =  file.trim().replace( /\n/g, " " ).split( " " );
	var links  = _.take(data,3);
	data = _.drop(data,3);
	fs.writeFile('links.txt', data.join("\n"), function (err) { 
	  if (err) throw err;
	  console.log('Write file!');
	});
	for(let i in links)
	{
		let link = links[i];
		execute(link);
	 
		
		
		
	}
	function execute(link ){
		var options = {
			uri: link,
			 
			headers: {
				'User-Agent': 'Request-Promise'
			},
			json: false // Automatically parses the JSON string in the response
		};

		rp(options).then( (dom)=>{
			var data = dom.split('window._sharedData =')
			data = data[1].split(';</script>');
			data = JSON.parse(data[0])
			var media = data.entry_data.PostPage[0].graphql.shortcode_media;
			var username = media.owner.username;
			var shortcode  = media.shortcode;
			var $data = { username: username, link:  'https://www.instagram.com/p/' + shortcode + '/?taken-by=' + username , tag: link };
			rp({ uri: 'http://dev.the4.co/twitteroauth/?username='+ username , method: 'GET', json: true}).then((response)=>{
				//console.log(typeof response);
				//console.log(response);
				if(response.length)
				{
					$data.twitter_username = username;
					$data.twitter_url= response[0].extended_entities.media[0].expanded_url;
				}
				json.push($data);
				fs.writeFile('data.json', JSON.stringify(json ) , function (err) { 
				  if (err) throw err;
				  console.log('Write Json!');
				});
			}).catch( (x)=>{
				//console.log(x);
				json.push($data);
				fs.writeFile('data.json', JSON.stringify(json ) , function (err) { 
				  if (err) throw err;
				  console.log('Write Json!');
				});
			})
			
		}).catch( (e)=>{
			console.log(e);
		})
	}
	