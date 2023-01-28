SHELL := /bin/bash
VERSION := '0.1.0'
NAME := cutting

test:
	rspec

animation:
	./animate.sh

rainbows: install
	irb examples/rainbow_shapes.rb

intersections: install
	irb examples/intersections.rb

irb: install
	irb -r '${NAME}'

install: gem
	gem install ${NAME}-${VERSION}.gem

gem: lib/*.rb ${NAME}.gemspec
	gem build ${NAME}.gemspec

clean:
	rm ${NAME}-*.gem

.PHONY: clean