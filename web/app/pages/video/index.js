import ATV from 'atvjs';
import template from './template.hbs';
import API from 'lib/api';

var VideoPage = ATV.Page.create({
	name: 'video',
	template: template,
	ready(options, resolve, reject) {
		API.GetCollections('movies', 'collection', 15, function(collection, data){
		// API.GetCollections('movies', 'collection', null, function(collection, data){
			resolve({
				data: data,
				collection: collection
			});
		}, function(){
			reject();
		});
	}
});

export default VideoPage;