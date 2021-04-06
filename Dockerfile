ARG PYTHON_VERSION=3.8

FROM python:latest

RUN mkdir /opt/services/

COPY . /opt/services/

WORKDIR /opt/services/application/templates/

RUN sed -i "s/{{PYTHON_VERSION}}/${PYTHON_VERSION}/g" home.html

WORKDIR /opt/services/

RUN pip3 install -r requirements.txt

EXPOSE 5000

ENTRYPOINT ["/usr/local/bin/python3", "app.py"]