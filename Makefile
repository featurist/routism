js :
	./node_modules/pogo/bin/pogo -c src/routism.pogo

publish : js
	npm publish

mocha :
	mocha spec/*_spec.pogo

test : mocha

spec : mocha