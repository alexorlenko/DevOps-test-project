FROM maven:3.6-jdk-8

WORKDIR /app

COPY pom.xml /app/pom.xml
COPY target/OMS.war /app/OMS.war

RUN mvn clean install

ENV APP_PORT=8080
ENV JAVA_OPTS=""

CMD ["java", "-jar", "target/OMS.war"]
