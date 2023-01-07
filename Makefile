VERSION := '0.1.0'
NAME := cutting

test:
	rspec

irb: gem
	gem install ${NAME}-${VERSION}.gem
	irb -r '${NAME}'

gem: lib/*.rb ${NAME}.gemspec
	gem build ${NAME}.gemspec

clean:
	rm ${NAME}-*.gem

.PHONY: clean