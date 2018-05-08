import ATV from 'atvjs';
import template from './template.hbs';
import API from 'lib/api';

var SignupPage = ATV.Page.create({
	name: 'signup',
	template: template,
	ready(options, resolve, reject) {
		resolve();
	}
});

export default SignupPage;