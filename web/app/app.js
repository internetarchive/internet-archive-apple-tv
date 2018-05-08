import ATV from 'atvjs';

// template helpers
import 'lib/template-helpers';
// API
import 'lib/api';
// raw css string
import css from 'assets/css/app.css';
// shared templates
import loaderTpl from 'shared/templates/loader.hbs';
import errorTpl from 'shared/templates/error.hbs';

// pages
import VideoPage from 'pages/video';
import MusicPage from 'pages/music';
import SearchPage from 'pages/search';
import YearsPage from 'pages/years';
import YearItemsPage from 'pages/year-items';
import PlayPage from 'pages/play';
import AccountPage from 'pages/account';

ATV.start({
	style: css,
	menu: {
		items: [{
			id: 'video',
			name: 'Videos',
			page: VideoPage,
			attributes: { autoHighlight: true }
		}, {
			id: 'music',
			name: 'Music',
			page: MusicPage
		}, {
			id: 'search',
			name: 'Search',
			page: SearchPage
		}, {
			id: 'account',
			name: 'Account',
			page: AccountPage
		}]
	},
	templates: {
		loader: loaderTpl,
		error: errorTpl,
		// status level error handlers
		status: {
			'404': () => errorTpl({
				title: '404',
				message: 'Page cannot be found!'
			}),
			'500': () => errorTpl({
				title: '500',
				message: 'An unknown error occurred in the application. Please try again later.'
			}),
			'503': () => errorTpl({
				title: '500',
				message: 'An unknown error occurred in the application. Please try again later.'
			})
		}
	},
	onLaunch(options) {
		ATV.Navigation.navigateToMenuPage();
	}
});