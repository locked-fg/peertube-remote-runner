FROM node:20-slim AS runner

RUN apt-get update && \
    apt-get install -y ffmpeg python3-pip && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
RUN npm install -g @peertube/peertube-runner && \
    pip3 install whisper-ctranslate2==0.4.6 --break-system-packages

# let's use a non-root user
RUN groupadd -r peertube && \
    useradd -r -g peertube peertube
ENV HOME=/home/peertube
RUN mkdir -p $HOME && \
    chmod -R 755 $HOME && \
    chown -R peertube:peertube $HOME

# copy files and set permissions
COPY entrypoint.sh  /app/entrypoint.sh
COPY ffmpeg         /app/ffmpeg
COPY config.toml    /home/peertube/.config/peertube-runner-nodejs/default/
RUN chmod +x /app/* && \
    chown -R peertube:peertube /app $HOME
ENV PATH="/app:$PATH"

USER peertube

ENTRYPOINT ["/app/entrypoint.sh"]