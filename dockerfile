FROM openjdk:8

WORKDIR project/



#Copy source code
RUN ls -ltr
RUN ls -ltr app
COPY app $HOME/src

CMD ["/bin/bash"]
