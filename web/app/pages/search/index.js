import ATV from 'atvjs';
import search from './search.hbs';
import result from './result.hbs';
import API from 'lib/api';

var SearchPage = ATV.Page.create({
	name: 'search',
	template: search,
	afterReady(doc) {
		let searchField = doc.getElementsByTagName('searchField').item(0);
		let keyboard = searchField && searchField.getFeature('Keyboard');

		if (keyboard) {
			keyboard.onTextChange = function() {
				let searchText = keyboard.text;
				Search(doc, searchText, function(data){
					var movies = [];
					var music = [];

					data.forEach(function(item){
						if (item.mediatype == 'movies') {
							movies.push(item);
						} else {
							music.push(item);
						}
					});

					var domImplementation = doc.implementation;
					var lsParse = domImplementation.createLSParser(1, null);
					var lsInput = domImplementation.createLSInput();

					lsInput.stringData = result({movies: movies, music, music});
					lsParse.parseWithContext(lsInput, doc.getElementsByTagName('collectionList').item(0), 2);
				}, function(err){

				});
			}
		}
	}
});

function Search(doc, query, success, fail) {
	let options = {
		'rows': '50',
		'fl[]' : 'identifier,title,downloads,mediatype',
      	'sort[]' : 'downloads+desc'
	}

	API.Search(query + 'AND mediatype:(etree OR movies)', options, function(data){
		success(data.response.docs);
	}, function(err){
		fail(err)
	});
}

export default SearchPage;