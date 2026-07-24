# IELTSFLOW - Installation and Configuration Guide (NetBeans 25)

This guide provides step-by-step instructions to set up, configure, and run the IELTSFLOW web application using Apache NetBeans 25.

## 1. Prerequisites

Before starting, ensure you have the following installed on your system:

- **Java Development Kit (JDK) 21**: The project is configured to compile and run with Java 21.
- **Apache NetBeans 25**: The IDE used for development.
- **Apache Tomcat 10.1.x** (or later): The project uses Jakarta EE 10 APIs, which are supported by Tomcat 10.1+.
- **Microsoft SQL Server**: The database system used for this project.

## 2. Database Setup

1. Open your SQL Server Management Studio (SSMS) or any other SQL client.
2. Create a new database. The default name expected is `IELTSFLOW` (you can change this later in the `.env` file).
3. Execute the provided `schema.sql` (located in the root directory of the project) against the newly created database to set up the necessary tables and initial data.

## 3. Opening the Project in NetBeans 25

1. Launch **Apache NetBeans 25**.
2. Go to **File** > **Open Project...** (or press `Ctrl+Shift+O`).
3. Navigate to the directory containing the project.
4. Select the `IELTSFLOW` directory (it should have a small Maven icon `m` next to it) and click **Open Project**.
5. Wait for NetBeans to download all required Maven dependencies (this may take a few minutes the first time). You can monitor the progress in the bottom right corner.

## 4. Environment Configuration

The application uses a `.env` file to securely load configuration variables like database credentials and API keys.

1. In NetBeans, expand the project tree and navigate to `Web Pages` > `WEB-INF` (or `src/main/webapp/WEB-INF/` in the Files view).
2. Locate the `.env.example` file.
3. Duplicate this file and rename the copy to `.env`.
4. Open the `.env` file and update the following core configurations:

```ini
# Database configuration for JPA
DB_HOST=localhost
DB_PORT=1433
DB_NAME=IELTSFLOW
DB_USER=sa        # Replace with your SQL Server username
DB_PASSWORD=123456 # Replace with your SQL Server password
DB_ENCRYPT=True
DB_TRUST_SERVER_CERT=True
```

### 4.1. Additional API Keys Configuration

To ensure all features work properly, you need to configure various third-party API keys in your `.env` file:

- **Azure Speech Services**: Used for audio and speech features. Get keys from the [Azure Portal](https://portal.azure.com/).
  ```ini
  SPEECH_KEY=your_key
  SPEECH_REGION=your_region
  ```
- **Resend (Email Service)**: Used for sending automated emails. Create an API key at [Resend](https://resend.com/).
  ```ini
  RESEND_API_KEY=your_resend_api_key
  RESEND_SEND_DOMAIN=your_verified_domain
  ```
- **Gemini AI**: Used for AI-related features. Get an API key from [Google AI Studio](https://aistudio.google.com/).
  ```ini
  GEMINI_API_KEYS=your_gemini_api_key
  ```
- **Google Authentication**: Used for OAuth login. Get a Client ID from the [Google Cloud Console](https://console.cloud.google.com/).
  ```ini
  GOOGLE_CLIENT_ID=your_google_client_id
  ```
- **SePay**: Used for processing payments. Configure your bank account details and webhook secret from [SePay](https://sepay.vn/).
  ```ini
  SEPAY_BANK_ACC=your_account_number
  SEPAY_BANK_NAME=your_bank_name
  SEPAY_BANK_ACCOUNT_NAME=your_account_name
  SEPAY_WEBHOOK_SECRET=your_webhook_secret_key
  ```

## 5. Configuring the Web Server in NetBeans

1. In NetBeans, switch to the **Services** tab (usually on the left panel, next to Projects and Files).
2. Expand the **Servers** node. If you don't see your Tomcat 10.1 server listed:
   - Right-click on **Servers** and select **Add Server...**
   - Choose **Apache Tomcat or TomEE** and click **Next**.
   - Browse to your Tomcat 10.1 installation directory.
   - Set up the administrator username and password (optional but recommended) and click **Finish**.

## 6. Project Server Association

1. Right-click on the `IELTSFLOW` project in the **Projects** tab.
2. Select **Properties**.
3. In the Project Properties window, select the **Run** category on the left.
4. In the **Server** dropdown, select the server you configured in the previous step (e.g., `Apache Tomcat 10.1.x`).
5. Ensure the **Java EE Version** is set correctly (Jakarta EE 10 Web).
6. Context Path should be `/IELTSFLOW`.
7. Click **OK** to save the settings.

## 7. Build and Run

1. Right-click the `IELTSFLOW` project and select **Clean and Build**. Ensure the build succeeds without errors in the Output window.
2. To run the application, right-click the project and select **Run** (or press `F6`).
3. NetBeans will deploy the `.war` file to the configured server and launch your default web browser.
4. The application should be accessible at: `http://localhost:8080/IELTSFLOW` (port may vary depending on your Tomcat configuration).

## Troubleshooting

- **Database Connection Errors**: Double-check the DB credentials in the `WEB-INF/.env` file and ensure SQL Server TCP/IP protocol is enabled via SQL Server Configuration Manager (default port 1433).
- **UnsupportedClassVersionError**: Ensure that NetBeans is running on JDK 21 and the project's compile/run platform is set to JDK 21. Go to Project Properties -> Build -> Compile -> Java Platform.
- **Class Not Found / Deployment Errors**: Make sure you are using a server that supports Jakarta EE 10 (like Tomcat 10.1+). Tomcat 9 or earlier will **not** work due to the `javax` to `jakarta` namespace migration.
