FROM maven
WORKDIR /app
COPY . .
RUN mvn install

FROM openjdk:11.0
WORKDIR /app
COPY /app/target/calculation.war /app/
EXPOSE 9090
CMD ["java","-jar","calculation.war"]
