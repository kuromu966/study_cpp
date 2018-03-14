#include <iostream>
#include <string>

int calc(std::string op, int lhs, int rhs){
  if (op == "add")
    {
      std::cout << lhs + rhs << std::endl;
    }
  if (op == "sub")
    {
      std::cout << lhs - rhs << std::endl;
    }
  return 0;
}
