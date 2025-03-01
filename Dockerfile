FROM python:3.9-alpine3.13
LABEL maintainer="iodza"

ENV PYTHONUNBUFFERED 1

# Copy requirements files
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Install system dependencies
RUN apk add --no-cache build-base libffi-dev

# Create a virtual environment and install Python dependencies
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
      then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp/requirements.txt /tmp/requirements.dev.txt

# Create a non-root user
RUN adduser \
      --disabled-password \
      --no-create-home \
      django-user

# Copy application code
COPY ./app /app

# Set working directory
WORKDIR /app

# Expose port
EXPOSE 8000

# Set environment variables
ENV PATH="/py/bin:$PATH"

# Switch to the new user
USER django-user