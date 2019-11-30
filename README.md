## Phicomm-k2-SSR


> **斐讯k2官改固件备份**

## git代理

- 打开git bash（windows）
- 输入vim ~/.gitconfig回车
- 按i进入编辑模式，将下面的内容粘贴进去
 ```
 [http]
    proxy = sock5://127.0.0.1:1080
 [https]
    proxy = sock5://127.0.0.1:1080
```

__[解决git clone速度太慢的问题（SS socks5代理）](https://blog.csdn.net/qq_37409292/article/details/83005919)__
