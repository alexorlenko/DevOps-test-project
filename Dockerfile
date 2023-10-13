FROM maven:3.6-jdk-8

WORKDIR /app

COPY ./ /app

RUN mvn clean install

ENV APP_PORT=8080
ENV JAVA_OPTS=""

CMD ["java", "-jar", "target/OMS.war"]
