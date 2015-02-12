js :
	./node_modules/pogo/bin/pogo -c src/routism.pogo

publish : js
	npm publish

mocha :
	./node_modules/mocha/bin/mocha spec/*_spec.pogo

test : mocha

spec : mocha
