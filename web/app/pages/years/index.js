import ATV from 'atvjs';
import template from './template.hbs';
import API from 'lib/api';

var YearsPage = ATV.Page.create({
	name: 'years',
	template: template,
	ready(options, resolve, reject) {
		let title = options.title;
		let identifier = options.identifier;
		let collection = options.collection;

		API.GetCollections(identifier, collection, 15, function(collection, data){
		// API.GetCollections('movies', 'collection', null, function(collection, data){
			var yearHasItems = {};
			var sortedData = [];
			data.forEach(function(item){
				var year = item.year || 'Undated';
				yearHasItems[year] = true;
				
				if (!(year in sortedData)) {
					sortedData[year] = [];
				}

				sortedData[year].push(item);
			});
			sortedData.sort(function(a, b){
				return parseInt(b.year) - parseInt(a.year);
			});

			resolve({
				data: sortedData,
				title: title,
				collection: collection,
				identifier: identifier,
			});
		}, function(){
			console.log('VideoPage - reject');
			reject();
		});
	}
});

export default YearsPage;