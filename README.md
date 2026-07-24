# IELTSFlow

**IELTSFlow** is a comprehensive, web-based platform designed to support IELTS learning and test preparation across all four skills (Listening, Reading, Writing, Speaking). The system integrates Artificial Intelligence (AI) to address common challenges such as the lack of practice environments, the absence of personalized learning paths, and long wait times for grading.

## 🚀 Key Features

*   **Four Skills Evaluation:** Practice and mock tests covering Listening, Reading, Writing, and Speaking.
*   **AI-Powered Placement Test & Learning Pathway:** Candidates take an initial placement test, and based on their current score and target band, the AI automatically generates a personalized, week-by-week study plan.
*   **Automated AI Scoring & Feedback:** Utilizes advanced AI (Azure Speech SDK, Gemini AI) to automatically grade Speaking tests, predict band scores, and provide detailed feedback.
*   **Role-Based Access Control:**
    *   **Guest:** View landing page, subscription pricing, and authenticate.
    *   **Candidate (Student):** Take tests, manage target bands, view AI pathways, and purchase subscriptions.
    *   **Mentor (Instructor):** Manage the question bank, test materials, and support candidates.
    *   **Admin:** Manage users, subscriptions, system configurations, and view analytics.
*   **Automated Subscriptions:** Automated premium package activation and payment verification via SePay webhooks.

## 🛠️ Technology Stack

**Backend & Architecture (MVC, 3-Tier):**
*   **Language:** Java 21
*   **Framework:** Jakarta EE 10 (Servlets, JSP, JSTL)
*   **ORM:** Hibernate 6.6
*   **Database:** Microsoft SQL Server
*   **Build Tool:** Maven

**Third-Party Integrations & APIs:**
*   **Microsoft Azure Cognitive Services (Speech SDK):** For Speech-to-Text and pronunciation assessment.
*   **Gemini AI:** For generating personalized learning pathways and advanced evaluations.
*   **Resend:** For reliable transactional email delivery.
*   **Google OAuth:** For seamless social login integration.
*   **SePay:** For automated payment processing via webhooks.
*   **BCrypt:** For secure password hashing.

**Testing & Quality Assurance:**
*   **Unit & Integration Testing:** JUnit 5, Mockito
*   **Code Coverage:** JaCoCo
*   **UI/E2E Testing:** Selenium WebDriver
*   **In-Memory Database:** H2 Database (for isolated integration tests)

## ⚙️ Installation & Setup

Please refer to the [INSTALLATION.md](INSTALLATION.md) file for detailed, step-by-step instructions on how to set up the database, configure environment variables, and run the project using Apache NetBeans 25 and Tomcat 10.1+.

## 🧪 Testing

The project includes comprehensive test suites (Integration and Unit tests) that ensure the reliability of core components such as the Speech Assessment module and Payment integration.

To run all tests via Maven:
```bash
mvn clean test
```

To generate a code coverage report using JaCoCo:
```bash
mvn jacoco:report
```
The report will be available at `target/site/jacoco/index.html`.

For more details on testing the Speech Assessment module and Payment integrations, please refer to the [GUIDE.md](GUIDE.md) document.

## 📁 Additional Documentation
For more in-depth documentation about the system's design, initial requirements, and API guidelines, please check the `Document/` folder in the root workspace.
