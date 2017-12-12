
.PHONY: install test

install:
	raco pkg install wordpress

tests: 
	raco test wordpress/test
