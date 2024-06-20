# Use the Python 3.6 slim base image
FROM python:3.6-slim

# Provisioning, install necessary packages without gdal
RUN apt-get -qq update \
    && apt-get install -y --no-install-recommends \
        wget git tmux vim locales less \
        binutils \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen

# Upgrade pip§
RUN pip3 install --upgrade pip

# Install specific version of pandas
RUN pip3 install pandas==1.2.6

# Initialize the application directory
RUN mkdir -p /app
WORKDIR /app

# Output the list of files in the working directory
RUN ls -la /app