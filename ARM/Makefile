game: game_engine.o
	gcc -o $@ $+

game_engine.o: game_engine.asm
		as -o $@ $<
clean:
	rm -vf game *.o
