FROM node:20-slim AS runner

RUN apt-get update && \
    apt-get install -y ffmpeg python3-pip && \
    rm -rf /var/lib/apt/lists/*

#RUN npm install -g @peertube/peertube-runner@${PEERTUBE_RUNNER_VERSION:-"0.0.22"} && \
RUN npm install -g @peertube/peertube-runner && \
    pip3 install whisper-ctranslate2==0.4.6 --break-system-packages

ENV PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE="whisper-ctranslate2"
ENV PEERTUBE_RUNNER_TRANSCRIPTION_MODEL="tiny"
ENV PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE_PATH="/usr/local/bin/whisper-ctranslate2"

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
# force some ffmpeg params
COPY ffmpeg /app/ffmpeg
RUN chmod +x /app/ffmpeg
ENV PATH="/app:$PATH"

ENTRYPOINT ["/app/entrypoint.sh"]

ARG DOCKER_USER
USER ${DOCKER_USER}
