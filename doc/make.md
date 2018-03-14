# Makefileの使い方

## Fileを分ける

- ./include/study/calc.h
- ./src/study/calc.cpp
- ./src/main.cpp

という風にわけたわけだけど、これをmain.cppからcalc.hを読んでcompileしたい

### headerを探す

```
g++  -o ./bin/server -I/usr/local/Cellar/boost/1.65.1/include ./include -L/usr/local/Cellar/boost/1.65.1/lib -lboost_program_options ./src/main.cpp
./src/main.cpp:4:10: fatal error: 'study/calc.hpp' file not found
#include <study/calc.hpp>
         ^~~~~~~~~~~~~~~~
1 error generated.
make: *** [all] Error 1
```

で、駄目だった。


[https://stackoverflow.com/questions/12654013/how-to-make-g-search-for-header-files-in-a-specific-directory](https://stackoverflow.com/questions/12654013/how-to-make-g-search-for-header-files-in-a-specific-directory)

これを見る限り指定の仕方は間違ってない気がするんだけどなあ。

[http://gmaj7sus4.hatenablog.com/entry/2013/11/15/163242](http://gmaj7sus4.hatenablog.com/entry/2013/11/15/163242)

これも微妙に違う。

```
$ make CPPFLAGS=-v
g++ -v -o ./bin/server -I/usr/local/Cellar/boost/1.65.1/include ./include -L/usr/local/Cellar/boost/1.65.1/lib -lboost_program_options ./src/main.cpp
Apple LLVM version 9.0.0 (clang-900.0.39.2)
Target: x86_64-apple-darwin17.4.0
Thread model: posix
InstalledDir: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
 "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang" -cc1 -triple x86_64-apple-macosx10.13.0 -Wdeprecated-objc-isa-usage -Werror=deprecated-objc-isa-usage -emit-obj -mrelax-all -disable-free -disable-llvm-verifier -discard-value-names -main-file-name main.cpp -mrelocation-model pic -pic-level 2 -mthread-model posix -mdisable-fp-elim -fno-strict-return -masm-verbose -munwind-tables -target-cpu penryn -target-linker-version 305 -v -dwarf-column-info -debugger-tuning=lldb -resource-dir /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/9.0.0 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk -I /usr/local/Cellar/boost/1.65.1/include -I/usr/local/include -stdlib=libc++ -fdeprecated-macro -fdebug-compilation-dir /Users/kuboki/Dropbox/develop/study/cpp/003_server -ferror-limit 19 -fmessage-length 187 -stack-protector 1 -fblocks -fobjc-runtime=macosx-10.13.0 -fencode-extended-block-signature -fcxx-exceptions -fexceptions -fmax-type-align=16 -fdiagnostics-show-option -fcolor-diagnostics -o /var/folders/14/svc607bx12scc5_qqyt253xh0000gn/T/main-ecdab5.o -x c++ ./src/main.cpp
clang -cc1 version 9.0.0 (clang-900.0.39.2) default target x86_64-apple-darwin17.4.0
ignoring nonexistent directory "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk/usr/include/c++/v1"
ignoring nonexistent directory "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk/usr/local/include"
ignoring nonexistent directory "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk/Library/Frameworks"
#include "..." search starts here:
#include <...> search starts here:
 /usr/local/Cellar/boost/1.65.1/include
 /usr/local/include
 /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1
 /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/9.0.0/include
 /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include
 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk/usr/include
 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk/System/Library/Frameworks (framework directory)
End of search list.
./src/main.cpp:4:10: fatal error: 'study/calc.hpp' file not found
#include <study/calc.hpp>
         ^~~~~~~~~~~~~~~~
1 error generated.
make: *** [all] Error 1
```

ほら、./includeが見えてない。

[https://stackoverflow.com/questions/5846804/how-to-add-multiple-header-include-and-library-directories-to-the-search-path-in](https://stackoverflow.com/questions/5846804/how-to-add-multiple-header-include-and-library-directories-to-the-search-path-in)

もう一つ`-I`を追加しないといけないのか。

```
make
g++ -O2 -MMD -Wall -Wextra  -o ./bin/server -I./include -I/usr/local/Cellar/boost/1.65.1/include -L/usr/local/Cellar/boost/1.65.1/lib -lboost_program_options ./src/main.cpp
Undefined symbols for architecture x86_64:
  "calc(std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> >, int, int)", referenced from:
      _main in main-3572d4.o
ld: symbol(s) not found for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
make: *** [all] Error 1
```

Errorが変わった。includeはできたらしい。

### linker error

まあobject作ってないのでそりゃlinkerでerrorも出るよね。

```
$ make
g++ -O2 -MMD -Wall -Wextra  -o ./src/main.o -c ./src/main.cpp -I./include -I/usr/local/Cellar/boost/1.65.1/include
g++ -O2 -MMD -Wall -Wextra  -o ./src/study/calc.o -c ./src/study/calc.cpp
g++  -o ./bin/server -L/usr/local/Cellar/boost/1.65.1/lib -lboost_program_options ./src/main.o ./src/study/calc.o
$ ls ./bin
total 208
drwxr-xr-x@ 3 kuboki  staff    96B  2 21 16:27 ./
drwxr-xr-x@ 8 kuboki  staff   256B  2 21 16:27 ../
-rwxr-xr-x@ 1 kuboki  staff   103K  2 21 16:27 server*
```

できた。

いやでもこの書き方だと依存関係をちゃんと解決出来てないというか、file更新まで把握出来てない。

```
all: main.o calc.o
	@if [ -d ./bin ]; then \
	rm -rf ./bin; \
	fi
	-@mkdir -p ./bin;
	$(CXX) $(LDFLAGS) -o ./bin/$(PROG) -L/usr/local/Cellar/boost/1.65.1/lib -lboost_program_options ./src/main.o ./src/study/calc.o

main.o: ./src/main.cpp ./include/study/calc.hpp
	$(CXX) $(CPPFLAGS) -o ./src/main.o -c ./src/main.cpp -I./include -I/usr/local/Cellar/boost/1.65.1/include

calc.o: ./src/study/calc.cpp
	$(CXX) $(CPPFLAGS) -o ./src/study/calc.o -c ./src/study/calc.cpp 
```

### pathを考慮した依存関係の解消

[https://qiita.com/maaato414/items/89566fc7addc82540e4f](https://qiita.com/maaato414/items/89566fc7addc82540e4f)

やっぱりsource codeのあるところにmakefileを置くのが筋っぽいなあ。



## Verboseによるfalg制御

[http://7ujm.net/linux/2.html](http://7ujm.net/linux/2.html)

- Compile Option (CPPFLAGS)に-O0
- Link Option (LDFLAGS)
- include option
- GNUの形式にあわせるとか

## 差分更新

依存関係の書き方がおかしいと駄目

```
bin/server: main.o study/calc.o server/echo.o
```

こう書いておけば、bin/serverを生成する時にmain.o study/calc.o server/echo.oの差分を見に行く。

あとセオリーとして、他のdirectoryのobjectが必要なら以下のようにallの中で呼び出すといい。

```
all: bin/server
	make -C ./study CXX=$(CXX) CPPFLAGS=$(CPPFLAGS) STD=$(STD)
	make -C ./server CXX=$(CXX) CPPFLAGS=$(CPPFLAGS) STD=$(STD)
bin/server: main.o study/calc.o server/echo.o
	@if [ -d ./bin ]; then \
	rm -rf ./bin; \
	fi
	-@mkdir -p ./bin;
	$(CXX) $(LDFLAGS) -o ./bin/server -L$(BOOST)/lib -lboost_program_options -lpthread main.o -lboost_system study/calc.o server/echo.o

main.o: main.cpp study/calc.hpp server/echo.hpp
	$(CXX) $(CPPFLAGS) -o main.o -c main.cpp -Istudy -Iserver -I$(BOOST)/include $(STD)
```

こうしておくと、

1. 最初にobjectの生成を仕様とする
2. object生成のmakefileの依存関係からfileの更新の有無を見てcompile(cppやhppを依存対象として書いておけば、sourceの変更を見てくれる)
3. objectの依存関係を見てbinが生成される

という流れ

