---
trigger: always_on
---

# Project Architecture and Code Organization Ruleset

This ruleset serves as a guideline for organizing new code and maintaining the existing architecture. The project follows a classic MVC (Model-View-Controller) and 3-Tier Architecture using Jakarta EE (Servlets/JSPs) and Hibernate ORM.

## 1. Directory Structure

The project uses a standard Maven directory layout. All source code must be placed accordingly:

- **`src/main/java/`**: Contains all Java source code (Backend).
- **`src/main/resources/`**: Contains configuration files (e.g., Hibernate config, Quartz properties).
- **`src/main/webapp/`**: Contains all web assets (JSPs, CSS, JS, HTML) and the `WEB-INF` directory.

## 2. Java Package Organization (`src/main/java/`)

Code should be strictly separated by its architectural layer and responsibility. Do not mix database logic with request handling.

### `models` (Entity Layer)
- **Role:** Represents database tables as Java objects (POJOs).
- **Rules:**
  - Classes must be annotated with JPA annotations (e.g., `@Entity`, `@Table`).
  - Keep logic minimal; these should primarily contain fields, getters, setters, and constructors.
  - Examples: `User.java`, `Product.java`, `Order.java`.

### `dao` (Data Access Object Layer)
- **Role:** Handles all direct database interactions (CRUD operations) using Hibernate.
- **Rules:**
  - Naming Convention: Must end with `DAO` (e.g., `UserDAO`, `ProductDAO`).
  - No business logic should reside here.
  - Methods should accept and return `models` objects or standard data types.

### `services` (Business Logic Layer)
- **Role:** Contains the core business rules. It acts as a bridge between Controllers and DAOs.
- **Rules:**
  - Naming Convention: Must end with `Service`. If using interfaces, the implementation should end in `ServiceImpl` (e.g., `OrderService` and `OrderServiceImpl`).
  - Transactions should ideally be managed at this layer.
  - Controllers should only interact with Services, not directly with DAOs.

### `controller` (Presentation / Web Layer)
- **Role:** Jakarta EE Servlets that handle incoming HTTP requests, delegate work to Services, and return responses or forward to JSP views.
- **Rules:**
  - Naming Convention: Must end with `Servlet` (e.g., `LoginServlet`, `AdminProductServlet`).
  - Keep controllers thin. Extract complex logic into the `services` package.
  - Differentiate between Admin and User controllers by prefixing (e.g., `AdminOrderServlet` vs `UserOrderServlet`).

### `util` (Utility Layer)
- **Role:** Reusable helper classes and configuration bootstrappers.
- **Rules:**
  - Should contain static helper methods or singletons.
  - Examples: `JpaHelper` (for EntityManager creation), `VNPayUtil` (payment processing helpers), `ResendUtil` (email).

### `filter` (Middleware Layer)
- **Role:** Servlet Filters that intercept requests/responses.
- **Rules:**
  - Use for cross-cutting concerns like Authentication checking, Authorization, Logging, or Encoding (UTF-8).


### `listener` (Application Lifecycle Layer)
- **Role:** Servlet Context Listeners.
- **Rules:**
  - Use for running tasks on application startup or shutdown (e.g., initializing schedulers, cleaning up connections).

## 3. Web Assets Organization (`src/main/webapp/`)

- **Root Level (`/`)**: Minimal files, such as `index.html` to bootstrap or redirect.
- **`/jsp/`**: All JSP views should be placed here (e.g., `/jsp/subscription.jsp`). Admin views must go under the `admin` subdirectory (e.g., `/jsp/admin/dashboard.jsp`). You may further group other views into subdirectories if needed.
- **`/css/`**: All custom CSS stylesheets.
- **`/js/`**: All custom JavaScript files.
- **`/WEB-INF/`**: Configuration files (like `web.xml`), views that should not be directly accessible via URL, and environment configuration (the `.env` file must be placed here).

## 4. General Coding Guidelines
- **Dependency Management:** All external libraries must be declared in `pom.xml`.
- **Environment Variables:** Use `.env` files for secrets (like database credentials, API keys) via the `dotenv-java` library. Do not hardcode sensitive information. Store the `.env` file securely in `src/main/webapp/WEB-INF/`.
- **View Technologies:** Use JSTL (Jakarta Standard Tag Library) and EL (Expression Language) in JSPs instead of scriptlets (`<% ... %>`).
