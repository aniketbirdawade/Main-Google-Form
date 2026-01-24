# Main Google Form Builder

A Java‑based Google Form management and builder application that allows creation, storage, and handling of custom forms with questions, options, and responses. This project includes a backend structure for form storage and response management using a MySQL database.

## 📌 Overview

This application lets developers build, store, and manage **forms, questions, options, and responses** in a structured database. It stores all forms with metadata and supports different question types. It’s designed for educational use or to serve as a foundation for a full web UI.

## 🧠 Features

- 📄 **Form Management** – Create and organize multiple forms with titles and descriptions.
- ❓ **Questions & Options** – Add questions with multiple types and link options where needed.
- 🗃️ **Database‑Backed Storage** – Uses a relational MySQL database schema for persistence.
- 📊 **Response Tracking** – Store and query users’ form responses.
- 🛠️ **Modular Codebase** – Easily extend backend logic with REST APIs or UI.

## 🗂 Repository Structure

```
├── .settings/ 
├── build/
│   └── classes/com/formbuilder/
├── src/
│   └── main/java/com/formbuilder
├── .classpath
├── .project
├── README.md
└── … (other configurations)
```

## 🛠 Database Schema

Here’s the core database structure used by the application:

### `forms` table

| Column       | Type        | Description                  |
|--------------|-------------|------------------------------|
| form_id      | int         | Primary key                  |
| title        | varchar(255)| Form title                  |
| description  | text        | Optional description        |
| created_by   | varchar(100)| Creator identifier (opt)   |
| created_at   | timestamp   | When form was created      |

### `questions` table

| Column        | Type         | Description              |
|---------------|--------------|--------------------------|
| question_id   | int          | Primary key              |
| form_id       | int          | Associated form          |
| question_text | text         | Question text            |
| question_type | varchar(50)  | Type (e.g., “MCQ”)       |

### `options` table

| Column      | Type          | Description            |
|-------------|---------------|------------------------|
| option_id   | int           | Primary key            |
| question_id | int           | Linked question        |
| option_text | varchar(255)  | Option value/text      |

### `responses` table

| Column      | Type        | Description               |
|-------------|-------------|---------------------------|
| response_id | int         | Primary key               |
| form_id     | int         | Form that was submitted   |
| submitted_at| timestamp   | When it was submitted     |

### `answers` table

| Column       | Type      | Description                   |
|--------------|-----------|-------------------------------|
| answer_id    | int       | Primary key                   |
| response_id  | int       | Linked response              |
| question_id  | int       | Linked question              |
| answer_text  | text      | User answer text or option   |

## 💻 Getting Started

### Prerequisites

- Java 8+
- Apache Maven (optional)
- MySQL database
- Your favorite IDE (IntelliJ, Eclipse, VS Code)

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/aniketbirdawade/Main-Google-Form.git
```

2. **Set up the database**

Create a database (e.g., `form_builder`) and import tables (`forms`, `questions`, `options`, `responses`, `answers`) using provided schema.

3. **Update connection config**

Adjust database credentials in your application config (e.g., `application.properties` or JDBC connection class).

4. **Build & Run**

Use Maven/Gradle or run directly from your IDE.

```sh
mvn clean install
# OR run the main class
```

## 🚀 Usage

1. **Start the backend**
2. **Use CLI/REST endpoints** to create forms, add questions, options
3. Store and retrieve responses via your UI or API

> *Tip:* You can build a UI (React/Angular/Vue) later to connect to the backend.

## 🤝 Contributing

Contributions are welcome! Do the following:

1. Fork the repo.
2. Create a branch: `git checkout -b new‑feature`.
3. Make changes and commit: `git commit -m "Add new feature"`.
4. Push: `git push origin new‑feature`.
5. Open a Pull Request.

## 📫 Contact

If you have questions or need help:

- **GitHub:** https://github.com/aniketbirdawade/Main‑Google‑Form
