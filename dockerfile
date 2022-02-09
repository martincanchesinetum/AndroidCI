FROM openjdk:8

WORKDIR project/



#Copy source code
RUN ls -ltr
COPY app $HOME/src
RUN ls -ltr app
CMD ["/bin/bash"]
