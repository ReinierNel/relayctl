FROM python:3.9

WORKDIR /relayctl

COPY api/requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /tmp/requirements.txt

CMD ["./start.sh"]