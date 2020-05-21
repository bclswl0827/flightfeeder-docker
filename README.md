# FlightFeeder-Docker

Docker 版的 FlightFeeder。

本镜像可以顺利运行在所有 `armv7l` CPU 架构的设备上。

## 缘由

FlightFeeder 原版的镜像里有太多后门，安全起见，决定将其转至 Docker 中运行。

Mode-S Beast 这么香，谁还会去用 RTL-SDR 收 ADS-B 呢？

## 准备

原版树莓派镜像，并事先安装好了 Docker，**且配置好了 Docker 加速源（不然速度慢得一批）**。

将 Mode-S Beast GPS 连接到树莓派。

## 启动这个 Docker

```
[root@BelovedZY ~]# docker run -d -i -t \
	--name=FlightFeeder \
	--restart always \
	-p 0.0.0.0:8000:80 \
	--memory="32m" \
	--memory-swap="64m" \
	--oom-kill-disable \
	--privileged \
	--init \
	bclswl0827/flightfeeder-docker:latest
```

## 进入 Docker

```
[root@BelovedZY ~]# docker exec -it FlightFeeder /bin/bash
```

## 注意

由于 Docker 不能实现持久化储存，如果配置被人为更改，在第二次启动时，上一次人为更改的所有内容都将会复位。

## 看飞机

以宿主机 IP `10.10.10.10` 为例。

浏览器打开 `http://10.10.10.10:8000/dump1090-fa/` 即可看到实时航班资讯。

## 支持

觉得还可以的话就打赏一下吧～

![微信支付](https://ibcl.us/images/wechatpay.png "微信支付")
