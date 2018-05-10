# IA-ATV
AppleTV interface to Internet Archive

### Development
Assuming that you have [nodejs](https://nodejs.org/) and [npm](https://www.npmjs.com/) installed on your machine, do the following to get started:

```shell
$ npm install -g gulp                   # Install Gulp globally
$ npm install                           # Install dependencies
```

Builds the application and starts a webserver. By default the webserver starts at port 9001.

```shell
$ npm run dev # development
$ npm start # production
```
### Structure
The project is split into two parts:

- atv: this directory contains the Xcode project and related files. The AppDelegate.swift file handles the setup of the TVMLKit framework and launching the JavaScript context to manage the application.
- web: this directory contains the JavaScript and TVML template files needed to render the application. The contents of this directory must be hosted on a server accessible from the device.

