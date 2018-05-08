import ATV from 'atvjs';
import API from 'lib/api';

var PlayPage = ATV.Page.create({
    name: 'play',
    ready(options, resolve, reject) {
		let identifier = options.identifier;
		let title = options.title;

		API.GetMetaData(identifier, function(data){
			console.log('PlayPage-', data);
			let player = new Player();
			let playlist = new Playlist();

			var filesToPlay = [];
			var collection = 'movies';
			var mediaType = (collection == 'movies') ? 'video': 'audio';

			data.files.forEach(function(file){
				if (collection == 'movies' && file.name.endsWith('.mp4')) {
					filesToPlay.push(file);
				} else if (collection == 'etree' && file.name.endsWith('.mp3')) {
					filesToPlay.push(file);
				}
			});

			filesToPlay.sort(function(a, b){
				return parseInt(a.track) - parseInt(b.track);
			}).forEach(function(file){
				let mediaItem = new MediaItem('video', "https://archive.org/download/" + identifier + "/" + encodeURI(file.name));
				mediaItem.title = file.title || title;
				mediaItem.subtitle = file.album;
				mediaItem.artworkImageURL = "https://archive.org/services/get-item-image.php?identifier=" + identifier;
				playlist.push(mediaItem);
			});

			player.playlist = playlist;
			player.play();

			resolve(false);
		}, function(){
			reject();
		});
		
    }
});

export default PlayPage;