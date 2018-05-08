import ATV from 'atvjs';
import template from './template.hbs';

var YearItemsPage = ATV.Page.create({
	name: 'year-items',
	template: template,
	ready(options, resolve, reject) {
		console.log('YearItemsPage-', options);
		var data = options;
		var title = options[0].year;

		data.sort(function(a, b){
			return parseInt(a.week) - parseInt(b.week);
		});

		resolve({
			data: data,
			title: title
		});
	}
});

export default YearItemsPage;