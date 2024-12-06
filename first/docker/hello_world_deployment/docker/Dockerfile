# Use a lightweight Python image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the application code to the working directory
COPY app.py /app

# Install Flask
RUN pip install Flask

# Expose the application port
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]
