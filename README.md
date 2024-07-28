# 2FA Authentication System

This project demonstrates a robust and complete 2-Factor Authentication (2FA) system implemented using Flask, Docker, MySQL, HTML, and CSS. The system includes user authentication and email verification for added security. The system is ready for integration.

## Features

- **User Registration:** Users can register an account with an email and password.
- **User Authentication:** Users can log in with their email and password.
- **2FA Verification:** After logging in, a verification code is sent to the user's email, which must be entered to complete the login process.
- **Access Grant:** Users can then have access to the home screen.
- **Dockerized Setup:** Easy setup using Docker for containerized deployment.

## Screenshots
<img width="500" alt="Screenshot 2024-07-26 at 19 35 03" src="https://github.com/user-attachments/assets/6cb58cb6-282f-4507-8a48-4b49fa085fa5">
<img width="500" alt="Screenshot 2024-07-26 at 19 35 06" src="https://github.com/user-attachments/assets/245bd643-e518-4bbf-a628-0eb0aa72f143">
<img width="500" alt="Screenshot 2024-07-26 at 19 35 27" src="https://github.com/user-attachments/assets/c2291c40-819e-4219-88a8-d17fff1a7105">
<img width="500" alt="Screenshot 2024-07-26 at 19 35 34" src="https://github.com/user-attachments/assets/181f3727-d430-4030-9fcb-831a30ce388b">
<img width="500" alt="Screenshot 2024-07-26 at 19 35 47" src="https://github.com/user-attachments/assets/946a4abc-d4a3-403b-b73e-f62028bebf8b">


## Installation

### Prerequisites

Make sure you have the following installed on your machine:

- Docker
- Docker Compose
- Python 3.8 or newer
- Node.js and npm (for frontend dependencies, if any)

### Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/YourUsername/2fa-authentication-system.git
   cd 2fa-authentication-system

2. **Create environment variables:**
Create a .env file in the root directory with the following content:

    ```bash
    FLASK_APP=app.py
    FLASK_ENV=development
    EMAIL_USER=your-email@gmail.com
    EMAIL_PASS=your-email-password
    JWT_SECRET_KEY=your_jwt_secret_key
    SQLALCHEMY_DATABASE_URI=mysql+pymysql://user:password@db/yourdatabase

3. **Set up MySQL database:**
Ensure you have a MySQL server running. You can use Docker to set up a MySQL container:

    ```bash
    docker run --name mysql-db -e MYSQL_ROOT_PASSWORD=rootpassword -e MYSQL_DATABASE=yourdatabase -p 3306:3306 -d mysql:latest
    
4. **Build and run the Docker containers:**
This will set up your Flask app and the MySQL database.

    ```bash
    docker-compose up --build

5. **Initialize the database:**
Access the Flask container and run the database migration commands.

    ```bash
    docker-compose exec web bash
    flask db init
    flask db migrate -m "Initial migration."
    flask db upgrade
    exit

# Running the Application
Once the setup is complete, you can access the application by navigating to http://localhost:5000 or http://localhost:5001 in your web browser.

# Project Structure

    2fa-authentication-system/
    │
    ├── Dockerfile
    ├── docker-compose.yml
    ├── app.py
    ├── config.py
    ├── requirements.txt
    ├── .env
    ├── templates/
    │   ├── base.html
    │   ├── index.html
    │   ├── login.html
    │   ├── verify.html
    │   └── profile.html
    └── static/
        ├── css/
        │   └── style.css
        └── images/
            ├── mobile-screenshot1.png
            ├── mobile-screenshot2.png
            ├── web-screenshot1.png
            └── web-screenshot2.png
        
### API Endpoints

- POST /login: Login endpoint
- POST /verify: Verification endpoint


### Technologies Used
- Flask
- Docker
- MySQL
- HTML
- CSS
- Python


### Contributing
- Fork the repository
- Create your feature branch (`git checkout -b feature/fooBar`)
- Commit your changes (`git commit -am 'Add some fooBar'`)
- Push to the branch (`git push origin feature/fooBar`)
- Create a new Pull Request

  
## Contact

For any queries or issues, feel free to open an issue on the repository or contact me directly at S5417966@bournemouth.ac.uk.
