#define BOOST_LOG_DYN_LINK 1

#include <iostream>
#include <string>
#include <boost/asio.hpp>
#include <boost/log/trivial.hpp>

using namespace boost::asio;

void info(std::string client, std::string msg){
  BOOST_LOG_TRIVIAL(info) << client << " : " << msg;
}

int echo_server(int port=8080){
  std::cout << "Start Server => localhost:" << port << std::endl;

  boost::asio::io_service io;
  while(true) {
    ip::tcp::iostream buf;
    ip::tcp::endpoint remote;
    ip::tcp::acceptor accept(io, ip::tcp::endpoint(ip::tcp::v4(),port) );

    accept.accept(*buf.rdbuf(), remote);

    std::string temp;
    std::string remote_addr = remote.address().to_string();

    while (true) {
      buf >> temp;
      info(remote_addr, temp);
      if (temp == "quit" || temp == "exit") {
    	buf << ">>bye" << std::endl;
    	info(remote_addr, "logout");
    	break;
      }
      buf << ">>" << temp << std::endl;
    }

  }

  return 0;
}

int echo_client(int port=8080){
  std::cout << "Connect to Server => localhost:" << port << std::endl;
  return 0;
}
