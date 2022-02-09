FROM openjdk:8

WORKDIR project/



#Copy source code
RUN ls -ltr
COPY . project/
RUN ls -ltr project/
CMD ["/bin/bash"]
