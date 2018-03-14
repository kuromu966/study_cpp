# Command Option

[http://nekko1119.hatenablog.com/entry/20130414/1365921531](http://nekko1119.hatenablog.com/entry/20130414/1365921531])

> boost::program_options名前空間にあるクラスを用いると、コマンドライン引数（オプション）を柔軟に簡単に解析できます。

らしい。

## Namespaceについて

しかし早速C++の記法がよくわからないぞーこれ。

```
  namespace po = boost::program_options;
  po::options_description opt("Option");
```

[http://sealsoft.jp/namespace.html](http://sealsoft.jp/namespace.html)

> 名前空間は、空間に名前を付け、その中に型や変数、関数などを入れることで識別名の衝突を防ぐものだ。

んなこたぁわかっとるわい。

名前空間内の関数を呼び出したりするには`int a = seal::foo();`と書くらしい。なので`boost::program_options`もそのたぐいだろうけど、`po`の型は`namespace`なんだよなあ。

> boost::program_options名前空間にあるクラスを用いると、コマンドライン引数（オプション）を柔軟に簡単に解析できます。

とあるから、`options_description`は`boost::program_options`の中にあるclassなんだろう。これを呼び出したくて書いているんだけど記法の意味がよくわからない。

まあ実際的に活躍しているのは`opt("Option")`なので、こいつを定義したくて呼び出したんだろう。

うーん。どこかで自分でnamesapce使ってみないとわからない気がする。

というかsourceみればいいか。` /usr/local/Cellar/boost/1.65.1/include/boost/program_options/options_description.hpp`を見てみる。

```
/** Boost namespace */
namespace boost { 
/** Namespace for the library. */
namespace program_options {
    class BOOST_PROGRAM_OPTIONS_DECL option_description {
    public:
```

と定義されている。なので呼び出しとしてはわかる。

ああ。`namespace`型でまず`program_options`までをlocalで定義して、そのあと`options_description`classを`opt`という名前で定義しているだけか。

## ()が続く記法について

()が続く記法がまた謎。

```
  opt.add_options()
    ("help.h","View help")
    ("op",po::value<std::string>(),"Operator(add,sub)")
    ("lhs,l",po::value<int>(),"left")
    ("rhs,r",po::value<int>(),"right");
```

`option_description`は`class BOOST_PROGRAM_OPTIONS_DECL option_description`として定義されたclass。

あとからの振る舞いを考えるに似たような構造の引数をいくつもいっきに入れているだけなんだろうけど、なんだろうこれ。この記法の名前がわからないので調べるのがちょっとつらい。

あ、でも、このclassの中に、

```
        option_description(const char* name,
                           const value_semantic* s);

        option_description(const char* name,
                           const value_semantic* s,
                           const char* description);
```

という定義が入っている。これに一致するのはわかる。

ってよく見たら`add_options`が入り口だった。こっちみないと。

```
        options_description_easy_init add_options();

        const option_description& find(const std::string& name, 
                                       bool approx, 
                                       bool long_ignore_case = false,
                                       bool short_ignore_case = false) const;

        const option_description* find_nothrow(const std::string& name, 
                                               bool approx,
                                               bool long_ignore_case = false,
                                               bool short_ignore_case = false) const;


        const std::vector< shared_ptr<option_description> >& options() const;

```

うーむ。わからん。まあpublicに定義されているから呼び出せるのはわかるけど。`options_description_easy_init`を見てみるか。


```
    class BOOST_PROGRAM_OPTIONS_DECL options_description_easy_init {
    public:
        options_description_easy_init(options_description* owner);

        options_description_easy_init&
        operator()(const char* name,
                   const char* description);

        options_description_easy_init&
        operator()(const char* name,
                   const value_semantic* s);
        
        options_description_easy_init&
        operator()(const char* name,
                   const value_semantic* s,
                   const char* description);
       
    private:
        options_description* owner;
    };
```

`operator()`という表現がでてきたね。これかな。

[https://qiita.com/rinse_/items/9d87d5cb0dc1e89d005e#function-call](https://qiita.com/rinse_/items/9d87d5cb0dc1e89d005e#function-call)

> 関数呼び出し演算子。この演算子はメンバ関数でなければなりません。戻り値、引数、const指定など全くの自由です。最もよく使うのは述語としてアルゴリズム関数に突っ込んだりですかね。ラムダ式にお株を奪われてしまいましたけど。
> 後は状態を持った関数をstatic変数を使わずに実現したいときなどに使います。そのようなオブジェクトをC++では特に関数オブジェクトと呼びます。

例を見てもたぶんこれと同じだけど、言っている意味がよくわからない。いや状態を持った関数を作りたいらしいけど。

[https://www.tutorialspoint.com/cplusplus/function_call_operator_overloading.htm](https://www.tutorialspoint.com/cplusplus/function_call_operator_overloading.htm)

> The function call operator () can be overloaded for objects of class type. When you overload ( ), you are not creating a new way to call a function. Rather, you are creating an operator function that can be passed an arbitrary number of parameters.

ほうほう。

ああここのexampleでわかった。わかったというか想定通りだとわかったのでよし。

## <>という表記について

```
  opt.add_options()
    ("help.h","View help")
    ("op",po::value<std::string>(),"Operator(add,sub)")
    ("lhs,l",po::value<int>(),"left")
    ("rhs,r",po::value<int>(),"right");
```


なんか前に調べ気がしないでもない`<int>`とかの表記。なんだっけ。vector?

違う気がする。

templateかな？　型指定しているし。

[https://qiita.com/hal1437/items/b6deb22a88c76eeaf90c](https://qiita.com/hal1437/items/b6deb22a88c76eeaf90c)

まあそう考えれば`lhs`が引数の時にはint型の`value()`といってるだけなので特に変な事は無いわけだけど。





