# build stage
FROM python:3.10.12-alpine3.17 as builder

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /deps                                                                                                              
COPY srv/app/requirements.txt .                                                                                       
RUN pip3 install --no-cache-dir --target=/deps -r requirements.txt 

# second stage
FROM python:3.10.12-alpine3.17 

COPY --from=builder /deps /usr/local/lib/python3.10/site-packages
COPY srv/ /srv                                                                                                         

EXPOSE 5000

ENTRYPOINT [ "python", "srv/app/web.py" ]