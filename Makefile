# srcを引数で渡す
run:${src}.cpp
	g++-11 -o build/${src} ${src}.cpp `sdl2-config --cflags --libs`
	./build/${src}

atcoder: main.cpp
	g++-11 -std=gnu++17 -Wall -Wextra -O2 -DONLINE_JUDGE -I/opt/boost/gcc/include -I/opt/ac-library -o ./build/main ./main.cpp
	./build/main

atcoder2: main.cpp
	g++-11 -std=gnu++17 -Wall -Wextra -O2 -DONLINE_JUDGE -I/opt/boost/gcc/include -I/opt/ac-library -o ./build/main ./main.cpp
	./build/main < ${in}

atcoder3: main.cpp
	g++-11 -std=gnu++17 -Wall -Wextra -O2 -DONLINE_JUDGE -I/opt/boost/gcc/include -I/opt/ac-library -o ./build/main ./main.cpp
	./build/main > ${out}

atcoder4: main.cpp
	g++-11 -std=gnu++17 -Wall -Wextra -O2 -DONLINE_JUDGE -I/opt/boost/gcc/include -I/opt/ac-library -o ./build/main ./main.cpp
	./build/main < ${in} > ${out}
