
build:
	jbuilder build

install:
	jbuilder build
	jbuilder install

build/example/hello: 
	./_build/default/examples/hello.exe

update/example/hello: 
	./_build/default/examples/hello.exe update

