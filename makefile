.PHONY: test

test:
	jpm test

watch:
	 fswatch --event Updated -o chidi/**  test/** | xargs -n1 -I{} make
