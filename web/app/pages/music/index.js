import ATV from 'atvjs';
import template from './template.hbs';
import API from 'lib/api';


var MusicPage = ATV.Page.create({
	name: 'music',
	template: template,
	ready(options, resolve, reject) {
		API.GetCollections('etree', 'collection', 15, function(collection, data){
		// API.GetCollections('movies', 'collection', null, function(collection, data){
			resolve({
				data: data,
				collection: collection
			});
		}, function(){
			console.log('VideoPage - reject');
			reject();
		});
	}
});

export default MusicPage;