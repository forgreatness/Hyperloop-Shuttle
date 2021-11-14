#!/bin/sh
':' //# http://sambal.org/?p=1014 ; exec /usr/bin/env node "$0" "$@"
'use strict';


const CFonts = require('cfonts')

CFonts.say('Hello, npm world !', { font: 'chrome', colors: ['yellow', 'green', 'red']})
