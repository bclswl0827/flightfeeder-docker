# FlightFeeder-Docker

使用 Mode-S Beast 的同时，向 FlightRadar24 传送 ADS-B 数据。

## 启动

部署时，FR24KEY 对应从 [flightradar24.com](https://flightradar24.com) 获取的密钥。

```
[root@BelovedZY ~]# docker network create -d bridge adsb
[root@BelovedZY ~]# docker network connect adsb flightfeeder
[root@BelovedZY ~]# docker run -d \
  -e FR24KEY="123abcdefg" \
  --name fr24feed \
  --network adsb \
  --restart always \
  -p 8754:8754 \
  bclswl0827/flightfeeder-docker:fr24feed
```

## 进入 Docker

```
[root@BelovedZY ~]# docker exec -it fr24feed /bin/bash
```

## 设置 Fr24feed

以宿主机 IP `10.10.10.10` 为例。

浏览器打开 `http://10.10.10.10:8754` 即可对 Fr24feed 进行设置。
