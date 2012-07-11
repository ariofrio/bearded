MOCHAFLAGS=--compilers coffee:coffee-script --require should --require sugar

.PHONY: test test-watch develop

test:
	find src -name '*_test.coffee' | xargs mocha $(MOCHAFLAGS)

watch:
	find src -name '*_test.coffee' | xargs mocha $(MOCHAFLAGS) --watch

develop:
	asdf &
	coffee --watch --output js/ src/
