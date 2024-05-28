# secondary build for remaining env setup
# docker build -t ubuntu_devcontainer:latest -f ./dotfile_setup.dockerfile .
ARG BASE_IMAGE
FROM ${BASE_IMAGE}
RUN curl -sSL https://gist.github.com/maxnoobineating/e42e875d0360dec9122ab5d088e66fd0.txt | /bin/zsh

# Set environment variables (optional but useful)
# ENV APP_HOME=/app
ENV PORT=8080

# Create a working directory
# WORKDIR $APP_HOME

# Copy application files into the container
# COPY . $APP_HOME

# Expose a port (if your application listens on a specific port)
EXPOSE $PORT

# Run any build or setup commands (e.g., compiling code)
# RUN make /app
ENV SHELL /bin/zsh

# Specify the default command to run when the container starts
# CMD ["source ~/.zshrc"]

