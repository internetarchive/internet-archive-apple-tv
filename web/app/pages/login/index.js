import ATV from 'atvjs';
import template from './template.hbs';
import API from 'lib/api';

var LoginPage = ATV.Page.create({
	name: 'login',
	template: template,
	ready(options, resolve, reject) {
		resolve();
	}
});

export default LoginPage;