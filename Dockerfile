FROM openjdk:8-jre-slim

COPY target/OMS.war /app/OMS.war

WORKDIR /app

CMD ["java", "-war", "OMS.war"]
