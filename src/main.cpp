#include <iostream>
#include <string>
#include <boost/program_options.hpp>
#include "study/calc.hpp"
#include "server/echo.hpp"

int main(int argc, char** argv){
  std::cout<<"hello world"<<std::endl;

  namespace po = boost::program_options;
  po::options_description opt("Option");
  opt.add_options()
    ("help.h","View help")
    ("op",po::value<std::string>(),"Operator(add,sub)")
    ("lhs,l",po::value<int>(),"left")
    ("rhs,r",po::value<int>(),"right")
    ("echo-server","Echo Server")
    ("echo-client","Echo Server-Client");

  po::variables_map vm;
  try{
    po::store(po::parse_command_line(argc, argv, opt), vm);
  }catch(const boost::program_options::error_with_option_name& e){
    std::cout << e.what() << std::endl;
  }
  po::notify(vm);

  if (vm.count("op")) {
    try {
      const std::string op = vm["op"].as<std::string>();
      const int lhs = vm["lhs"].as<int>();
      const int rhs = vm["rhs"].as<int>();
      calc(op,lhs,rhs);
    }catch(const boost::bad_any_cast& e){
      std::cout << e.what() << std::endl;
    }
  }else if(vm.count("echo-server")) {
    try {
      echo_server();
    }catch(const boost::bad_any_cast& e){
      std::cout << e.what() << std::endl;
    }
  }else if(vm.count("echo-client")) {
    try {
      echo_client();
    }catch(const boost::bad_any_cast& e){
      std::cout << e.what() << std::endl;
    }
  }else if(vm.count("help")){
      std::cout << opt << std::endl;
  }else{
      std::cout << opt << std::endl;
  }
	
  return 0;
}
