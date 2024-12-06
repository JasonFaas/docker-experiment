# Use a lightweight Python image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the application code to the working directory
COPY app.py /app

# Install Flask
RUN pip install Flask
# Note that this is a single-threaded application currently.

#RUN pip install gunicorn # this is for a production server, aka a WSGI server.
    # Also, will eventually need to add the command "gunicorn --bind 0.0.0.0:5000 app:app"

# Expose the application port
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]
#CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"] # this pairs with the gunicorn pip install above if wanting a more secure server
# Also, verify running behind a reverse proxy (e.g., Nginx or AWS Application Load Balancer).
