# FlightFeeder-Docker

Docker 版的 FlightFeeder。

本镜像可以顺利运行在所有 `armv7l` CPU 架构的设备上。

## 缘由

FlightFeeder 原版的镜像里有太多后门，安全起见，决定将其转至 Docker 中运行。

Mode-S Beast 这么香，谁还会去用 RTL-SDR 收 ADS-B 呢？

## 准备

原版树莓派镜像，并事先安装好了 Docker，**且配置好了 Docker 加速源（不然速度慢得一批）**。

将 Mode-S Beast GPS 连接到树莓派。

```
[root@BelovedZY ~]# docker pull bclswl0827/flightfeeder-docker:latest
```

## 启动这个 Docker

```
[root@BelovedZY ~]# docker run -d -i -t \
    --name=FlightFeeder \
    --restart always \
    --hostname yuki \
    --add-host yuki:127.0.0.1 \
    -e LAT=31.17 \
    -e LON=108.40 \
    -e PASSWORD=20020204ZY. \
    -p 0.0.0.0:2222:22 \
    -p 0.0.0.0:8000:80 \
    --memory="96m" \
    --memory-swap="256m" \
    --privileged \
    bclswl0827/flightfeeder-docker:latest init
```

其中，`-e` 是环境变量，需要自己修改。以下是变量值的说明。

 - `LAT` --> `纬度`
 - `LON` --> `经度`
 - `PASSWORD` --> `用于 SSH 的密码`

## SSH 如何连接

本镜像预留的 SSH 账户名为 `meow`，用户目录位于 `/home/meow`，密码为变量 `PASSWORD` 所定义的值，如不定义，则默认为 `20020204ZY.`。

连接到这个 Docker 实例，IP 为宿主机的地址，端口为 2222.

示例如下，宿主机 IP 为 `10.10.10.10`。

```
ssh meow@10.10.10.10 -p 2222
```

## 注意

SSH 仅用于调试，由于 Docker 不能实现持久化储存，如果配置被人为更改，在第二次启动时，上一次人为更改的所有内容都将会复位。

## 看飞机

仍以宿主机 IP `10.10.10.10` 为例。

浏览器打开 `http://10.10.10.10:8000/dump1090-fa/` 即可看到实时航班资讯。

## 支持

觉得还可以的话就打赏一下吧～

![微信支付](https://ibcl.us/images/wechatpay.png "微信支付")
