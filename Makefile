VERSION := '0.1.0'
NAME := cutting

test:
	rspec

rainbows: gem
	gem install ${NAME}-${VERSION}.gem
	irb examples/rainbow_shapes.rb

irb: gem
	gem install ${NAME}-${VERSION}.gem
	irb -r '${NAME}'

gem: lib/*.rb ${NAME}.gemspec
	gem build ${NAME}.gemspec

clean:
	rm ${NAME}-*.gem

.PHONY: clean