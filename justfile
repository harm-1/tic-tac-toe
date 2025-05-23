PROJECT_NAME := 'tic-tac-toe'
D := 'docker'
dir := `pwd`
DC := "docker compose -p "+PROJECT_NAME

# Name os the DC service
fe := 'server'

build *flags:
	{{DC}} build {{flags}}

up service='':
    {{DC}} up -d {{service}}

up-attach service:
    {{DC}} up {{service}}

down service='':
    {{DC}} down {{service}}

exec-sh service:
    {{DC}} exec -it {{service}} sh

run-sh service:
    {{DC}} run -it {{service}} sh

############ frontend
webpack-watch:
    {{DC}} run --no-deps --rm --entrypoint='' {{fe}} yarn watch

webpack-build:
    {{DC}} run --rm {{fe}} node_modules/.bin/webpack

yarn-install:
    {{DC}} run --rm -it {{fe}} yarn install

yarn-add package:
    {{DC}} run --rm -it {{fe}} yarn add {{package}}

