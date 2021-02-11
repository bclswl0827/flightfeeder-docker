# FlightFeeder-Docker

Docker 版的 FlightFeeder。

## 缘由

FlightFeeder 原版的镜像里有太多后门，安全起见，决定将其转至 Docker 中运行。

Mode-S Beast 这么香，谁还会去用 RTL-SDR 收 ADS-B 呢？

## 启动

其中，LAT 和 LON 变量需要设定为自己所在地的坐标，否则航班无法正常显示。

```
[root@BelovedZY ~]# docker run -d \
  --device /dev/ttyUSB0 \
  --device /dev/ttyUSB1 \
  --name flightfeeder \
  --restart always \
  -p 80:80 \
  -p 8080:8080 \
  -p 30005:30005 \
  -e LAT="31.492837" \
  -e LON="121.338541" \
  bclswl0827/flightfeeder-docker:latest
```

## 进入 Docker

```
[root@BelovedZY ~]# docker exec -it flightfeeder /bin/bash
```

## 看飞机

以宿主机 IP `10.10.10.10` 为例。

浏览器打开 `http://10.10.10.10/dump1090-fa/` 即可看到实时航班资讯。
