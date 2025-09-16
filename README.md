# 📧 Email Management System

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Servlet](https://img.shields.io/badge/Servlet-3C873A?style=for-the-badge&logo=java&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-007396?style=for-the-badge&logo=java&logoColor=white)
![Tomcat](https://img.shields.io/badge/Tomcat-F8DC75?style=for-the-badge&logo=apache-tomcat&logoColor=black)
![Oracle](https://img.shields.io/badge/Oracle%20DB-F80000?style=for-the-badge&logo=oracle&logoColor=white)
![Eclipse](https://img.shields.io/badge/Eclipse-2C2255?style=for-the-badge&logo=eclipse&logoColor=white)
![HTML](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![CSS](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)

A comprehensive Java-based web application for efficient email management with robust authentication, advanced reporting capabilities, and seamless Oracle database integration.

## ✨ Key Features

- 🔐 **Secure Authentication System** - Complete user registration, login, and logout functionality
- ✉️ **Email Management** - Intuitive interface for adding, viewing, and organizing emails
- 📊 **Advanced Reporting** - Generate detailed reports filtered by sender, receiver, subject, and keywords
- 🎨 **Responsive UI** - Modern, user-friendly interface built with JSP, HTML, and CSS
- 💾 **Database Integration** - Robust Oracle database backend with optimized queries
- 🛡️ **Session Management** - Secure user sessions with proper authentication checks

## 🚀 Demo Walkthrough

| Step | Description | Screenshot |
|------|-------------|------------|
| 1 | **Login Page** - Secure user authentication | `screenshots/login.png` |
| 2 | **Registration** - New user account creation | `screenshots/register.png` |
| 3 | **Dashboard** - Main application interface | `screenshots/dashboard.png` |
| 4 | **Add Email** - Compose and send emails | `screenshots/add-email.png` |
| 5 | **View Emails** - Browse email history | `screenshots/view-emails.png` |
| 6 | **Reports** - Generate analytical reports | `screenshots/reports.png` |

> 💡 **Note:** Screenshots are located in the `screenshots/` directory

## 🛠️ Technology Stack

### Frontend
- **HTML5** - Semantic markup and structure
- **CSS3** - Modern styling and responsive design
- **JavaScript** - Interactive user interface elements

### Backend
- **Java Servlets** - Server-side request processing
- **JSP (JavaServer Pages)** - Dynamic web page generation
- **Oracle JDBC** - Database connectivity (`ojdbc14.jar`)

### Infrastructure
- **Apache Tomcat** - Web application server
- **Oracle Database** - Enterprise-grade data storage
- **Eclipse IDE** - Development environment

## 📁 Project Architecture

```
Email-Management-System/
├── 📂 src/main/java/Email/
│   ├── 📄 AddEmailServlet.java      # Email creation and processing
│   ├── 📄 DataConnection.java       # Database connection management
│   ├── 📄 authServlet.java          # User authentication logic
│   └── 📄 ReportServlet.java        # Report generation (if applicable)
├── 📂 src/main/webapp/
│   ├── 📄 login.html                # User login interface
│   ├── 📄 register.html             # User registration form
│   ├── 📄 home.jsp                  # Application dashboard
│   ├── 📄 addEmail.html             # Email composition form
│   ├── 📄 view.jsp                  # Email listing and management
│   ├── 📄 report_sender.jsp         # Sender-based reports
│   ├── 📄 report_receiver.jsp       # Receiver-based reports
│   ├── 📄 report_subject.jsp        # Subject-based reports
│   ├── 📂 css/                      # Stylesheet directory
│   ├── 📂 js/                       # JavaScript files
│   └── 📂 WEB-INF/
│       └── 📄 web.xml               # Servlet configuration
├── 📂 lib/
│   └── 📄 ojdbc14.jar              # Oracle JDBC driver
├── 📂 screenshots/                  # Application screenshots
└── 📄 README.md                     # Project documentation
```

## ⚙️ Installation & Setup

### Prerequisites

Ensure you have the following installed on your system:

- ☕ **Java JDK 8+** - [Download here](https://www.oracle.com/java/technologies/downloads/)
- 🐱 **Apache Tomcat 9+** - [Download here](https://tomcat.apache.org/download-90.cgi)
- 🗄️ **Oracle Database XE** - [Download here](https://www.oracle.com/database/technologies/xe-downloads.html)
- 🔧 **Eclipse IDE** - [Download here](https://www.eclipse.org/downloads/)

### Database Configuration

1. **Create Database User**
   ```sql
   -- Connect as system user
   CREATE USER email_user IDENTIFIED BY your_secure_password;
   GRANT CONNECT, RESOURCE TO email_user;
   GRANT CREATE SESSION TO email_user;
   ```

2. **Create Application Tables**
   ```sql
   -- Connect as email_user
   CREATE TABLE emails (
       id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
       sender VARCHAR2(100) NOT NULL,
       receiver VARCHAR2(100) NOT NULL,
       subject VARCHAR2(255),
       message CLOB,
       sent_date DATE DEFAULT SYSDATE,
       created_by VARCHAR2(100),
       CONSTRAINT chk_email_format CHECK (REGEXP_LIKE(sender, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'))
   );

   CREATE TABLE users (
       user_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
       username VARCHAR2(50) UNIQUE NOT NULL,
       email VARCHAR2(100) UNIQUE NOT NULL,
       password VARCHAR2(255) NOT NULL,
       created_date DATE DEFAULT SYSDATE
   );
   ```

3. **Update Database Connection**
   
   Edit `src/main/java/Email/DataConnection.java`:
   ```java
   private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:xe";
   private static final String DB_USER = "email_user";
   private static final String DB_PASSWORD = "your_secure_password";
   ```

### Application Deployment

1. **Clone the Repository**
   ```bash
   git clone https://github.com/SONURAY0900/Email-Management-System.git
   cd Email-Management-System
   ```

2. **Import into Eclipse**
   - Open Eclipse IDE
   - File → Import → Existing Projects into Workspace
   - Select the cloned directory
   - Click Finish

3. **Configure Tomcat Server**
   - Right-click project → Properties
   - Project Facets → Enable "Java" and "Dynamic Web Module"
   - Deployment Assembly → Add Tomcat libraries

4. **Deploy Application**
   - Right-click project → Run As → Run on Server
   - Select Apache Tomcat server
   - Application will be available at `http://localhost:8080/Email-Management-System`

## 🎯 Usage Guide

1. **Registration** - Create a new user account through the registration page
2. **Login** - Authenticate using your credentials
3. **Dashboard** - Access all application features from the main interface
4. **Email Management** - Add new emails or view existing ones
5. **Reporting** - Generate custom reports based on various criteria

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact & Support

- **Developer:** SONURAY0900
- **GitHub:** [@SONURAY0900](https://github.com/SONURAY0900)
- **Project Link:** [Email Management System](https://github.com/SONURAY0900/Email-Management-System)

---

<div align="center">
  <p>Made with ❤️ by SONURAY0900</p>
  <p>⭐ Star this repo if you found it helpful!</p>
</div>
