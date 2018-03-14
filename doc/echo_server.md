# Echo Server

## Echo Server

[boost/asioのlink optionはこちら](http://pazzle1230.hatenablog.com/entry/2014/02/03/231036)

[参考にしたsource codeはこちら](https://qiita.com/YukiMiyatake/items/456e95f7d2fa79e463db)


## logging

coutされねぇ……。

```
int echo_server(int port=8080){
  std::cout << "Start Server => localhost:" << port << std::endl;

  boost::asio::io_service io;
  while(true) {
    ip::tcp::iostream buf;
    ip::tcp::acceptor accept(io, ip::tcp::endpoint(ip::tcp::v4(),port) );
    accept.accept(*buf.rdbuf());
    std::string temp;
    while (true) {
      buf >> temp;
      if (temp == "quit") {
	buf << ">>bye" << std::endl;
	break;
      }
      buf << ">>" << temp << std::endl;
    }
    info(temp);
  }

  return 0;
}
```

coutする位置が違う。acceptしたあとは更に内側のwhile loopで回しているのにその外側でcoutしようとしてもそりゃ駄目だ。

無事coutできた。


### timestamp

- [http://faithandbrave.hateblo.jp/entry/20130725/1374736211](http://faithandbrave.hateblo.jp/entry/20130725/1374736211)
- [http://d.hatena.ne.jp/yamada28go/20140215/1392470561](http://d.hatena.ne.jp/yamada28go/20140215/1392470561)

timestampを表示しようと思ったけど、boost.Logを用いて普通にlogっぽく書く。

```
#include <boost/log/trivial.hpp>
#include <boost/log/core.hpp>
#include <boost/log/expressions.hpp>
```

これを呼び出して、

```
  BOOST_LOG_TRIVIAL(info) << msg;
```

こんな感じで呼び出す。

`-lboost_log`をbuild optionに追加して、linkerがerror。

```
g++  -o ./bin/server -L/usr/local/Cellar/boost/1.65.1/lib -lboost_program_options -lpthread main.o -lboost_system -lboost_log study/calc.o server/echo.o
Undefined symbols for architecture x86_64:
  "boost::log::v2s_mt_posix::record_view::public_data::destroy(boost::log::v2s_mt_posix::record_view::public_data const*)", referenced from:
      info(std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> >) in echo.o
  "boost::log::v2s_mt_posix::aux::stream_provider<char>::release_compound(boost::log::v2s_mt_posix::aux::stream_provider<char>::stream_compound*)", referenced from:
      boost::log::v2s_mt_posix::aux::record_pump<boost::log::v2s_mt_posix::sources::severity_logger_mt<boost::log::v2s_mt_posix::trivial::severity_level> >::~record_pump() in echo.o
  "boost::log::v2s_mt_posix::aux::stream_provider<char>::allocate_compound(boost::log::v2s_mt_posix::record&)", referenced from:
      info(std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> >) in echo.o
  "boost::log::v2s_mt_posix::aux::unhandled_exception_count()", referenced from:
      info(std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> >) in echo.o
      boost::log::v2s_mt_posix::aux::record_pump<boost::log::v2s_mt_posix::sources::severity_logger_mt<boost::log::v2s_mt_posix::trivial::severity_level> >::~record_pump() in echo.o
  "boost::log::v2s_mt_posix::core::open_record(boost::log::v2s_mt_posix::attribute_set const&)", referenced from:
      boost::log::v2s_mt_posix::record boost::log::v2s_mt_posix::sources::basic_composite_logger<char, boost::log::v2s_mt_posix::sources::severity_logger_mt<boost::log::v2s_mt_posix::trivial::severity_level>, boost::log::v2s_mt_posix::sources::multi_thread_model<boost::log::v2s_mt_posix::aux::light_rw_mutex>, boost::log::v2s_mt_posix::sources::features<boost::log::v2s_mt_posix::sources::severity<boost::log::v2s_mt_posix::trivial::severity_level>, void, void, void, void, void, void, void, void, void> >::open_record<boost::parameter::aux::tagged_argument<boost::log::v2s_mt_posix::keywords::tag::severity, boost::log::v2s_mt_posix::trivial::severity_level const> >(boost::parameter::aux::tagged_argument<boost::log::v2s_mt_posix::keywords::tag::severity, boost::log::v2s_mt_posix::trivial::severity_level const> const&) in echo.o
  "boost::log::v2s_mt_posix::core::push_record_move(boost::log::v2s_mt_posix::record&)", referenced from:
      boost::log::v2s_mt_posix::aux::record_pump<boost::log::v2s_mt_posix::sources::severity_logger_mt<boost::log::v2s_mt_posix::trivial::severity_level> >::~record_pump() in echo.o
  "boost::log::v2s_mt_posix::sources::aux::get_severity_level()", referenced from:
      boost::log::v2s_mt_posix::record boost::log::v2s_mt_posix::sources::basic_composite_logger<char, boost::log::v2s_mt_posix::sources::severity_logger_mt<boost::log::v2s_mt_posix::trivial::severity_level>, boost::log::v2s_mt_posix::sources::multi_thread_model<boost::log::v2s_mt_posix::aux::light_rw_mutex>, boost::log::v2s_mt_posix::sources::features<boost::log::v2s_mt_posix::sources::severity<boost::log::v2s_mt_posix::trivial::severity_level>, void, void, void, void, void, void, void, void, void> >::open_record<boost::parameter::aux::tagged_argument<boost::log::v2s_mt_posix::keywords::tag::severity, boost::log::v2s_mt_posix::trivial::severity_level const> >(boost::parameter::aux::tagged_argument<boost::log::v2s_mt_posix::keywords::tag::severity, boost::log::v2s_mt_posix::trivial::severity_level const> const&) in echo.o
  "boost::log::v2s_mt_posix::trivial::logger::get()", referenced from:
      info(std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> >) in echo.o
  "boost::log::v2s_mt_posix::core::get_logging_enabled() const", referenced from:
      boost::log::v2s_mt_posix::record boost::log::v2s_mt_posix::sources::basic_composite_logger<char, boost::log::v2s_mt_posix::sources::severity_logger_mt<boost::log::v2s_mt_posix::trivial::severity_level>, boost::log::v2s_mt_posix::sources::multi_thread_model<boost::log::v2s_mt_posix::aux::light_rw_mutex>, boost::log::v2s_mt_posix::sources::features<boost::log::v2s_mt_posix::sources::severity<boost::log::v2s_mt_posix::trivial::severity_level>, void, void, void, void, void, void, void, void, void> >::open_record<boost::parameter::aux::tagged_argument<boost::log::v2s_mt_posix::keywords::tag::severity, boost::log::v2s_mt_posix::trivial::severity_level const> >(boost::parameter::aux::tagged_argument<boost::log::v2s_mt_posix::keywords::tag::severity, boost::log::v2s_mt_posix::trivial::severity_level const> const&) in echo.o
ld: symbol(s) not found for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
make[1]: *** [bin/server] Error 1
make: *** [all] Error 2
```

[http://marycore.jp/prog/xcode/undefined-symbols-for-architecture-x86-64/](http://marycore.jp/prog/xcode/undefined-symbols-for-architecture-x86-64/)

によると、

> リンク時にエラーが発生している。ソースコード内で利用している関数やグローバル変数の実体が見つからないことが原因。

とのことなので、`BOOST_LOG_TRIVIAL(info) << msg;`もcomment outしてincludeだけしてbuild。

同じerror。includeも外していく。

呼んでいるdefinedやincludeを一つずつ消していったら、全部comment outしてもerrorになった。なんでさ。

ああmakefileの中で二回LDFLAGSを呼び出していた……。まずこれで復旧。

次は`-lboost_log`をつけて実行。成功。

`include`をいれてmake。成功。

では肝心の`BOOST_LOG_TRIVIAL(info)`をいれてmake。失敗。ここか。

しかしどうもうまくいかない。

[https://stackoverflow.com/questions/36117306/link-errors-using-homebrews-boostlog-in-osx-el-capitan](https://stackoverflow.com/questions/36117306/link-errors-using-homebrews-boostlog-in-osx-el-capitan)
[https://stackoverflow.com/questions/32270246/error-linking-boost-with-cmake/32307981#32307981](https://stackoverflow.com/questions/32270246/error-linking-boost-with-cmake/32307981#32307981)
こういうことっぽいけど、optionをいじっても通らない。

[http://www.howtobuildsoftware.com/index.php/how-do/Iew/c-osx-boost-macports-boost-logging-fails-to-compile-on-osx](http://www.howtobuildsoftware.com/index.php/how-do/Iew/c-osx-boost-macports-boost-logging-fails-to-compile-on-osx)

> You are experiencing a standard library mismatch. Boost from MacPorts (and all other libraries from MacPorts and on modern OS X since 10.9, I think) are built against clang's libc++, rather than gcc's libstdc++. If you attempt to mix both standard libraries, you'll run into this problem (which is a good thing, because if you wouldn't see this, you'd likely see hard to debug crashes at runtime).

うあん。んもう。

Dockerで環境再構築。

sourceの冒頭に

```
#define BOOST_LOG_DYN_LINK 1

#include <iostream>
#include <string>
#include <boost/asio.hpp>
#include <boost/log/trivial.hpp>
```

という風に`#define BOOST_LOG_DYN_LINK 1`を定義したら通った。


### client information

LogにClientのIP AddressやPort番号も記載したい。

- [https://stackoverflow.com/questions/601763/how-to-get-ip-address-of-boostasioiptcpsocket](https://stackoverflow.com/questions/601763/how-to-get-ip-address-of-boostasioiptcpsocket)
- [http://www.boost.org/doc/libs/1_62_0/doc/html/boost_asio/reference/ip__tcp/socket.html](http://www.boost.org/doc/libs/1_62_0/doc/html/boost_asio/reference/ip__tcp/socket.html)

このあたりを参考にできないかなー。でもasioだとacceptまで一気にやっていてsocket特に定義してないんだよな。

とりあえずremoteとの通信に使っているsocketを取得出来ればいいのはわかった。

```
std::string remote_addr = socket.remote_endpoint().address().to_string();
```

で、そのsocketはio_serviceから取ってこれるの？

[https://boostjp.github.io/tips/network/tcp.html](https://boostjp.github.io/tips/network/tcp.html)

```
asio::io_service io_service;
tcp::socket socket(io_service);
```

とってこれそうね。

socketをとってくるまではできた。あとはここからremoteのaddressをとってくるだけ。


- [http://www.boost.org/doc/libs/1_62_0/doc/html/boost_asio/reference/basic_socket_acceptor/accept.html](http://www.boost.org/doc/libs/1_62_0/doc/html/boost_asio/reference/basic_socket_acceptor/accept.html)

```
Accept a new connection and obtain the endpoint of the peer.


template<
    typename SocketService>
void accept(
    basic_socket< protocol_type, SocketService > & peer,
    endpoint_type & peer_endpoint);
```

あ、いけるのでは？
