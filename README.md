# DevOps Final Project

A simple web application demonstrating DevOps practices with Docker, Jenkins, and Nginx.

## Features

- Containerized application using Docker
- CI/CD pipeline with Jenkins
- Nginx web server
- Development and Production environments
- Health monitoring
- Simple responsive web design

## Tech Stack

- Nginx
- Docker
- Jenkins
- HTML/CSS

## Getting Started

### Development Environment

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/devops-final-project.git
   cd devops-final-project
   ```

2. Start the development environment:
   ```bash
   docker-compose -f docker-compose.development.yml up --build
   ```

3. Access the application at `http://localhost:8084`

### Production Environment

1. Build and start the production environment:
   ```bash
   docker-compose -f docker-compose.production.yml up --build
   ```

2. Access the application at `http://localhost:83`

## Project Structure

```
├── Jenkinsfile
├── Dockerfile
├── nginx.conf
├── docker-compose.yml
├── docker-compose.development.yml
├── docker-compose.production.yml
├── logs/
├── templates/
│   ├── index.html
│   └── static/
└── static/
    ├── waving-hand.png
    └── Devop-workflow.jpg
```

## Health Checks

The application includes health monitoring:
- Endpoint: `/health`
- Check interval: 30s
- Timeout: 10s
- Retries: 3

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- Your Name - Initial work

## 🙏 Acknowledgments

- DevOps best practices
- Docker documentation
- Jenkins documentation
- Nginx documentation 