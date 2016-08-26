FROM anapsix/alpine-java:jdk
MAINTAINER Viktor Eriksson <viktor.eriksson2@gmail.com>

# CMD "sh" "-c" "echo nameserver 8.8.8.8 > /etc/resolv.conf"

# Nodejs
RUN apk add --update nodejs

# Boot
RUN apk --update add curl patch ca-certificates \
&& curl -fsSLo /usr/local/bin/boot https://github.com/boot-clj/boot-bin/releases/download/latest/boot.sh \
&& chmod 755 /usr/local/bin/boot

# Set environment variable to indicate that it is running in CI
ENV CI true

COPY boot-react-native /m2/mattsum/boot-react-native/
COPY boot.properties /home/
ENV BOOT_HOME /.boot
ENV BOOT_AS_ROOT yes
ENV BOOT_LOCAL_REPO /m2
ENV BOOT_JVM_OPTIONS=-Xmx2g

RUN (mkdir /temp && cd temp && curl -Lo build.boot https://raw.githubusercontent.com/mjmeintjes/boot-react-native/master/example/build.boot)
RUN (cd temp && boot build)
RUN cd temp && boot build || true && cd ..

RUN mkdir /app
WORKDIR /app
RUN boot web -s doesnt/exist 
RUN boot repl -e '(System/exit 0)'

# Installs boot-react-native
# RUN mkdir brn
# RUN curl -L https://github.com/mjmeintjes/boot-react-native/archive/de752982cfc850f80c67ee472b3891b404844221.tar.gz | tar xz -C brn
# RUN (cd brn && boot install)
