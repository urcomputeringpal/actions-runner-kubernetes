FROM nektos/act-environments-ubuntu:18.04

# Add our installation script
COPY install.sh /root/

# Install and update the system in one tidy layer
ARG ACTIONS_RUNNER_VERSION="2.169.1"
ENV ACTIONS_RUNNER_VERSION=$ACTIONS_RUNNER_VERSION
RUN /bin/bash /root/install.sh

# Run as the runner user instead of root
USER runner
WORKDIR /home/runner
COPY *.sh ./
RUN /bin/bash ./test.sh
ENTRYPOINT ["/bin/bash", "./entrypoint.sh"]
