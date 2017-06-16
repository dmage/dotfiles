gettimeofday: main.c
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

install: gettimeofday
	install $< "$$HOME/bin/$<"
