FROM openjdk:8-jre-alpine
COPY target/OMS.war /app/OMS.war
WORKDIR /app
CMD ["java", "-jar", "OMS.war"]
