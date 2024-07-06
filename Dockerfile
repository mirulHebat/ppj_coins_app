# Use an official Flutter Docker image as a base
FROM cirrusci/flutter:stable

# Set the working directory
WORKDIR /app

# Copy the entire Flutter project into the Docker image
COPY . .

# Install dependencies
RUN flutter pub get

# Build the Flutter project in debug mode
RUN flutter build apk --debug

# Expose any necessary ports (if your Flutter app runs a server, for example)
EXPOSE 8080

# Define the default command to run your app (if applicable)
CMD ["flutter", "run"]
