all:
	racc -g -S -o lib/parser.rb lib/parser.y
	./fr examples/example.fr
