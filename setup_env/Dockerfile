FROM ubuntu:latest

RUN apt-get update && apt-get install -y make neovim
WORKDIR /root
ADD ./neovim.tar.gz /root
RUN ls -l
RUN make install
