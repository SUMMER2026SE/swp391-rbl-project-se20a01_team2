# Stage 1: Build the application using Maven
FROM maven:3.9.6-eclipse-temurin-11 AS builder
WORKDIR /app

# Copy the pom.xml and download dependencies to cache them
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source code and build the WAR file
COPY src ./src
RUN sed -i 's/path="\/IELTSFLOW"/path=""/' src/main/webapp/META-INF/context.xml
RUN mvn clean package -DskipTests

# Stage 2: Deploy the application using Tomcat
# Jakarta EE 10 requires Tomcat 10.1.x
FROM tomcat:10.1-jdk21

# Remove the default ROOT webapp to deploy our application at the root context path (/)
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy the built WAR file from the builder stage and name it ROOT.war
COPY --from=builder /app/target/IELTSFLOW-1.0.war /usr/local/tomcat/webapps/ROOT.war

# Default Environment Variables (from .env.example)
ENV RESEND_API_KEY="your_resend_api_key_here" \
    RESEND_SEND_DOMAIN="your_email_domain_here" \
    DB_URL="" \
    DB_HOST="localhost" \
    DB_PORT="1433" \
    DB_NAME="IELTSFLOW" \
    DB_USER="sa" \
    DB_PASSWORD="123456" \
    DB_ENCRYPT="True" \
    DB_TRUST_SERVER_CERT="True" \
    DB_EXTRA_PARAMS="sendStringParametersAsUnicode=true;characterEncoding=UTF-8" \
    SPEECH_KEY="your_key" \
    SPEECH_REGION="your_region" \
    SEPAY_BANK_ACC="your_account_number" \
    SEPAY_BANK_NAME="your_bank_name" \
    SEPAY_BANK_ACCOUNT_NAME="your_account_name" \
    SEPAY_WEBHOOK_SECRET="your_webhook_secret_key"

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
