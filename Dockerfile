# Step 1: Use a Python base image
FROM python:3.8-slim

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy the requirements.txt to the container
COPY requirements.txt .

# Step 4: Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Step 5: Copy the application code into the container
COPY . .

# Step 6: Expose the port that Flask will run on
EXPOSE 5000

# Step 7: Set environment variables for Flask app
ENV FLASK_APP=app.py
ENV FLASK_ENV=production

# Step 8: Run the Flask application
CMD ["flask", "run", "--host=0.0.0.0"]
