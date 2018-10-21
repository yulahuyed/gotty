FROM ubuntu:latest

ENV USERNAME ""
ENV PASSWORD ""
ENV HOME "/home/user/"
ENV SSHPASS "yhiblog"
ENV GOTTY_USER "yhiblog"
ENV GOTTY_PASS "yhiblog"


RUN apt update && apt install -y build-essential python bash vim screen git net-tools \
curl software-properties-common libnss-wrapper gettext-base sudo unzip wget ssh \
man nmap apt-get install default-jdk axel aria2

RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl

RUN chmod a+rx /usr/local/bin/youtube-dl

WORKDIR $HOME

RUN mkdir -p $HOME/tool && chmod -R 777 $HOME/tool
RUN curl -o rclone.zip -L `curl -L https://rclone.org/downloads/ | grep -E ".*linux.*amd64.zip" | head -n 1 | awk -F "href" '{print $2}' | awk -F '"' '{print $2}'`
RUN unzip rclone.zip
RUN mv ./rclone*/rclone ./tool/
RUN rm -rf rclone.zip rclone-*

RUN mkdir -p $HOME/config && chmod -R 777 $HOME/config
RUN mkdir -p $HOME/goproject && chmod -R 777 $HOME/goproject
RUN curl -o go.tar.gz -L `curl -L "https://golang.org/dl/" | grep -E "dl.google.com.*linux-amd64.tar.gz" | head -n 1 | awk -F "href" '{print $2}' | awk -F '"' '{print $2}'`
RUN tar xzf go.tar.gz
RUN rm -rf go.tar.gz
RUN export GOPATH=$HOME/goproject && export PATH=$HOME/go/bin:$PATH:$GOPATH/bin
RUN go get -u github.com/golang/dep/cmd/dep
RUN go get github.com/yudai/gotty

RUN adduser --uid 1000 --gid 0 --home /home/user/ --shell /bin/bash user
RUN echo "user:$SSHPASS" | chpasswd
RUN echo "user ALL=(ALL:ALL) ALL" >> /etc/sudoers.d/user
RUN echo "user ALL=(ALL:ALL) ALL" >> /etc/sudoers
RUN chmod 0440 /etc/sudoers.d/user

RUN chmod -R 777 $HOME
RUN apt-get clean all

COPY run.sh /tmp/
ADD passwd_template /tmp/
RUN chmod +x /tmp/run.sh

EXPOSE 8080

USER 1000
CMD ["/tmp/run.sh"]
