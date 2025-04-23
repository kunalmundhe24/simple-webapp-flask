# Use an official Python runtime as the base image
FROM python:3.12-slim

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container
COPY . .

# Install Flask
RUN pip install --no-cache-dir flask

# Expose the port your app runs on
EXPOSE 5050

# Run the application
CMD ["python", "app.py"]
