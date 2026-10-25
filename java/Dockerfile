FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
# Compile the application and download required dependencies
RUN mvn clean compile dependency:copy-dependencies

FROM eclipse-temurin:17-jre
WORKDIR /app
# Copy over our compiled classes and dependency libraries
COPY --from=builder /app/target/classes /app/classes
COPY --from=builder /app/target/dependency /app/dependency

EXPOSE 8081

# Run the 'Application' class directly from the classpath
ENTRYPOINT ["java", "-cp", "/app/classes:/app/dependency/*", "Application"]
