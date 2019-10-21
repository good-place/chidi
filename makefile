.PHONY: test

test:
	jpm test

watch:
	 fswatch --event Updated -o chidi/*.janet chidi/**/*.janet test/*.janet test/**/*.janet | xargs -n1 -I{} make
