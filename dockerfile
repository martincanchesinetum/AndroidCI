FROM openjdk:8

WORKDIR project/



#Copy source code
RUN ls -ltr
COPY app project/
RUN ls -ltr project/
CMD ["/bin/bash"]
