# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /app

# Install netcat-openbsd
RUN apt-get update && apt-get install -y netcat-openbsd

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Copy the wait-for-it script
COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

# Define environment variable
ENV FLASK_APP=app.py

# Run wait-for-it.sh before starting the Flask application
CMD ["./wait-for-it.sh", "db:3306", "--", "flask", "run", "--host=0.0.0.0"]
