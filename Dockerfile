# springboot-maven3-centos
#
# This image provide a base for running Spring Boot based applications. It
# provides a base Java 8 installation and Maven 3.

FROM openshift/base-centos7

EXPOSE 8080

ENV JAVA_VERSON 1.8.0
ENV MAVEN_VERSION 3.3.9
ENV HTTP_PROXY 172.31.56.100:8089
ENV HTTPS_PROXY 172.31.56.100:8089  

LABEL io.k8s.description="Platform for building and running Spring Boot applications" \
      io.k8s.display-name="Spring Boot Maven 3" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,java,java8,maven,maven3,springboot"

RUN yum update -y && \
  yum install -y curl && \
  yum install -y java-$JAVA_VERSON-openjdk java-$JAVA_VERSON-openjdk-devel && \
  yum clean all

RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV JAVA_HOME /usr/lib/jvm/java
ENV MAVEN_HOME /usr/share/maven

# Add configuration files, bashrc and other tweaks
COPY ./s2i/bin/ $STI_SCRIPTS_PATH
COPY ./run/ $STI_SCRIPTS_PATH

RUN chown -R 1001:0 /opt/app-root
RUN chmod +x $STI_SCRIPTS_PATH/run
USER 1001



#Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage


#RUN $STI_SCRIPTS_PATH/assemble
#CMD $STI_SCRIPTS_PATH/run
#CMD java -Xmx64m -Xss1024k -jar /opt/app-root/src/target/eureka-1.0-SNAPSHOT.jar
