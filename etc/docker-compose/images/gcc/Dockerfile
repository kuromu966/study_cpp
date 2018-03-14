FROM centos:centos7

# RUN yum -y install gcc \
#         	   gcc-c++ \
# 		   automake \
# 		   make \
# 		   libtool \
# 		   cppunit \
# 		   cppunit-devel \
# 		   valgrind \
# 		   gdb \
# 		   strace

RUN yum -y install gcc \
        	   gcc-c++ \
		   automake \
		   make \
		   libtool \
		   cppunit \
		   cppunit-devel

RUN yum install -y centos-release-scl \
    		   centos-release-scl-rh
RUN yum install -y devtoolset-7-gcc \
    		   devtoolset-7-gcc-c++ \
		   devtool \
		   devtoolset-7-valgrind \
		   devtoolset-7-strace devtoolset-7-gdb \
		   devtoolset-7-gcc-gdb-plugin

RUN yum -y install wget
ARG boost_version=1.66.0
ARG boost_file=boost_1_66_0
RUN cd /tmp \
    && scl enable devtoolset-7 bash \
    && wget https://dl.bintray.com/boostorg/release/${boost_version}/source/${boost_file}.tar.gz --no-check-certificate \
    && tar xfz ${boost_file}.tar.gz \
    && rm ${boost_file}.tar.gz \
    && cd ${boost_file} \
    && ./bootstrap.sh \
    && ./b2 --without-python --prefix=/usr -j 4 link=shared runtime-link=shared install \
    && cd .. \
    && rm -rf ${boost_file} \
    && ldconfig

